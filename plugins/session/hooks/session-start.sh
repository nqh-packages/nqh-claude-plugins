#!/usr/bin/env bash
# @what Combined SessionStart hook: captures session ID and introduces skills
# @why Single hook ensures output is visible to Claude

# 1. Capture session ID (silent)
input=$(cat)
session_id=$(printf '%s' "$input" | jq -r '.session_id // empty')
project_dir=$(printf '%s' "$input" | jq -r '.cwd // empty')

if [[ -n "$session_id" && "$session_id" != "null" ]]; then
  SESSION_DIR="${TMPDIR:-/tmp}/claude-sessions-$(id -u)"
  mkdir -p -m 700 "$SESSION_DIR" 2>/dev/null

  TERMINAL_ID="${TERM_SESSION_ID:-pid-$$}"
  SAFE_ID="${TERMINAL_ID//[^a-zA-Z0-9_-]/}"
  SESSION_FILE="$SESSION_DIR/$SAFE_ID"

  # Write session info (skip if symlink attack detected)
  if [[ ! -L "$SESSION_FILE" ]]; then
    printf '%s\n%s\n' "$session_id" "${project_dir:-$(pwd)}" > "$SESSION_FILE"
  fi
fi

# 2. Output skills context (visible to Claude)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/skills-context.sh"
