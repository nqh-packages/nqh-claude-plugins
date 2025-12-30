# Session Plugin

Restart or fork your current Claude session. No arguments needed.

## Installation

```bash
# Add marketplace
claude /plugin marketplace add /path/to/nqh-claude-plugins

# Install plugin
claude /plugin install session@nqh-plugins
```

## Commands

| Command | Description |
|---------|-------------|
| `/session:restart` | Resume this session in new terminal tab |
| `/session:fork` | Fork session to new terminal tab with new task |
| `/session:configure` | Configure auto-execute, terminal, and flags |

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                     Session Plugin                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SessionStart Hook ───▶ Captures session_id to temp file   │
│         │                                                   │
│         ▼                                                   │
│  /session:restart ───▶ Reads temp file ───▶ Opens new tab  │
│  /session:fork    ───▶ Reads temp file ───▶ Opens new tab  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Self-contained**: The plugin includes its own SessionStart hook. No external dependencies.

## Configuration

Run `/session:configure` or edit `config.json`:

| Setting | Default | Description |
|---------|---------|-------------|
| `auto_execute` | `true` | Open new tab automatically |
| `clipboard` | `true` | Also copy command to clipboard |
| `terminal` | `"auto"` | Terminal app (`auto`/`iterm`/`terminal`) |
| `model` | `""` | Model override (empty = inherit) |
| `flags` | `""` | Extra flags for `claude` command |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "No session captured" | Start a new session (hook runs on SessionStart) |
| Auto-execute not working | Check `auto_execute: true` in config.json |
| Wrong terminal opens | Set `terminal: "iterm"` or `terminal: "terminal"` |

## Requirements

- macOS (for AppleScript tab automation)
- `jq` (for JSON parsing)
- iTerm2 or Terminal.app
