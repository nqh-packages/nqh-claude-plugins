---
description: Configure session plugin settings
allowed-tools: Bash, AskUserQuestion, Write, Read
---

# Session Plugin Configuration

Interactive setup for session management behavior.

## Step 1: Check current state

Run this script to gather current configuration:

```bash
PLUGIN_DIR="${CLAUDE_PLUGIN_ROOT}"
CONFIG_FILE="$PLUGIN_DIR/config.json"

echo "SESSION_CONFIGURE_DATA_START"
echo "{"

# Check if config exists
if [[ -f "$CONFIG_FILE" ]]; then
  echo "\"config_exists\": true,"
  echo "\"current_config\": $(cat "$CONFIG_FILE"),"
else
  echo "\"config_exists\": false,"
  echo "\"current_config\": null,"
fi

# Check if session file exists (hook working)
TERMINAL_ID="${TERM_SESSION_ID:-pid-$$}"
SAFE_ID="${TERMINAL_ID//[^a-zA-Z0-9_-]/}"
SESSION_FILE="${TMPDIR:-/tmp}/claude-sessions-$(id -u)/$SAFE_ID"
if [[ -f "$SESSION_FILE" ]]; then
  echo "\"session_captured\": true,"
  echo "\"session_id\": \"$(head -1 "$SESSION_FILE")\""
else
  echo "\"session_captured\": false,"
  echo "\"session_id\": null"
fi

echo "}"
echo "SESSION_CONFIGURE_DATA_END"
```

## Step 2: Analyze state and ask user

Parse the JSON between `SESSION_CONFIGURE_DATA_START` and `SESSION_CONFIGURE_DATA_END`.

### If no session captured yet

The SessionStart hook hasn't captured a session yet. Tell the user:
"Session plugin is installed! The hook will capture the session ID when you start a new session."

### If session captured (working)

Show success and ask about config changes:

```
Question: "Session plugin is working! What would you like to configure?"
Header: "Settings"
Options:
- "Auto-execute" / "Toggle automatic tab opening (current: {value})"
- "Terminal" / "Change terminal app (current: {value})"
- "Flags" / "Edit extra claude flags (current: {value})"
- "Done" / "Keep current settings"
multiSelect: true
```

## Step 3: Configure settings

Based on user selections, update `${CLAUDE_PLUGIN_ROOT}/config.json`:

```json
{
  "auto_execute": true,
  "clipboard": true,
  "terminal": "auto",
  "model": "",
  "flags": "--dangerously-skip-permissions"
}
```

### Config options:

| Setting | Values | Description |
|---------|--------|-------------|
| `auto_execute` | `true`/`false` | Open new tab automatically |
| `clipboard` | `true`/`false` | Copy command to clipboard |
| `terminal` | `"auto"`/`"iterm"`/`"terminal"` | Terminal app for auto-execute |
| `model` | `""`/`"opus"`/`"sonnet"` | Model override for resumed session |
| `flags` | string | Extra flags like `--dangerously-skip-permissions` |

## Step 4: Display confirmation

```
    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
    ▓                                              ▓
    ▓    ✓  CONFIGURATION SAVED                   ▓
    ▓                                              ▓
    ▓    Auto-execute: {value}                    ▓
    ▓    Terminal: {value}                        ▓
    ▓    Flags: {value}                           ▓
    ▓                                              ▓
    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
```
