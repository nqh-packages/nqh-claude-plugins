---
name: building-expo-dev-clients
description: Creates EAS development builds for testing Expo apps on physical devices with full native module support. Use when Expo Go shows native version mismatches, when testing push notifications, app links, or any custom native code.
version: 1.0.0
author: nqh
triggers:
  - expo dev client
  - dev client
  - eas build
  - development build
  - expo go mismatch
  - worklets mismatch
  - reanimated version
  - physical device
  - push notifications testing
  - app links testing
  - native module version
---

# Building Expo Dev Clients

Build custom Expo dev clients that include your exact native module versions, bypassing Expo Go limitations.

## When to Use

| Trigger | Action |
|---------|--------|
| Worklets/Reanimated version mismatch | Build dev client |
| Testing push notifications | Build dev client |
| Testing app/universal links | Build dev client |
| Editing app.json/eas.json | Check if dev client needed |

## Phase 0: Should You Build?

```
Native module version mismatch in Expo Go?
├── YES → Continue to Phase 1
│
Custom native code needed (push notifications, app links)?
├── YES → Continue to Phase 1
│
Testing prototype quickly with standard Expo modules?
└── NO → Use Expo Go instead (faster iteration)
```

## Phase 1: Prerequisites

| Requirement | Check | Fix |
|-------------|-------|-----|
| EAS CLI | `eas --version` | `npm install -g eas-cli` |
| Logged in | `eas whoami` | `eas login` |
| expo-dev-client | In package.json | `npx expo install expo-dev-client` |
| Apple Developer (iOS) | Account exists | developer.apple.com |

**Checklist:**
- [ ] EAS CLI installed globally
- [ ] Logged into EAS account
- [ ] expo-dev-client in dependencies
- [ ] Apple Developer account (for iOS physical)

## Phase 2: Configure eas.json

```json
{
  "cli": { "version": ">= 3.0.0" },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "ios": { "simulator": false }
    },
    "development-simulator": {
      "developmentClient": true,
      "distribution": "internal",
      "ios": { "simulator": true }
    }
  }
}
```

| Profile | Use Case |
|---------|----------|
| `development` | Physical device |
| `development-simulator` | iOS Simulator |

## Phase 3: Build

```bash
# iOS physical device
eas build --platform ios --profile development

# iOS Simulator
eas build --platform ios --profile development-simulator

# Android
eas build --platform android --profile development
```

| Build | Duration |
|-------|----------|
| First | 5-15 min |
| Cached | 2-5 min |

## Phase 4: Install on Device

**iOS Physical:**
1. Build completes → QR code in terminal
2. Scan with device camera
3. Install via TestFlight or direct

**iOS Simulator:**
```bash
eas build:run -p ios --profile development-simulator
```

**Android:**
1. Download APK from EAS dashboard
2. Install (enable Unknown sources)

## Phase 5: Connect to Metro

```bash
# Start with dev-client support
npx expo start --dev-client

# With tunnel (hotspot/remote networks)
npx expo start --dev-client --tunnel
```

1. Open dev client app on device
2. Scan QR code OR enter URL
3. Hot reload works instantly

## Validation

- [ ] eas.json has development profile
- [ ] expo-dev-client installed
- [ ] Build completed successfully
- [ ] App installs on device
- [ ] Metro bundler connects
- [ ] Hot reload working

## Common Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| Worklets mismatch | Expo Go old natives | Build dev client |
| No Bundle URL | Wrong network | Use `--tunnel` |
| Build fails iOS | Missing provisioning | `eas credentials` |
| QR won't open | No dev client | Install build first |
| Can't reach bundler | Firewall | Allow 8081 or tunnel |

## Self-Diagnosis

### When to Check
- Build fails repeatedly
- Device can't connect to Metro
- Native modules still mismatch

### Environment Checks
- [ ] `eas whoami` returns user
- [ ] `npx expo install expo-dev-client` succeeds
- [ ] Port 8081 accessible (or tunnel)
- [ ] Device has dev client (not Expo Go)

### Failure Analysis
- [ ] Is eas.json valid JSON?
- [ ] Profile matches build command?
- [ ] Apple credentials configured?
- [ ] Metro running before dev client?

## Self-Improvement

**LLM-driven**: Claude reads `data/feedback.json` at session start.

### Feedback Schema

```json
{
  "sessions": [{
    "session_id": "uuid",
    "timestamp": "ISO8601",
    "platform": "ios|android",
    "profile": "development|development-simulator",
    "build_success": true,
    "connection_success": true,
    "issues": [],
    "time_minutes": 10
  }]
}
```

### Session Start Intelligence

1. Read data/feedback.json
2. Calculate build/connection success rates
3. If build failures >30%: check credentials first
4. If connection failures >30%: default to tunnel

### Learning Triggers

| Trigger | Action |
|---------|--------|
| Build fails >30% | Prioritize credentials |
| Connection fails >30% | Default tunnel mode |
| Same issue 3x | Add to Phase 1 |

## Feedback Interface

**After each session, Claude appends:**

```json
{
  "session_id": "[uuid]",
  "timestamp": "[ISO8601]",
  "platform": "ios|android",
  "profile": "development|development-simulator",
  "build_success": true,
  "connection_success": true,
  "issues": [],
  "time_minutes": 10
}
```
