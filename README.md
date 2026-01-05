# NQH Claude Plugins

A catalog of Claude Code plugins for workflow automation.

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

---

## Plugins

<!-- AUTO-GENERATED: run `bun run build:readme` to update -->

### [git-backup](./plugins/git-backup/)

Automatic daily backup of any folder to a private GitHub repo using macOS launchd.

```
/plugin install git-backup@nqh-plugins
```

```
┌─────────────────────────────────────────┐
│  Your Folder    ──────►  Private Repo   │
│  ~/.claude             github.com/...   │
│                                         │
│  ⏰ Daily @ 9 AM (via launchd)          │
│  📦 Auto-commit if changes exist        │
│  🔄 Skip if no changes                  │
└─────────────────────────────────────────┘
```

### [session](./plugins/session/)

Intelligently restart, fork, or delegate your Claude Code sessions with beautiful UI feedback.

```
/plugin install session@nqh-plugins
```

![Demo: typing /session:restart shows green SESSION RESUMED banner, /session:fork shows orange SESSION FORKED banner](./plugins/session/assets/demo.gif)

<!-- END AUTO-GENERATED -->

---

See [CLAUDE.md](./CLAUDE.md) for plugin development.
