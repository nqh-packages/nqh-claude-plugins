# dev-fundamentals-react-native

React Native testing, NativeWind migration, and Expo configuration. Integrates with official `expo-plugins` for SDK upgrades and dev clients.

<!-- VISUAL -->
```
skills: configuring-expo-apps, migrating-nativewind-v5
agents: react-native-pro, react-native-test-pro
expo-plugins: upgrading-expo, dev-client, building-ui, tailwind-setup, data-fetching, api-routes, deployment
```
<!-- /VISUAL -->

**Requires**: `dev-fundamentals@nqh-plugins`, `expo-plugins` (official)

## Install

```
/plugin install dev-fundamentals-react-native@nqh-plugins
```

## Skills

| Skill | Purpose |
|-------|---------|
| `configuring-expo-apps` | app.config.ts, EAS, config plugins, environment management |
| `migrating-nativewind-v5` | NativeWind v4 → v5 migration (Tailwind v4) |

**Delegated to expo-plugins** (source of truth):
- SDK upgrades → `upgrading-expo`
- Dev clients → `dev-client`
- Fresh Tailwind setup → `tailwind-setup`

## Agents

| Agent | Stack | Expo Skills (from expo-plugins) |
|-------|-------|--------------------------------|
| `react-native-pro` | Expo SDK 54+, New Architecture, Reanimated | upgrading-expo, dev-client, building-ui, use-dom, data-fetching, tailwind-setup, api-routes, deployment |
| `react-native-test-pro` | Jest, RNTL, Detox, Maestro, 85% coverage | upgrading-expo, dev-client, building-ui, data-fetching |

---

**v0.7.0** · Remove duplicated skills (migrating-expo-sdk, building-expo-dev-clients) - use official expo-plugins
**v0.6.0** · Integrate expo-plugins skills
**v0.5.0** · Add migrating-nativewind-v5 skill
**v0.4.0** · Add building-expo-dev-clients skill
**v0.3.0** · Add react-native-pro executor agent
**v0.2.0** · Add migrating-expo-sdk, configuring-expo-apps skills
**v0.1.0** · Initial release
