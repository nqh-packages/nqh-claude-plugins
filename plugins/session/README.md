# Session Plugin

Intelligently restart, fork, or delegate your Claude Code sessions with beautiful UI feedback.

<!-- VISUAL -->
![Demo: typing /session:restart shows green SESSION RESUMED banner, /session:fork shows orange SESSION FORKED banner](assets/demo.gif)
<!-- /VISUAL -->

**Requirements**: macOS, `jq`, iTerm2 or Terminal.app

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

## Add Plugin

```
/plugin install session@nqh-plugins
```

## When Subagents Aren't Enough

The Task tool has limits:

| You need... | But subagents can't... |
|-------------|------------------------|
| Large refactor | Handle big context - hit limits mid-task |
| Clarifying questions | Interact with user - run without input |
| Nested delegation | Spawn subagents - single level only |

When you hit these, use fork or spawn instead.

## Commands

| Command | Purpose |
|---------|---------|
| `/session:fork [task]` | New terminal WITH conversation context |
| `/session:spawn [task]` | New terminal FRESH, no history |
| `/session:restart` | Continue same session in new terminal |
| `/session:id` | Show current session ID |
| `/session:configure` | Setup preferences |

### Fork vs Spawn

| Command | Context | Use when |
|---------|---------|----------|
| `fork` | Inherits conversation | Task relates to what we discussed |
| `spawn` | Clean slate | Task is independent |

Both create full sessions that can interact with user and spawn their own subagents.

## Decision Tree

```
About to use Task tool?
│
├── Small, focused, no user input needed?
│   └── Subagent is fine
│
└── Big / needs user input / needs nested subagents?
    ├── Related to conversation? → /session:fork
    └── Independent task?        → /session:spawn
```

## Skills

**`delegating`** - Activates when considering Task tool. Helps decide if fork/spawn is better, asks with options based on conversation context.

**`restarting-sessions`** - Activates after config changes (new hooks, agents, skills) that need reload.

## Config

Saved to `.claude/.session-plugin-config.json` (project) or `~/.claude/.session-plugin-config.json` (user).

| Setting | Values | Default |
|---------|--------|---------|
| `terminal` | `auto`/`iterm`/`terminal` | `auto` |
| `auto_execute` | `true`/`false` | `true` |
| `model` | `""`/`opus`/`sonnet` | inherit |
| `flags` | string | `""` |

---

**v3.2.0** · Added delegation skills, SessionStart hook for skill intro
