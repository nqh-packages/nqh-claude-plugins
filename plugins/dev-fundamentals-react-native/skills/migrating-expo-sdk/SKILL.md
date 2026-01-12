---
name: migrating-expo-sdk
description: SDK version upgrades, React 19 breaking changes, New Architecture migration
version: 1.0.0
author: nqh
triggers:
  - expo upgrade
  - migrate sdk
  - react native 0.76
  - react native 0.77
  - react native 0.82
  - new architecture migration
  - react 19 breaking
  - fabric component
  - turbo modules
  - forwardRef deprecated
  - propTypes removed
---

# Migrating Expo SDK

Version-specific migration guidance for Expo SDK upgrades, React Native New Architecture, and React 19 compatibility.

## When to Use

- Upgrading Expo SDK versions (51 → 52 → 53 → 54)
- Migrating to New Architecture (now default in RN 0.76+)
- Fixing React 19 breaking changes
- Resolving "Fabric component not found" errors
- Updating deprecated APIs (forwardRef, propTypes)

## SDK Upgrade Process

**Always upgrade incrementally, one SDK version at a time.**

```bash
# Step 1: Install new SDK
npm install expo@^54.0.0  # or your target version

# Step 2: Fix dependencies
npx expo install --fix
npx expo-doctor

# Step 3: Refresh native projects
# If using Continuous Native Generation:
rm -rf android ios && npx expo prebuild

# If using bare workflow:
npx pod-install
```

## SDK Version Matrix

| Expo SDK | React Native | React | New Architecture |
|----------|--------------|-------|------------------|
| 54 | 0.77+ | 19 | Default ON |
| 53 | 0.76+ | 19 | Default ON |
| 52 | 0.76+ | 18.3 | Default ON |
| 51 | 0.74 | 18.2 | Opt-in |
| 50 | 0.73 | 18.2 | Opt-in |

## React Native 0.76+ Breaking Changes

### 1. New Architecture is Default

No opt-in required. All new projects use Fabric renderer and TurboModules.

```typescript
// app.json - To disable (not recommended)
{
  "expo": {
    "newArchEnabled": false  // Only if libraries incompatible
  }
}
```

### 2. CLI Dependency Required

Add explicit CLI dependencies:

```json
{
  "devDependencies": {
    "@react-native-community/cli": "15.0.0",
    "@react-native-community/cli-platform-android": "15.0.0",
    "@react-native-community/cli-platform-ios": "15.0.0"
  }
}
```

### 3. Minimum Platform Requirements

| Platform | Before | After |
|----------|--------|-------|
| iOS | 13.4 | 15.1 |
| Android SDK | 23 | 24 (Android 7) |

### 4. Android Native Library Merging

Update `MainApplication.kt`:

```kotlin
import com.facebook.react.soloader.OpenSourceMergedSoMapping
import com.facebook.soloader.SoLoader

class MainApplication : Application(), ReactApplication {
  override fun onCreate() {
    super.onCreate()
    SoLoader.init(this, OpenSourceMergedSoMapping)  // Changed!
  }
}
```

### 5. New Style Props (New Architecture Only)

```typescript
// boxShadow - Web-aligned syntax
style={{ boxShadow: '5 5 5 0 rgba(255, 0, 0, 0.5)' }}

// filter - Web-aligned filters
style={{ filter: 'saturate(0.5) grayscale(0.25)' }}
```

## React 19 Breaking Changes

### 1. forwardRef Deprecated

```typescript
// ❌ OLD: Using forwardRef
const MyInput = forwardRef<TextInput, Props>(({ placeholder }, ref) => (
  <TextInput placeholder={placeholder} ref={ref} />
));

// ✅ NEW: ref as regular prop
function MyInput({ placeholder, ref }: Props & { ref?: Ref<TextInput> }) {
  return <TextInput placeholder={placeholder} ref={ref} />;
}
```

### 2. ref Callback Cleanup

```typescript
// ❌ OLD: Implicit return (breaks TypeScript)
<View ref={current => (instance = current)} />

// ✅ NEW: Explicit block
<View ref={current => { instance = current }} />
```

### 3. Context Provider Simplification

```typescript
// ❌ OLD
<ThemeContext.Provider value="dark">{children}</ThemeContext.Provider>

// ✅ NEW
<ThemeContext value="dark">{children}</ThemeContext>
```

### 4. New Hooks

| Hook | Purpose |
|------|---------|
| `useActionState` | Form state with async actions (replaces useFormState) |
| `useOptimistic` | Optimistic UI updates |
| `use` | Read resources in render (promises, context) |

```typescript
// useOptimistic example
const [optimisticName, setOptimisticName] = useOptimistic(currentName);

// useActionState example
const [error, submitAction, isPending] = useActionState(
  async (previousState, formData) => {
    const error = await updateName(formData.get("name"));
    return error ?? null;
  },
  null
);
```

## Common Migration Issues

### "Fabric component not found"

**Cause**: Native module not compatible with New Architecture

**Fix**:
```bash
# Check library compatibility
npx react-native-new-architecture-check

# If library unsupported, temporary workaround:
# app.json
{
  "expo": {
    "newArchEnabled": false
  }
}
```

### Metro Log Forwarding Removed

**Cause**: Metro no longer forwards logs to terminal in RN 0.76+

**Fix**: Use React Native DevTools instead (press `j` in CLI or open Dev Menu)

### Chrome Debugger Deprecated

**Cause**: Old Chrome debugger removed in New Architecture

**Fix**: Use React Native DevTools (Chrome DevTools-based, more reliable)

## Migration Checklist

### Pre-Migration

- [ ] Check library compatibility: `npx react-native-new-architecture-check`
- [ ] Review SDK changelog for your target version
- [ ] Backup project or create git branch
- [ ] Update Xcode and Android Studio to latest

### During Migration

- [ ] Upgrade one SDK version at a time
- [ ] Run `npx expo install --fix` after each upgrade
- [ ] Run `npx expo-doctor` to catch issues
- [ ] Test on both iOS and Android simulators

### Post-Migration

- [ ] Search codebase for `forwardRef` → replace with ref prop
- [ ] Search for `Context.Provider` → simplify to `Context`
- [ ] Update ref callbacks to use explicit blocks
- [ ] Test all navigation flows
- [ ] Test all native module integrations
- [ ] Run full test suite

## Rollback Strategy

If migration fails:

```bash
# Revert to previous SDK
npm install expo@^52.0.0  # Your previous version
npx expo install --fix

# Regenerate native projects
rm -rf android ios
npx expo prebuild
```

## Resources

- [Expo SDK Upgrade Walkthrough](https://docs.expo.dev/workflow/upgrading-expo-sdk-walkthrough/)
- [React Native 0.76 Release](https://reactnative.dev/blog/2024/10/23/release-0.76-new-architecture)
- [React 19 Upgrade Guide](https://react.dev/blog/2024/04/25/react-19-upgrade-guide)
- [New Architecture Compatibility Check](https://github.com/reactwg/react-native-new-architecture)
