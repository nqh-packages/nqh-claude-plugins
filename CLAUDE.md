# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Claude Code plugin marketplace. Plugins installed via:

```
/plugin marketplace add /path/to/nqh-claude-plugins
/plugin install <plugin-name>@nqh-plugins
```

## Commands

```bash
bun install           # Setup (activates git hooks)
bun run build:readme  # Regenerate root README from plugins
```

## Structure

```
nqh-claude-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Registry of all plugins
├── .husky/
│   └── pre-push              # Blocks push if README outdated
├── plugins/
│   └── <plugin-name>/
│       ├── .claude-plugin/
│       │   └── plugin.json   # Manifest (name, version, hooks)
│       ├── commands/         # Slash commands (*.md)
│       ├── hooks/
│       │   ├── hooks.json    # Hook declarations
│       │   └── *.sh          # Hook scripts
│       ├── lib.sh            # Shared bash functions
│       ├── CLAUDE.md         # Plugin-specific context
│       └── README.md         # Plugin docs (one-liner + visual)
├── scripts/
│   └── build-readme.mjs      # Generates root README from plugins
└── README.md                 # Auto-generated plugin catalog
```

## Adding a New Plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json`:
```json
{
  "name": "<name>",
  "version": "1.0.0",
  "description": "...",
  "hooks": "./hooks/hooks.json"
}
```

2. Register in `.claude-plugin/marketplace.json`

3. Create `plugins/<name>/README.md` with:
   - One-liner description (first line after `# Title`)
   - Visual banner (first code block)

4. Push triggers `build:readme` automatically via pre-push hook

## README Auto-Generation

The root README is generated from plugin READMEs:
- Extracts one-liner (first non-empty line after title)
- Extracts visual (first code block)
- Pre-push hook blocks if README is outdated

## Command Format

```markdown
---
description: What the command does
allowed-tools: Bash, Read, Write
---

# Command Name

Instructions for Claude...
```

## Hooks

Use `${CLAUDE_PLUGIN_ROOT}` for portable paths:

```json
{
  "hooks": {
    "SessionStart": [{
      "hooks": [{
        "type": "command",
        "command": "${CLAUDE_PLUGIN_ROOT}/hooks/script.sh"
      }]
    }]
  }
}
```

## Version Bumping

When modifying a plugin:
1. `plugins/<name>/.claude-plugin/plugin.json` - bump version
2. `.claude-plugin/marketplace.json` - sync version
3. `plugins/<name>/README.md` - update version at bottom

## Testing

Reinstall to update cache:
```
/plugin uninstall session@nqh-plugins
/plugin install session@nqh-plugins
```

Or test directly:
```bash
source plugins/session/lib.sh && execute_restart
```

## Conventions

| Pattern | Purpose |
|---------|---------|
| `lib.sh` | Shared bash functions |
| `CLAUDE.md` | Per-plugin Claude context |
| `${CLAUDE_PLUGIN_ROOT}` | Portable path in hooks |
| `CONTENT_WIDTH=42` | Banner width (48 - borders - padding) |
