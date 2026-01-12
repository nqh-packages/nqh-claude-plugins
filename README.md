# NQH Claude Plugins

A catalog of Claude Code plugins for workflow automation.

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

---

## Plugins

<!-- AUTO-GENERATED: run `bun run build:readme` to update -->

### [dev-fundamentals](./plugins/dev-fundamentals/)

Core development methodologies: systematic debugging, testing, TDD, and research skills.

```
/plugin install dev-fundamentals@nqh-plugins
```

```
dev-fundamentals (core)
├── skills/
│   ├── debugging-systematically    # 4-phase scientific debugging
│   ├── testing-systematically      # ZOMBIES test case analysis
│   ├── tdd-methodology             # RED-GREEN-REFACTOR
│   ├── researching                 # Research orchestration
│   ├── waiting-for-conditions      # Async/polling patterns
│   ├── determining-test-truth      # Test result verification
│   ├── capturing-screenshots       # Visual debugging
│   ├── writing-markdown            # Documentation output
│   └── writing-typescript-logs     # Structured logging
└── agents/
    ├── debugger                    # Autonomous debugging specialist
    └── research-agent              # Web research with credibility scoring
```

### [dev-fundamentals-react](./plugins/dev-fundamentals-react/)

React testing specialist with Vitest, React Testing Library, MSW, and Playwright.

```
/plugin install dev-fundamentals-react@nqh-plugins
```

```
dev-fundamentals-react (addon)
└── agents/
    └── react-test-pro    # Expert React test writer
```

### [dev-fundamentals-react-native](./plugins/dev-fundamentals-react-native/)

React Native development fundamentals: testing, SDK migration, and configuration.

```
/plugin install dev-fundamentals-react-native@nqh-plugins
```

```
dev-fundamentals-react-native (addon)
├── agents/
│   ├── react-native-pro            # Executor agent for RN development
│   └── react-native-test-pro       # Expert React Native test writer
└── skills/
    ├── migrating-expo-sdk/         # SDK upgrades, React 19, New Architecture
    └── configuring-expo-apps/      # app.config.ts, config plugins, EAS
```

### [dev-fundamentals-swift](./plugins/dev-fundamentals-swift/)

Swift/iOS testing specialist with Swift Testing framework, ViewInspector, and XCUITest.

```
/plugin install dev-fundamentals-swift@nqh-plugins
```

```
dev-fundamentals-swift (addon)
├── skills/
│   ├── testing-swift-apps     # Swift Testing patterns
│   └── logging-swift-apps     # Structured Swift logging
└── agents/
    └── swift-test-pro         # Expert Swift test writer
```

### [dev-fundamentals-typescript](./plugins/dev-fundamentals-typescript/)

TypeScript/Node.js testing specialist with Vitest and MSW.

```
/plugin install dev-fundamentals-typescript@nqh-plugins
```

```
dev-fundamentals-typescript (addon)
└── agents/
    └── typescript-test-pro    # Expert TypeScript test writer
```

### [framer-mcp](./plugins/framer-mcp/)

MCP server for Framer design tool integration.

```
/plugin install framer-mcp@nqh-plugins
```

```
framer-mcp
└── (in development)
```

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
│  ⚠️  Warns about large files/git repos  │
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
