# dev-fundamentals-react-native

React Native development fundamentals: testing, SDK migration, and configuration.

<!-- VISUAL -->
```
dev-fundamentals-react-native (addon)
├── agents/
│   └── react-native-test-pro       # Expert React Native test writer
└── skills/
    ├── migrating-expo-sdk/         # SDK upgrades, React 19, New Architecture
    └── configuring-expo-apps/      # app.config.ts, config plugins, EAS
```
<!-- /VISUAL -->

**Requirements**: `dev-fundamentals@nqh-plugins` (core plugin with shared skills)

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

## Add Plugin

```
/plugin install dev-fundamentals@nqh-plugins
/plugin install dev-fundamentals-react-native@nqh-plugins
```

## Agent

**react-native-test-pro** - Expert React Native test writer with LLM-optimized JSON output.

Features:
- Jest (90% market share in RN ecosystem)
- React Native Testing Library
- Detox for gray-box E2E testing (simulator)
- Maestro for black-box E2E testing (real devices)
- New Architecture support (React Native 0.76+)
- TurboModules mocking patterns
- Platform-specific testing (iOS + Android)
- 85%+ coverage targets

Uses skills from core: `tdd-methodology`, `testing-systematically`, `determining-test-truth`, `waiting-for-conditions`, `writing-typescript-logs`

## Skills

### migrating-expo-sdk

SDK version upgrades, React 19 breaking changes, New Architecture migration.

Triggers: `expo upgrade`, `migrate sdk`, `react native 0.76`, `new architecture migration`, `react 19 breaking`, `fabric component`, `turbo modules`

Covers:
- SDK upgrade process (incremental, one version at a time)
- React Native 0.76+ breaking changes (New Architecture default, CLI changes)
- React 19 breaking changes (forwardRef deprecated, ref as prop, Context simplification)
- Common migration issues ("Fabric component not found", Metro logging)
- Migration checklist and rollback strategy

### configuring-expo-apps

Deep Expo configuration: app.config.ts patterns, config plugins, environment management.

Triggers: `app.config`, `eas.json`, `config plugin`, `expo environment`, `expo prebuild`, `development build`

Covers:
- TypeScript app.config.ts patterns
- Dynamic configuration with environment variables
- Creating custom config plugins (withInfoPlist, withAndroidManifest)
- EAS Build profiles (development, staging, production)
- EAS Secrets management
- Environment-specific app variants
- Monorepo configuration (Metro, workspaces)

---

**v0.2.0** · Added `migrating-expo-sdk` and `configuring-expo-apps` skills
**v0.1.0** · Initial release with `react-native-test-pro` agent
