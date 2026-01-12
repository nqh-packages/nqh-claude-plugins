---
name: configuring-expo-apps
description: app.config.ts patterns, config plugins, environment management, EAS configuration
version: 1.0.0
author: nqh
triggers:
  - app.config
  - app.json
  - expo config
  - eas.json
  - config plugin
  - expo environment
  - expo prebuild
  - development build
  - expo secrets
  - expo manifest
---

# Configuring Expo Apps

Deep configuration patterns for Expo projects: dynamic app.config.ts, config plugins, environment management, and EAS configuration.

## When to Use

- Setting up app.config.ts with TypeScript
- Creating custom config plugins
- Managing development/staging/production environments
- Configuring EAS Build profiles
- Modifying native files (Info.plist, AndroidManifest.xml)

## app.config.ts Patterns

### Basic TypeScript Configuration

```typescript
// app.config.ts
import { ExpoConfig, ConfigContext } from 'expo/config';

export default ({ config }: ConfigContext): ExpoConfig => ({
  ...config,
  name: 'My App',
  slug: 'my-app',
  version: '1.0.0',
  orientation: 'portrait',
  icon: './assets/icon.png',
  splash: {
    image: './assets/splash.png',
    resizeMode: 'contain',
    backgroundColor: '#ffffff',
  },
  ios: {
    bundleIdentifier: 'com.example.myapp',
    supportsTablet: true,
  },
  android: {
    package: 'com.example.myapp',
    adaptiveIcon: {
      foregroundImage: './assets/adaptive-icon.png',
      backgroundColor: '#ffffff',
    },
  },
});
```

### Dynamic Configuration with Environment

```typescript
// app.config.ts
import { ExpoConfig, ConfigContext } from 'expo/config';

const IS_DEV = process.env.APP_VARIANT === 'development';
const IS_STAGING = process.env.APP_VARIANT === 'staging';

const getUniqueIdentifier = () => {
  if (IS_DEV) return 'com.example.myapp.dev';
  if (IS_STAGING) return 'com.example.myapp.staging';
  return 'com.example.myapp';
};

const getAppName = () => {
  if (IS_DEV) return 'My App (Dev)';
  if (IS_STAGING) return 'My App (Staging)';
  return 'My App';
};

export default ({ config }: ConfigContext): ExpoConfig => ({
  ...config,
  name: getAppName(),
  slug: 'my-app',
  version: '1.0.0',
  ios: {
    bundleIdentifier: getUniqueIdentifier(),
  },
  android: {
    package: getUniqueIdentifier(),
  },
  extra: {
    apiUrl: process.env.API_URL,
    sentryDsn: process.env.SENTRY_DSN,
    eas: {
      projectId: process.env.EAS_PROJECT_ID,
    },
  },
});
```

### Accessing Config Values at Runtime

```typescript
// Inside your app
import Constants from 'expo-constants';

const apiUrl = Constants.expoConfig?.extra?.apiUrl;
const sentryDsn = Constants.expoConfig?.extra?.sentryDsn;
```

## Config Plugins

### What Are Config Plugins?

Config plugins modify native projects during `npx expo prebuild`. They automate changes to:
- `Info.plist` (iOS)
- `AndroidManifest.xml` (Android)
- `build.gradle` (Android)
- Native source files

### Using Existing Plugins

```typescript
// app.config.ts
export default ({ config }: ConfigContext): ExpoConfig => ({
  ...config,
  plugins: [
    // String: Just the plugin name
    'expo-camera',

    // Array: Plugin with options
    ['expo-image-picker', { photosPermission: 'Allow access to photos' }],

    // Custom plugin function
    withCustomConfig,
  ],
});
```

### Creating Custom Config Plugins

```typescript
// plugins/with-custom-scheme.ts
import { ConfigPlugin, withInfoPlist, withAndroidManifest } from 'expo/config-plugins';

const withCustomScheme: ConfigPlugin<{ scheme: string }> = (config, { scheme }) => {
  // Modify iOS Info.plist
  config = withInfoPlist(config, (config) => {
    const urlTypes = config.modResults.CFBundleURLTypes ?? [];
    urlTypes.push({
      CFBundleURLSchemes: [scheme],
    });
    config.modResults.CFBundleURLTypes = urlTypes;
    return config;
  });

  // Modify Android Manifest
  config = withAndroidManifest(config, (config) => {
    const mainActivity = config.modResults.manifest.application?.[0]?.activity?.find(
      (activity) => activity.$['android:name'] === '.MainActivity'
    );
    if (mainActivity) {
      mainActivity['intent-filter'] = mainActivity['intent-filter'] ?? [];
      mainActivity['intent-filter'].push({
        action: [{ $: { 'android:name': 'android.intent.action.VIEW' } }],
        category: [
          { $: { 'android:name': 'android.intent.category.DEFAULT' } },
          { $: { 'android:name': 'android.intent.category.BROWSABLE' } },
        ],
        data: [{ $: { 'android:scheme': scheme } }],
      });
    }
    return config;
  });

  return config;
};

export default withCustomScheme;
```

```typescript
// app.config.ts
import withCustomScheme from './plugins/with-custom-scheme';

export default ({ config }: ConfigContext): ExpoConfig => ({
  ...config,
  plugins: [
    [withCustomScheme, { scheme: 'myapp' }],
  ],
});
```

### Common Mod Functions

| Mod | Purpose |
|-----|---------|
| `withInfoPlist` | Modify iOS Info.plist |
| `withAndroidManifest` | Modify AndroidManifest.xml |
| `withEntitlementsPlist` | Modify iOS entitlements |
| `withAppBuildGradle` | Modify app/build.gradle |
| `withProjectBuildGradle` | Modify project build.gradle |
| `withMainActivity` | Modify MainActivity.kt/java |
| `withAppDelegate` | Modify AppDelegate.m/mm |
| `withPodfile` | Modify Podfile |

## EAS Configuration

### eas.json Structure

```json
{
  "cli": {
    "version": ">= 5.0.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "ios": {
        "simulator": true
      },
      "env": {
        "APP_VARIANT": "development",
        "API_URL": "https://dev-api.example.com"
      }
    },
    "staging": {
      "distribution": "internal",
      "android": {
        "buildType": "apk"
      },
      "env": {
        "APP_VARIANT": "staging",
        "API_URL": "https://staging-api.example.com"
      }
    },
    "production": {
      "autoIncrement": true,
      "env": {
        "APP_VARIANT": "production",
        "API_URL": "https://api.example.com"
      }
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "your@email.com",
        "ascAppId": "123456789"
      },
      "android": {
        "serviceAccountKeyPath": "./google-services.json",
        "track": "production"
      }
    }
  }
}
```

### EAS Secrets

```bash
# Set secrets (never commit these!)
eas secret:create --name SENTRY_DSN --value "https://..."
eas secret:create --name API_KEY --value "secret-key"

# List secrets
eas secret:list

# Use in app.config.ts via process.env
```

### Build Commands

```bash
# Development build (for simulators)
eas build --platform ios --profile development

# Staging build (internal distribution)
eas build --platform android --profile staging

# Production build
eas build --platform all --profile production

# Submit to stores
eas submit --platform ios --profile production
eas submit --platform android --profile production
```

## Environment Management

### Multiple App Variants

```typescript
// app.config.ts
const APP_VARIANT = process.env.APP_VARIANT ?? 'production';

const VARIANTS = {
  development: {
    name: 'My App (Dev)',
    bundleId: 'com.example.myapp.dev',
    icon: './assets/icon-dev.png',
  },
  staging: {
    name: 'My App (Staging)',
    bundleId: 'com.example.myapp.staging',
    icon: './assets/icon-staging.png',
  },
  production: {
    name: 'My App',
    bundleId: 'com.example.myapp',
    icon: './assets/icon.png',
  },
} as const;

const variant = VARIANTS[APP_VARIANT as keyof typeof VARIANTS];

export default ({ config }: ConfigContext): ExpoConfig => ({
  ...config,
  name: variant.name,
  icon: variant.icon,
  ios: { bundleIdentifier: variant.bundleId },
  android: { package: variant.bundleId },
});
```

### Local Environment Files

```bash
# .env.local (gitignored)
API_URL=http://localhost:3000
SENTRY_DSN=

# Use with eas build --local
eas build --platform ios --profile development --local
```

## Monorepo Setup

### Workspace Configuration

```json
// apps/mobile/package.json
{
  "name": "@myorg/mobile",
  "main": "expo-router/entry",
  "dependencies": {
    "@myorg/shared": "workspace:*",
    "@myorg/ui": "workspace:*"
  }
}
```

```typescript
// apps/mobile/app.config.ts
import { ExpoConfig, ConfigContext } from 'expo/config';

export default ({ config }: ConfigContext): ExpoConfig => ({
  ...config,
  experiments: {
    tsconfigPaths: true,  // Enable tsconfig path aliases
  },
});
```

### Metro Configuration for Monorepo

```javascript
// apps/mobile/metro.config.js
const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const projectRoot = __dirname;
const workspaceRoot = path.resolve(projectRoot, '../..');

const config = getDefaultConfig(projectRoot);

config.watchFolders = [workspaceRoot];
config.resolver.nodeModulesPaths = [
  path.resolve(projectRoot, 'node_modules'),
  path.resolve(workspaceRoot, 'node_modules'),
];

module.exports = config;
```

## Best Practices

### Do

- Use `app.config.ts` over `app.json` for dynamic configuration
- Store secrets in EAS Secrets, not in code
- Use environment-specific bundle identifiers for parallel installs
- Keep config plugins simple and focused
- Test prebuild output: `npx expo prebuild --clean`

### Don't

- Commit `.env` files with secrets
- Hardcode API keys in app.config.ts
- Mix production and development bundle IDs
- Modify native files directly (use config plugins)
- Skip the `--clean` flag when debugging prebuild issues

## Resources

- [Expo Configuration Docs](https://docs.expo.dev/workflow/configuration/)
- [Config Plugins Guide](https://docs.expo.dev/config-plugins/introduction/)
- [EAS Build Configuration](https://docs.expo.dev/build/eas-json/)
- [Environment Variables](https://docs.expo.dev/guides/environment-variables/)
