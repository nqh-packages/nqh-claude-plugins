---
description: Configure session plugin settings
allowed-tools: Bash, AskUserQuestion, Write, Read
---

# Session Plugin Configuration

Interactive setup for session management behavior.

## Step 1: Check current state

Run this script to gather current configuration:

```bash
PROJECT_CFG="$(pwd)/.claude/.session-plugin-config.json"
USER_CFG="$HOME/.claude/.session-plugin-config.json"

echo "SESSION_CONFIGURE_DATA_START"
echo "{"

# Determine which config is active
if [[ -f "$PROJECT_CFG" ]]; then
  echo "\"config_source\": \"project\","
  echo "\"config_path\": \"$PROJECT_CFG\","
  echo "\"current_config\": $(cat "$PROJECT_CFG"),"
elif [[ -f "$USER_CFG" ]]; then
  echo "\"config_source\": \"user\","
  echo "\"config_path\": \"$USER_CFG\","
  echo "\"current_config\": $(cat "$USER_CFG"),"
else
  echo "\"config_source\": \"none\","
  echo "\"config_path\": null,"
  echo "\"current_config\": null,"
fi

# Check project and user paths
echo "\"project_cfg_path\": \"$PROJECT_CFG\","
echo "\"user_cfg_path\": \"$USER_CFG\","

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

### If no config exists yet

First ask where to save:

```
Question: "Where should the config be saved?"
Header: "Scope"
Options:
- "User" / "Apply to all projects (~/.claude/.session-plugin-config.json)"
- "Project" / "This project only (.claude/.session-plugin-config.json)"
multiSelect: false
```

### If config already exists

Show current config source (user or project) and ask about changes:

```
Question: "Session plugin is configured ({source}). What would you like to do?"
Header: "Settings"
Options:
- "Auto-execute" / "Toggle automatic tab opening (current: {value})"
- "Terminal" / "Change terminal app (current: {value})"
- "Flags" / "Edit extra claude flags (current: {value})"
- "Change scope" / "Move config between user/project"
- "Done" / "Keep current settings"
multiSelect: true
```

## Step 3: Configure settings

### Default config template

```json
{
  "auto_execute": true,
  "clipboard": true,
  "terminal": "auto",
  "model": "",
  "flags": ""
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

### Save locations:

| Scope | Path |
|-------|------|
| User | `~/.claude/.session-plugin-config.json` |
| Project | `.claude/.session-plugin-config.json` (in cwd) |

**IMPORTANT**: Create `.claude/` directory if it doesn't exist before writing.

## Step 4: Display confirmation

```
    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
    ▓                                              ▓
    ▓    ✓  CONFIGURATION SAVED                   ▓
    ▓                                              ▓
    ▓    Scope: {user|project}                     ▓
    ▓    Path: {actual_path}                       ▓
    ▓                                              ▓
    ▓    Auto-execute: {value}                     ▓
    ▓    Terminal: {value}                         ▓
    ▓    Flags: {value}                            ▓
    ▓                                              ▓
    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
```
