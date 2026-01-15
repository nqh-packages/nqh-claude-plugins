---
name: migrating-nativewind-v5
description: Migrates React Native projects from NativeWind v4 to v5 (Tailwind v4 support). Use when upgrading NativeWind, enabling Tailwind v4, or when user mentions "nativewind v5", "tailwind v4 react native".
---

# Migrating NativeWind v5

## Purpose

Upgrades React Native/Expo projects from NativeWind v4 (Tailwind v3) to NativeWind v5 (Tailwind v4).

## WHEN TO USE

| Trigger | Action |
|---------|--------|
| "nativewind v5", "upgrade nativewind" | Activate |
| "tailwind v4 react native" | Activate |
| Working with `tailwind.config.js` + NativeWind | Suggest upgrade |

---

## Requirements (MUST verify first)

| Requirement | Minimum |
|-------------|---------|
| React Native | 0.76+ |
| Reanimated | 4.0+ |
| Expo SDK | 52+ |

```bash
# Check versions
bun list react-native react-native-reanimated expo
```

---

## Phase 1: Uninstall v4

```bash
bun remove nativewind tailwindcss
```

## Phase 2: Install v5

```bash
bun add nativewind@^5.0.0 tailwindcss@^4.0.0
```

## Phase 3: Migrate global.css

**v4 (REMOVE)**:
```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

**v5 (REPLACE WITH)**:
```css
@import "tailwindcss";
@import "nativewind/theme";
@import "nativewind/native";
```

## Phase 4: Migrate tailwind.config.js → global.css

### Colors

**v4 tailwind.config.js**:
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        sage: { 50: '#f5f7f4', 500: '#8fa388' },
      },
    },
  },
};
```

**v5 global.css**:
```css
@import "tailwindcss";
@import "nativewind/theme";
@import "nativewind/native";

@theme {
  --color-sage-50: #f5f7f4;
  --color-sage-500: #8fa388;
}
```

### Fonts

**v4 tailwind.config.js**:
```javascript
fontFamily: {
  sans: ['Inter', 'system-ui'],
}
```

**v5 global.css**:
```css
@theme {
  --font-sans: "Inter", "system-ui";
}
```

### Spacing/Sizing

**v4**: Configured in `theme.extend`
**v5**: Use CSS variables in `@theme`

```css
@theme {
  --spacing-18: 4.5rem;
}
```

## Phase 5: Delete tailwind.config.js

v5 uses CSS-first configuration. The config file is no longer needed.

```bash
rm tailwind.config.js
```

## Phase 6: Update metro.config.js

**v4**:
```javascript
const { withNativeWind } = require('nativewind/metro');
module.exports = withNativeWind(config, { input: './global.css' });
```

**v5 (same, verify only)**:
```javascript
const { withNativeWind } = require('nativewind/metro');
module.exports = withNativeWind(config, { input: './global.css' });
```

## Phase 7: Update babel.config.js

**v4**:
```javascript
presets: [
  ['babel-preset-expo', { jsxImportSource: 'nativewind' }],
  'nativewind/babel',
],
```

**v5 (same, verify only)**:
```javascript
presets: [
  ['babel-preset-expo', { jsxImportSource: 'nativewind' }],
  'nativewind/babel',
],
```

## Phase 8: Clear Cache & Test

```bash
bun start --clear
```

---

## Validation

- [ ] `bun list nativewind` shows `^5.0.0`
- [ ] `bun list tailwindcss` shows `^4.0.0`
- [ ] `global.css` has `@import "tailwindcss"`
- [ ] `tailwind.config.js` deleted
- [ ] App renders without errors
- [ ] Custom colors/fonts work

---

## Breaking Changes

| v4 | v5 |
|----|-----|
| `@tailwind base/components/utilities` | `@import "tailwindcss"` |
| `tailwind.config.js` theme | `@theme` in CSS |
| `nativewind/preset` in config | Not needed |
| `content` array in config | Auto-detected |

## Common Errors

| Error | Fix |
|-------|-----|
| "Cannot find module tailwindcss" | `bun add tailwindcss@^4.0.0` |
| "Unknown @tailwind directive" | Replace with `@import "tailwindcss"` |
| Custom colors not working | Move to `@theme` in global.css |
| Metro bundler error | Run `bun start --clear` |

---

## SELF-DIAGNOSIS

### Environment Checks
- [ ] React Native >= 0.76?
- [ ] Reanimated >= 4.0?
- [ ] Expo SDK >= 52?
- [ ] global.css imported in app entry?

### Failure Analysis
- [ ] Old `@tailwind` directives remaining?
- [ ] tailwind.config.js still exists?
- [ ] Custom theme not migrated to CSS?

---

## SELF-IMPROVEMENT

**LLM-driven**: Claude reads `data/feedback.json` at session start.

### Feedback Schema

```json
{
  "sessions": [
    {
      "session_id": "uuid",
      "timestamp": "ISO8601",
      "validation_results": {
        "versions_correct": "pass|fail",
        "css_migrated": "pass|fail",
        "config_deleted": "pass|fail",
        "app_renders": "pass|fail"
      },
      "score": "0-10",
      "fixes_applied": [],
      "user_satisfaction": "accepted|revised|rejected"
    }
  ]
}
```

### Learning Triggers

| Trigger | Action |
|---------|--------|
| "app_renders" fails >40% | Add troubleshooting step |
| "css_migrated" fails >30% | Improve CSS migration examples |

---

## FEEDBACK INTERFACE

**After each migration, append to `data/feedback.json`:**

```json
{
  "session_id": "[generate UUID]",
  "timestamp": "[ISO8601]",
  "validation_results": { ... },
  "score": [0-10],
  "fixes_applied": [],
  "user_satisfaction": "[accepted|revised|rejected]"
}
```
