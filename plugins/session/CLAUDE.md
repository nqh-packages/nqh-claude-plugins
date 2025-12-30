# Session Plugin

## Overview

Session management plugin for Claude Code. Enables `/session:restart` and `/session:fork` commands that work without any arguments.

## Architecture

```
session/
├── .claude-plugin/plugin.json    # Plugin manifest (declares hooks)
├── hooks/
│   ├── hooks.json                # SessionStart hook declaration
│   └── session-capture.sh        # Captures session_id on session start
├── commands/
│   ├── restart.md                # /session:restart
│   ├── fork.md                   # /session:fork (asks for new task)
│   └── configure.md              # /session:configure
├── lib.sh                        # Shared bash functions
├── config.json                   # User configuration
└── README.md
```

## Session Flow

```
Session starts
    ↓
SessionStart hook fires
    ↓
session-capture.sh captures session_id to temp file
    ↓
User runs /session:restart or /session:fork
    ↓
lib.sh reads session_id from temp file
    ↓
Opens new terminal tab with `claude --resume <id>`
```

**Temp file location**: `${TMPDIR:-/tmp}/claude-sessions-$(id -u)/${TERM_SESSION_ID}`

## Key Functions (lib.sh)

| Function | Purpose |
|----------|---------|
| `ensure_config` | Load config.json or prompt for setup |
| `get_session_info` | Read session_id from temp file |
| `build_command` | Build `claude --resume` command |
| `execute_restart` | Open new tab and run command |
| `execute_fork` | Open new tab with --fork-session |

## Portability

- Uses `${CLAUDE_PLUGIN_ROOT}` for all paths
- No hardcoded directories
- Works when installed from any marketplace
