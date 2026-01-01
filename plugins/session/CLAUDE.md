# Session Plugin

## Overview

Session management plugin for Claude Code. Enables `/session:restart`, `/session:fork`, and `/session:spawn` commands with intelligent skills for delegation decisions.

## Architecture

```
session/
├── .claude-plugin/plugin.json    # Plugin manifest (declares hooks)
├── hooks/
│   ├── hooks.json                # SessionStart + PreToolUse hooks
│   ├── session-capture.sh        # Captures session_id on session start
│   ├── skills-intro.sh           # Introduces skills to Claude
│   └── task-reminder.sh          # PreToolUse reminder for Task tool
├── commands/
│   ├── restart.md                # /session:restart
│   ├── fork.md                   # /session:fork (asks for new task)
│   ├── spawn.md                  # /session:spawn (fresh context)
│   └── configure.md              # /session:configure
├── skills/
│   ├── delegating/SKILL.md       # When to fork/spawn vs subagent
│   └── restarting-sessions/SKILL.md  # When Claude Code needs reload
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
| `execute_spawn` | Open new tab with fresh context |

## Hooks

| Event | Purpose |
|-------|---------|
| `SessionStart` | Captures session_id, introduces skills |
| `PreToolUse (Task)` | Nudges Claude to consider `session:delegating` skill |

## Skills

### `delegating`
Activates when Claude considers using Task tool for delegation. Helps decide if fork/spawn is better than subagent when:
- Task is too big for subagent context
- Task needs user interaction
- Task needs to nest subagents

### `restarting-sessions`
Activates after config changes (new hook, agent, skill, plugin) that require Claude Code reload.

## Portability

- Uses `${CLAUDE_PLUGIN_ROOT}` for all paths
- No hardcoded directories
- Works when installed from any marketplace
