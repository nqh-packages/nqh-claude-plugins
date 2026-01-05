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
│   ├── pre-commit            # Auto-syncs README when plugin READMEs change
│   └── post-commit           # Auto-pushes to remote after commit
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
  "version": "0.1.0",
  "description": "...",
  "hooks": "./hooks/hooks.json"
}
```

**Versioning**: Start at `0.1.0` for new plugins (pre-release). Bump to `1.0.0` when stable and battle-tested.

2. Register in `.claude-plugin/marketplace.json`

3. Create `plugins/<name>/README.md` following the format below

4. Commit triggers `build:readme` automatically via pre-commit hook

## Plugin README Format

```markdown
# Plugin Name

One-liner description (extracted to root README).

<!-- VISUAL -->
![Demo](assets/demo.gif)
<!-- /VISUAL -->

**Requirements**: dependencies...

## Add Marketplace

\`\`\`
/plugin marketplace add nqh-packages/nqh-claude-plugins
\`\`\`

## Add Plugin

\`\`\`
/plugin install plugin-name@nqh-plugins
\`\`\`

## Commands
...

---

**vX.X.X** · changelog notes
```

| Element | Purpose | Propagates to Root |
|---------|---------|-------------------|
| Title | Plugin name | Yes (as link) |
| One-liner | First line after title | Yes |
| `<!-- VISUAL -->` | Image, GIF, or code block | Yes (path adjusted) |
| Requirements | Dependencies | No |
| Add Marketplace | Marketplace command | No (root has it) |
| Add Plugin | Install command | Yes |
| Commands/docs | Usage details | No |
| Version | Bottom of file | No |

**VISUAL markers**: Wrap any visual (image, GIF, code block) in `<!-- VISUAL -->` and `<!-- /VISUAL -->`. Image paths are auto-converted for root README.

**GIF tip**: For GIFs, add "Right-click → Play Animation" hint in the first frame (title card) for Safari users where autoplay is disabled.

## README Auto-Generation

The root README is generated from plugin READMEs:
- Extracts one-liner (first non-empty line after title)
- Extracts install command (`/plugin install {name}@nqh-plugins`)
- Extracts visual content between `<!-- VISUAL -->` markers
- Converts relative image paths to `./plugins/{name}/...`
- Pre-commit hook auto-stages README.md when plugin READMEs change

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

## Cross-Plugin Skill References

Agents in one plugin can reference skills from another plugin using the `skills:` frontmatter field. This enables modular plugin architecture with core + addon patterns.

**How it works:**
- Skills are loaded from the cache at `/Users/huy/.claude/plugins/cache/<marketplace>/<plugin>/<version>/skills/`
- The `skills:` field in agent frontmatter accepts skill names from any installed plugin
- Skills are resolved by name across all installed plugins

**Example architecture:**
```
dev-fundamentals (core plugin)
├── skills/
│   ├── debugging-systematically/
│   ├── testing-systematically/
│   └── tdd-methodology/
└── agents/
    └── debugger.md

dev-fundamentals-react (addon plugin)
└── agents/
    └── react-test-pro.md  # skills: testing-systematically, tdd-methodology
```

**Agent referencing skills from another plugin:**
```markdown
---
name: react-test-pro
description: React testing specialist
skills: testing-systematically, tdd-methodology
---

# React Test Pro Agent
...
```

**Requirements:**
- Both plugins must be installed
- Skill names must match exactly
- Core plugin should be installed first (skills must exist in cache)

**Tested:** 2025-01-05 - Verified that `test-addon-agent` in `test-plugin-addon` successfully loaded `test-core-skill` from `test-plugin-core`.

## Conventions

| Pattern | Purpose |
|---------|---------|
| `lib.sh` | Shared bash functions |
| `CLAUDE.md` | Per-plugin Claude context |
| `${CLAUDE_PLUGIN_ROOT}` | Portable path in hooks |
| `CONTENT_WIDTH=42` | Banner width (48 - borders - padding) |
