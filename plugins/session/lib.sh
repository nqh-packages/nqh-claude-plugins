#!/usr/bin/env bash
# @what Session plugin shared library
# @why DRY - avoid duplicating logic across commands

# Banner constants
BANNER_WIDTH=48
CONTENT_WIDTH=42  # Width between borders (48 - 2 borders - 4 padding)

# Pad text to fixed width (left-aligned)
pad_left() {
  local text="$1"
  local width="${2:-$CONTENT_WIDTH}"
  printf "%-${width}s" "$text"
}

# Center text within width
center_text() {
  local text="$1"
  local width="${2:-$CONTENT_WIDTH}"
  local text_len=${#text}
  local pad_total=$((width - text_len))
  local pad_left=$((pad_total / 2))
  local pad_right=$((pad_total - pad_left))
  printf "%*s%s%*s" "$pad_left" "" "$text" "$pad_right" ""
}

# Truncate text with ellipsis if too long
truncate() {
  local text="$1"
  local max="${2:-$CONTENT_WIDTH}"
  if [[ ${#text} -gt $max ]]; then
    echo "${text:0:$((max-3))}..."
  else
    echo "$text"
  fi
}

# Config locations: project-first fallback to user
CONFIG_FILE=""

ensure_config() {
  local project_cfg="$(pwd)/.claude/.session-plugin-config.json"
  local user_cfg="$HOME/.claude/.session-plugin-config.json"

  # Project config takes priority, fallback to user config
  if [[ -f "$project_cfg" ]]; then
    CONFIG_FILE="$project_cfg"
  elif [[ -f "$user_cfg" ]]; then
    CONFIG_FILE="$user_cfg"
  else
    # No config found - show setup message
    local C="\033[38;5;209m"  # Color (orange)
    local R="\033[0m"          # Reset
    local B="\033[1;38;5;209m" # Bold
    local W="\033[1;37m"       # White bold
    local title="⚙  SETUP REQUIRED"
    local centered_title=$(center_text "$title")
    echo ""
    echo ""
    echo -e "    ${C}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓${R}  ${B}${centered_title}${R}  ${C}▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓${R}  $(pad_left "Run /session:configure to get started")  ${C}▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${R}"
    echo ""
    echo ""
    return 1
  fi

  # Load config values
  AUTO_EXECUTE=$(jq -r '.auto_execute // true' "$CONFIG_FILE")
  USE_CLIPBOARD=$(jq -r '.clipboard // true' "$CONFIG_FILE")
  TERMINAL_OVERRIDE=$(jq -r '.terminal // "auto"' "$CONFIG_FILE")
  MODEL=$(jq -r '.model // ""' "$CONFIG_FILE")
  CLAUDE_FLAGS=$(jq -r '.flags // ""' "$CONFIG_FILE")
  export AUTO_EXECUTE USE_CLIPBOARD TERMINAL_OVERRIDE MODEL CLAUDE_FLAGS CONFIG_FILE
}

show_error() {
  local msg="$1"
  echo ""
  echo -e "    \033[38;5;203m▓▓▓ ERROR ▓▓▓\033[0m"
  echo -e "    \033[38;5;245m$msg\033[0m"
  echo ""
}

get_session_info() {
  [[ -n "$TERM_SESSION_ID" ]] && TERMINAL_ID="$TERM_SESSION_ID" || TERMINAL_ID="pid-$$"
  local SAFE_TERMINAL_ID="${TERMINAL_ID//[^a-zA-Z0-9_-]/}"
  local SESSION_DIR="${TMPDIR:-/tmp}/claude-sessions-$(id -u)"
  local SESSION_FILE="$SESSION_DIR/$SAFE_TERMINAL_ID"

  if [[ ! -f "$SESSION_FILE" ]]; then
    show_error "No session captured yet."
    echo -e "    \033[38;5;245mThe SessionStart hook captures session IDs automatically.\033[0m"
    echo -e "    \033[38;5;245mTry starting a new session, or run /session:configure.\033[0m"
    return 1
  fi

  SESSION_ID=$(head -1 "$SESSION_FILE")
  PROJECT_DIR=$(tail -1 "$SESSION_FILE")

  [[ -z "$SESSION_ID" || "$SESSION_ID" == "null" ]] && show_error "Invalid session ID in capture file" && return 1
  [[ ! "$SESSION_ID" =~ ^[a-zA-Z0-9_-]+$ ]] && show_error "Bad session format: $SESSION_ID" && return 1
  [[ ! -d "$PROJECT_DIR" ]] && PROJECT_DIR="$(pwd)"
  export SESSION_ID PROJECT_DIR
}

build_command() {
  local mode="${1:-restart}"
  local SAFE_DIR=$(printf '%q' "$PROJECT_DIR")
  local SAFE_ID=$(printf '%q' "$SESSION_ID")
  local FLAGS=""
  [[ -n "$CLAUDE_FLAGS" ]] && FLAGS="$CLAUDE_FLAGS "
  [[ -n "$MODEL" ]] && FLAGS="${FLAGS}--model $MODEL "

  if [[ "$mode" == "fork" ]]; then
    CMD="cd $SAFE_DIR && claude ${FLAGS}--resume $SAFE_ID --fork-session"
  else
    CMD="cd $SAFE_DIR && claude ${FLAGS}--resume $SAFE_ID"
  fi
  export CMD
}

copy_to_clipboard() {
  local text="$1"
  local copied=false
  if command -v pbcopy &>/dev/null; then
    echo "$text" | pbcopy && copied=true
  elif command -v wl-copy &>/dev/null; then
    echo "$text" | wl-copy && copied=true
  elif command -v xclip &>/dev/null; then
    echo "$text" | xclip -selection clipboard && copied=true
  elif command -v xsel &>/dev/null; then
    echo "$text" | xsel --clipboard --input && copied=true
  fi
  [[ "$copied" == "true" ]] && echo -e "    \033[38;5;107m✓ Copied to clipboard\033[0m"
}

output_command() {
  local mode="${1:-restart}"
  local action_hint
  [[ "$mode" == "fork" ]] && action_hint="Open new tab → paste" || action_hint="Exit (Ctrl+C) → paste"

  echo ""
  echo ""
  echo -e "    \033[38;5;209m▓▓▓\033[0m \033[1mCOMMAND\033[0m \033[38;5;245m(triple-click to select)\033[0m"
  echo ""
  echo -e "\033[38;5;252m$CMD\033[0m"
  echo ""
  [[ "$USE_CLIPBOARD" == "true" ]] && copy_to_clipboard "$CMD"
  echo -e "    \033[38;5;245m$action_hint\033[0m"
  echo ""
}

detect_terminal() {
  if [[ -n "$TERMINAL_OVERRIDE" && "$TERMINAL_OVERRIDE" != "auto" ]]; then
    echo "$TERMINAL_OVERRIDE"
    return
  fi
  case "${TERM_PROGRAM:-}" in
    iTerm.app) echo "iterm" ;;
    *) echo "terminal" ;;
  esac
}

open_tab_and_run() {
  local cmd="$1"
  local exit_code

  if [[ "$(detect_terminal)" == "iterm" ]]; then
    osascript <<EOF 2>/dev/null
tell application "iTerm"
  tell current window
    create tab with default profile
    tell current session to write text "$cmd"
  end tell
end tell
EOF
    exit_code=$?
  else
    osascript <<EOF 2>/dev/null
tell application "Terminal"
  activate
  tell application "System Events" to keystroke "t" using command down
  delay 0.3
  do script "$cmd" in front window
end tell
EOF
    exit_code=$?
  fi

  [[ $exit_code -ne 0 ]] && return 1
  return 0
}

execute_restart() {
  if [[ "$AUTO_EXECUTE" != "true" ]]; then
    output_command restart
    return
  fi

  if open_tab_and_run "$CMD"; then
    local C="\033[38;5;107m"  # Color
    local R="\033[0m"          # Reset
    local B="\033[1;38;5;107m" # Bold
    local title="✓  SESSION RESUMED"
    local centered_title=$(center_text "$title")
    echo ""
    echo ""
    echo -e "    ${C}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓${R}  ${B}${centered_title}${R}  ${C}▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓${R}  $(pad_left "Continuing in new tab")  ${C}▓${R}"
    echo -e "    ${C}▓${R}  $(pad_left "You can safely close this one" )  ${C}▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓${R}  $(pad_left "⌘W  or  exit")  ${C}▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${R}"
    echo ""
    echo ""
  else
    show_error "Could not open new tab. Falling back to manual mode."
    output_command restart
  fi
}

execute_fork() {
  local prompt="${1:-}"

  if [[ "$AUTO_EXECUTE" != "true" ]]; then
    output_command fork
    return
  fi

  local fork_cmd="$CMD"
  if [[ -n "$prompt" ]]; then
    local escaped
    escaped=$(printf '%s' "$prompt" | sed "s/'/'\\\\''/g")
    fork_cmd="$fork_cmd '$escaped'"
  fi

  if open_tab_and_run "$fork_cmd"; then
    local C="\033[38;5;209m"  # Color (orange)
    local R="\033[0m"          # Reset
    local B="\033[1;38;5;209m" # Bold
    local D="\033[38;5;245m"   # Dim
    local title="⑂  SESSION FORKED"
    local centered_title=$(center_text "$title")
    echo ""
    echo ""
    echo -e "    ${C}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓${R}  ${B}${centered_title}${R}  ${C}▓${R}"
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓${R}  $(pad_left "New branch opened in new tab")  ${C}▓${R}"
    if [[ -n "$prompt" ]]; then
      local prompt_line="Prompt: $(truncate "$prompt" 33)"
      echo -e "    ${C}▓${R}  ${D}$(pad_left "$prompt_line")${R}  ${C}▓${R}"
    fi
    echo -e "    ${C}▓${R}                                              ${C}▓${R}"
    echo -e "    ${C}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${R}"
    echo ""
    echo ""
  else
    show_error "Could not open new tab. Falling back to manual mode."
    [[ -n "$prompt" ]] && CMD="$fork_cmd"
    output_command fork
  fi
}
