---
name: restarting-sessions
description: Activates when Claude Code needs restarting. Triggers when user configured new hook, new agent, new skill, or other config changes that require reload.
version: 1.0.0
---

# When to Restart Claude Code

## Restart When

Claude Code needs restarting after configuration changes:

- User just configured a new hook
- User just added a new subagent
- User just created or modified a skill
- User just changed Claude Code settings
- User just installed or updated a plugin
- Any config change that requires reload

## NOT for Delegation

This is for reloading Claude Code, not for offloading work. For task delegation, see the `delegating` skill.

## Execute

```bash
source "${CLAUDE_PLUGIN_ROOT}/lib.sh"
ensure_config && get_session_info && build_command restart && execute_restart
```

This reopens the same session in a new terminal with fresh config loaded.
