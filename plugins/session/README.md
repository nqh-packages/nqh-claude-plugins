# Session Plugin

Restart or fork your Claude Code session with beautiful UI feedback.

<!-- VISUAL -->
![Session Plugin Demo](assets/demo.gif)
<!-- /VISUAL -->

**Requirements**: macOS · `jq` · iTerm2 or Terminal.app

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

## Add Plugin

```
/plugin install session@nqh-plugins
```

## Commands

| Command | What it does |
|---------|--------------|
| `/session:restart` | Resume session in new terminal tab |
| `/session:fork [prompt]` | Fork session with new task |
| `/session:configure` | Setup preferences |

### `/session:fork`

Smart prompt handling - Claude reads your message, considers context, and refines:

| Input | Result |
|-------|--------|
| `/session:fork` | Interactive - asks what to work on |
| `/session:fork fix the bug` | Understands, refines, executes |

## How It Works

```
SessionStart hook → captures session_id → temp file
                                              ↓
/session:restart  ────────────────────→ reads temp file → opens new tab
/session:fork     ────────────────────→ reads temp file → opens new tab (forked)
```

## Configuration

Preferences saved to:
- **Project**: `.claude/.session-plugin-config.json` (higher priority)
- **User**: `~/.claude/.session-plugin-config.json` (fallback)

| Setting | Values | Description |
|---------|--------|-------------|
| `auto_execute` | `true`/`false` | Open new tab automatically |
| `clipboard` | `true`/`false` | Copy command to clipboard |
| `terminal` | `auto`/`iterm`/`terminal` | Terminal app |
| `model` | `""`/`opus`/`sonnet` | Model override |
| `flags` | string | Extra flags (e.g., `--dangerously-skip-permissions`) |

---

**v3.0.3** · Fixed banners · Smart fork prompts · User/project config
