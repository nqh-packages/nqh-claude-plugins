# Vite SSR Module State Isolation

---
paths: **/vite.config.ts, **/vitest.config.ts, **/vitest.setup.ts, **/server.ts
---

## Problem

Packages with module-level state cause request pollution when Vite externalizes them.

## Symptoms

| Symptom | Cause |
|---------|-------|
| First request works, subsequent fail | State persists |
| Redirect loops | i18n locale not reset |
| Stale data | Shared module state |
| "Too many redirects" in tests | Paraglide `_locale` persists between tests |
| "Failed to load content from CMS" | `import.meta.env.DEV` undefined in Node.js |
| `cloudflare:workers` import fails in dev | Package tries production code path |

## Production Fix

```typescript
// vite.config.ts
export default defineConfig({
  ssr: {
    // Bundle packages that use import.meta.env or module-level state
    noExternal: ['@inlang/paraglide-js', '@nqh/cms-bindings'],
  },
})
```

## Vitest Fix (REQUIRED for Paraglide)

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    mockReset: true,
    clearMocks: true,
    restoreMocks: true,
    deps: {
      inline: ['@inlang/paraglide-js'],
    },
  },
})

// vitest.setup.ts
import { beforeEach } from 'vitest';
import { baseLocale, setLocale } from '@/paraglide/runtime.js';

beforeEach(() => {
  setLocale(baseLocale, { reload: false });
});
```

## Common Packages

| Package | Add to `ssr.noExternal` | Add to `deps.inline` |
|---------|-------------------------|----------------------|
| `@inlang/paraglide-js` | YES | YES |
| `@nqh/i18n` | YES | NO |
| `@nqh/cms-bindings` | YES | NO |
| `i18next`, `react-i18next` | YES | YES |
| Any `import.meta.env.DEV` user | YES | NO |
| Any AsyncLocalStorage user | YES | YES |

## Server Pattern (TanStack Start + Paraglide)

Routes using `$lang` prefix MUST preserve the original localized URL:

```typescript
import { createStartHandler, defaultStreamHandler, defineHandlerCallback } from '@tanstack/react-start/server'
import { paraglideMiddleware } from './paraglide/server.js'

const customHandler = defineHandlerCallback((ctx) =>
  // IMPORTANT: Use ctx.request (original URL), NOT the de-localized request
  // Paraglide de-localizes /en/topics → /topics, but routes expect /$lang/topics
  paraglideMiddleware(ctx.request, ({ locale }) =>
    defaultStreamHandler({ ...ctx, request: ctx.request })
  )
)
export default createServerEntry({ fetch: createStartHandler(customHandler) })
```

| Route Pattern | Use Original URL | Use De-localized URL |
|---------------|------------------|----------------------|
| `$lang/*` (prefixed) | ✅ `ctx.request` | ❌ Causes redirect loop |
| `/about` (no prefix) | ❌ | ✅ `request` from middleware |
