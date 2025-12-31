# Session Plugin

Intelligently restart, fork, or delegate your Claude Code sessions with beautiful UI feedback.

<!-- VISUAL -->
![Demo: typing /session:restart shows green SESSION RESUMED banner, /session:fork shows orange SESSION FORKED banner](assets/demo.gif)
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
| `/session:fork [prompt]` | Branch off with context (needs our discussion) |
| `/session:spawn [prompt]` | Delegate to new agent (no context needed) |
| `/session:id` | Show current session ID |
| `/session:configure` | Setup preferences |

### `/session:fork` vs `/session:spawn`

| Command | Context | Use case |
|---------|---------|----------|
| `fork` | Inherits conversation | Task needs what we discussed |
| `spawn` | Fresh start | Delegate unrelated task to new agent |

Both support smart prompt handling - Claude reads your message, considers context, and refines:

| Input | Result |
|-------|--------|
| `/session:fork` | Interactive - asks what to work on |
| `/session:fork fix the bug` | Understands, refines, executes |

## Skills

| Skill | When it activates |
|-------|-------------------|
| `delegating` | When deciding between subagent vs fork/spawn |
| `restarting-sessions` | When Claude Code needs config reload |

### Why Fork/Spawn Instead of Subagent?

Use fork/spawn (not Task tool) when:
- **Task is too big** - would exceed subagent context limits
- **Task needs user interaction** - subagents can't ask questions
- **Task needs to nest subagents** - subagents can't spawn subagents

## How It Works

```
SessionStart hook → captures session_id → temp file
                                              ↓
/session:restart  ────────────────────→ reads temp file → opens new tab (resume)
/session:fork     ────────────────────→ reads temp file → opens new tab (forked)
/session:spawn    ────────────────────→ uses config only → opens new tab (fresh)
/session:id       ────────────────────→ reads temp file → shows ID
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

**v3.2.0** · Added skills: `delegating`, `restarting-sessions`
