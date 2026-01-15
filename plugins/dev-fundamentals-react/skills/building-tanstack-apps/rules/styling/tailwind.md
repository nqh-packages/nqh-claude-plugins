---
paths: **/src/styles/**/*.css
---

# Tailwind v4 CSS-First

## Core Patterns

| Pattern | Syntax |
|---------|--------|
| Import | `@import "./colors.css";` |
| Utilities | `@layer utilities { ... }` |
| Theme | `@theme { --color-primary: oklch(...); }` |

## globals.css Structure

```css
@import "tailwindcss";
@import "./colors.css";
@import "./typography.css";
@import "./spacing.css";

@layer components {
  .surface-0 { @apply shadow-sm rounded-lg border bg-background; }
  .surface-1 { @apply shadow-md rounded-xl border bg-elevated; }
  .surface-2 { @apply shadow-lg rounded-2xl border-2 bg-surface; }
  .surface-3 { @apply shadow-2xl rounded-3xl border-4 ring-4 ring-primary/10; }
}
```

## TanStack Start Setup

```typescript
// vite.config.ts - tailwindcss MUST be first
import tailwindcss from '@tailwindcss/vite'
plugins: [tailwindcss(), tanstackStart()]

// __root.tsx - ?url REQUIRED
import appCss from '../styles.css?url'
links: [{ rel: 'stylesheet', href: appCss }]
```

## Custom Utilities

```css
@layer utilities {
  .glass-effect {
    backdrop-filter: blur(12px);
    background: oklch(1 0 0 / 0.8);
  }
}
```
