#!/usr/bin/env bash
# @what Captures session_id from Claude Code on session start
# @why Self-contained session tracking for /session:restart and /session:fork

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')
project_dir=$(echo "$input" | jq -r '.cwd // empty')

# Exit silently if no session_id
[[ -z "$session_id" || "$session_id" == "null" ]] && exit 0

# Create secure session directory
SESSION_DIR="${TMPDIR:-/tmp}/claude-sessions-$(id -u)"
mkdir -p -m 700 "$SESSION_DIR" 2>/dev/null

# Terminal-specific file (supports multiple concurrent sessions)
TERMINAL_ID="${TERM_SESSION_ID:-pid-$$}"
SAFE_ID="${TERMINAL_ID//[^a-zA-Z0-9_-]/}"
SESSION_FILE="$SESSION_DIR/$SAFE_ID"

# Write session info (skip if symlink attack detected)
if [[ ! -L "$SESSION_FILE" ]]; then
  printf '%s\n%s\n' "$session_id" "${project_dir:-$(pwd)}" > "$SESSION_FILE"
fi

exit 0
