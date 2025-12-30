# NQH Claude Plugins

A marketplace of Claude Code plugins.

## Installation

```bash
# Add this marketplace
claude /plugin marketplace add /path/to/nqh-claude-plugins

# List available plugins
claude /plugin list

# Install a plugin
claude /plugin install <plugin-name>@nqh-plugins
```

## Available Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [session](./plugins/session/) | Restart or fork Claude sessions | 3.0.0 |

## Plugin Development

To add a new plugin:

1. Create directory: `plugins/<plugin-name>/`
2. Add manifest: `plugins/<plugin-name>/.claude-plugin/plugin.json`
3. Register in `.claude-plugin/marketplace.json`

See [plugin-dev docs](https://code.claude.com/docs/en/plugins-reference.md) for details.
