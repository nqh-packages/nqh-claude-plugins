#!/usr/bin/env bash
# @what Session plugin shared library
# @why DRY - avoid duplicating logic across commands

# ═══════════════════════════════════════════════════════════════════════════════
# FRAME RENDERING SYSTEM
# Uses explicit padding for terminal compatibility (cursor positioning not
# supported in all terminal emulators)
# ═══════════════════════════════════════════════════════════════════════════════

# Layout constants
declare -r FRAME_WIDTH=48
declare -r FRAME_INDENT=4
declare -r CONTENT_MAX=42           # Max content chars (48 - 2 borders - 4 padding)
declare -r INNER_WIDTH=46           # Inner width (48 - 2 borders)

# Color palette
declare -r C_RESET="\033[0m"
declare -r C_BLUE="\033[38;5;75m"
declare -r C_GREEN="\033[38;5;107m"
declare -r C_ORANGE="\033[38;5;209m"
declare -r C_PURPLE="\033[38;5;141m"
declare -r C_DIM="\033[38;5;245m"
declare -r C_RED="\033[38;5;203m"

# ─────────────────────────────────────────────────────────────────────────────
# Primitives - unified rendering building blocks
# ─────────────────────────────────────────────────────────────────────────────

# Solid bar (top or bottom border)
_bar() {
  local color="${1:-$C_BLUE}"
  printf "%${FRAME_INDENT}s${color}" ""
  printf '▓%.0s' {1..48}
  printf "${C_RESET}\n"
}

# Empty line inside frame (just side borders)
_framed_empty() {
  local color="${1:-$C_BLUE}"
  printf "%${FRAME_INDENT}s${color}▓%${INNER_WIDTH}s▓${C_RESET}\n" "" ""
}

# Content line inside frame - uses explicit padding for compatibility
_framed_line() {
  local text="$1"
  local color="${2:-$C_BLUE}"
  local style="${3:-}"  # "bold", "dim", or empty

  # Auto-truncate if too long
  if [[ ${#text} -gt $CONTENT_MAX ]]; then
    text="${text:0:$((CONTENT_MAX-3))}..."
  fi

  # Calculate padding needed (INNER_WIDTH - 2 left pad - 2 right pad - text length)
  local text_len=${#text}
  local pad_len=$(( INNER_WIDTH - 4 - text_len ))
  [[ $pad_len -lt 0 ]] && pad_len=0

  # Left border + padding
  printf "%${FRAME_INDENT}s${color}▓${C_RESET}  " ""

  # Apply style
  case "$style" in
    bold) printf "\033[1m" ;;
    dim)  printf "${C_DIM}" ;;
  esac

  # Content
  printf "%s" "$text"

  # Reset style
  [[ -n "$style" ]] && printf "${C_RESET}"

  # Right padding + border
  printf "%${pad_len}s  ${color}▓${C_RESET}\n" ""
}

# Bare centered text (no side borders)
# Usage: _bare_center "text" [emoji_count] [style]
_bare_center() {
  local text="$1"
  local emoji_count="${2:-0}"
  local style="${3:-}"

  # Calculate padding: center within FRAME_WIDTH, offset by FRAME_INDENT
  # Subtract emoji_count because each emoji displays as 2 cols but counts as 1
  local text_width=$(( ${#text} + emoji_count ))
  local pad=$(( (FRAME_WIDTH - text_width) / 2 + FRAME_INDENT ))
  [[ $pad -lt 0 ]] && pad=0

  # Apply style
  case "$style" in
    bold) printf "\033[1m" ;;
    dim)  printf "${C_DIM}" ;;
  esac

  printf "%${pad}s%s" "" "$text"

  # Reset style
  [[ -n "$style" ]] && printf "${C_RESET}"

  printf "\n"
}

# ─────────────────────────────────────────────────────────────────────────────
# High-level frame renderer
# Usage: render_frame COLOR "line1" "line2" ...
# Special syntax:
#   ""         = empty line
#   ">text"    = bold centered title (best-effort centering)
#   "~text"    = dim text
# ─────────────────────────────────────────────────────────────────────────────

render_frame() {
  local color="$1"
  shift

  echo ""
  echo ""
  _bar "$color"
  _framed_empty "$color"

  for line in "$@"; do
    if [[ -z "$line" ]]; then
      _framed_empty "$color"
    elif [[ "$line" == ">"* ]]; then
      # Centered bold title - best effort centering
      local title="${line#>}"
      local len=${#title}
      local pad=$(( (CONTENT_MAX - len) / 2 ))
      [[ $pad -lt 0 ]] && pad=0
      local centered
      centered=$(printf "%${pad}s%s" "" "$title")
      _framed_line "$centered" "$color" "bold"
    elif [[ "$line" == "~"* ]]; then
      # Dim text
      _framed_line "${line#\~}" "$color" "dim"
    else
      _framed_line "$line" "$color"
    fi
  done

  _framed_empty "$color"
  _bar "$color"
  echo ""
  echo ""
}

# Truncate text with ellipsis if too long
truncate() {
  local text="$1"
  local max="${2:-$CONTENT_MAX}"
  if [[ ${#text} -gt $max ]]; then
    echo "${text:0:$((max-3))}..."
  else
    echo "$text"
  fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

CONFIG_FILE=""

ensure_config() {
  local project_cfg="$(pwd)/.claude/.session-plugin-config.json"
  local user_cfg="$HOME/.claude/.session-plugin-config.json"

  if [[ -f "$project_cfg" ]]; then
    CONFIG_FILE="$project_cfg"
  elif [[ -f "$user_cfg" ]]; then
    CONFIG_FILE="$user_cfg"
  else
    render_frame "$C_ORANGE" \
      ">⚙  SETUP REQUIRED" \
      "" \
      "Run /session:configure to get started"
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

# ═══════════════════════════════════════════════════════════════════════════════
# SESSION MANAGEMENT
# ═══════════════════════════════════════════════════════════════════════════════

show_error() {
  local msg="$1"
  echo ""
  echo -e "    ${C_RED}▓▓▓ ERROR ▓▓▓${C_RESET}"
  echo -e "    ${C_DIM}$msg${C_RESET}"
  echo ""
}

get_session_info() {
  [[ -n "$TERM_SESSION_ID" ]] && TERMINAL_ID="$TERM_SESSION_ID" || TERMINAL_ID="pid-$$"
  local SAFE_TERMINAL_ID="${TERMINAL_ID//[^a-zA-Z0-9_-]/}"
  local SESSION_DIR="${TMPDIR:-/tmp}/claude-sessions-$(id -u)"
  local SESSION_FILE="$SESSION_DIR/$SAFE_TERMINAL_ID"

  if [[ ! -f "$SESSION_FILE" ]]; then
    show_error "No session captured yet."
    echo -e "    ${C_DIM}The SessionStart hook captures session IDs automatically.${C_RESET}"
    echo -e "    ${C_DIM}Try starting a new session, or run /session:configure.${C_RESET}"
    return 1
  fi

  SESSION_ID=$(head -1 "$SESSION_FILE")
  PROJECT_DIR=$(tail -1 "$SESSION_FILE")

  [[ -z "$SESSION_ID" || "$SESSION_ID" == "null" ]] && show_error "Invalid session ID in capture file" && return 1
  [[ ! "$SESSION_ID" =~ ^[a-zA-Z0-9_-]+$ ]] && show_error "Bad session format: $SESSION_ID" && return 1
  [[ ! -d "$PROJECT_DIR" ]] && PROJECT_DIR="$(pwd)"
  export SESSION_ID PROJECT_DIR
}

show_session_id() {
  if [[ "$USE_CLIPBOARD" == "true" ]]; then
    # Clipboard enabled: show ID inside frame
    render_frame "$C_BLUE" "🔑  $SESSION_ID"
    copy_to_clipboard "$SESSION_ID"
  else
    # No clipboard: bare centered lines for triple-click selection
    echo ""
    echo ""
    _bar "$C_BLUE"
    echo ""
    _bare_center "$SESSION_ID"
    echo ""
    _bar "$C_BLUE"
    echo ""
    _bare_center "🔑  triple-click to copy" 1 dim
    echo ""
    echo ""
  fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# COMMAND BUILDING
# ═══════════════════════════════════════════════════════════════════════════════

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

build_spawn_command() {
  local SAFE_DIR=$(printf '%q' "$(pwd)")
  local FLAGS=""
  [[ -n "$CLAUDE_FLAGS" ]] && FLAGS="$CLAUDE_FLAGS "
  [[ -n "$MODEL" ]] && FLAGS="${FLAGS}--model $MODEL "

  CMD="cd $SAFE_DIR && claude ${FLAGS}"
  CMD="${CMD% }"  # Trim trailing space
  export CMD
}

# ═══════════════════════════════════════════════════════════════════════════════
# CLIPBOARD
# ═══════════════════════════════════════════════════════════════════════════════

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
  [[ "$copied" == "true" ]] && echo -e "    ${C_GREEN}✓ Copied to clipboard${C_RESET}"
}

output_command() {
  local mode="${1:-restart}"
  local action_hint
  [[ "$mode" == "fork" ]] && action_hint="Open new tab → paste" || action_hint="Exit (Ctrl+C) → paste"

  echo ""
  echo ""
  echo -e "    ${C_ORANGE}▓▓▓${C_RESET} \033[1mCOMMAND\033[0m ${C_DIM}(triple-click to select)${C_RESET}"
  echo ""
  echo -e "\033[38;5;252m$CMD${C_RESET}"
  echo ""
  [[ "$USE_CLIPBOARD" == "true" ]] && copy_to_clipboard "$CMD"
  echo -e "    ${C_DIM}$action_hint${C_RESET}"
  echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# TERMINAL AUTOMATION
# ═══════════════════════════════════════════════════════════════════════════════

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

# ═══════════════════════════════════════════════════════════════════════════════
# EXECUTION
# ═══════════════════════════════════════════════════════════════════════════════

execute_restart() {
  if [[ "$AUTO_EXECUTE" != "true" ]]; then
    output_command restart
    return
  fi

  if open_tab_and_run "$CMD"; then
    render_frame "$C_GREEN" \
      ">✓  SESSION RESUMED" \
      "" \
      "Continuing in new tab" \
      "You can safely close this one" \
      "" \
      "⌘W  or  exit"
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
    local lines=(">⑂  SESSION FORKED" "" "New branch opened in new tab")
    if [[ -n "$prompt" ]]; then
      lines+=("~Prompt: $(truncate "$prompt" 33)")
    fi
    render_frame "$C_ORANGE" "${lines[@]}"
  else
    show_error "Could not open new tab. Falling back to manual mode."
    [[ -n "$prompt" ]] && CMD="$fork_cmd"
    output_command fork
  fi
}

execute_spawn() {
  local prompt="${1:-}"

  if [[ "$AUTO_EXECUTE" != "true" ]]; then
    output_command spawn
    return
  fi

  local spawn_cmd="$CMD"
  if [[ -n "$prompt" ]]; then
    local escaped
    escaped=$(printf '%s' "$prompt" | sed "s/'/'\\\\''/g")
    spawn_cmd="$spawn_cmd '$escaped'"
  fi

  if open_tab_and_run "$spawn_cmd"; then
    local lines=(">✦  SESSION SPAWNED" "" "Fresh session opened in new tab")
    if [[ -n "$prompt" ]]; then
      lines+=("~Prompt: $(truncate "$prompt" 33)")
    fi
    render_frame "$C_PURPLE" "${lines[@]}"
  else
    show_error "Could not open new tab. Falling back to manual mode."
    [[ -n "$prompt" ]] && CMD="$spawn_cmd"
    output_command spawn
  fi
}
