---
paths: **/payload.config.ts, **/wrangler.{jsonc,toml,json}, **/server-functions.ts, **/services/**/*.ts
---

# Cloudflare Worker Environment Access

## Rule

Use `process.env` inside handlers with `nodejs_compat_populate_process_env` flag. Module-level env access FAILS.

## When to Use Which Pattern

| Context | Pattern | Why |
|---------|---------|-----|
| **wrangler dev / Production** | `cloudflare:workers` | Full bindings access |
| **vite dev** | `process.env` + fallback | Module unavailable |
| **Payload CMS Config** | `getCloudflareContext()` | OpenNext integration |

### The `cloudflare:workers` Clarification

| Environment | Status |
|-------------|--------|
| `wrangler dev` | ✅ WORKS |
| `vite dev` | ❌ FAILS (module doesn't exist) |
| Production | ✅ WORKS |

**TanStack Start Issues**:
- #6185: Static import breaks client build
- #3468: SSR bindings not passed via `getEvent()`

**Solution**: Dynamic `import('cloudflare:workers')` in server functions, with `import.meta.env.DEV` guard for Vite fallback.

## Required wrangler.jsonc

```jsonc
{
  "compatibility_flags": ["nodejs_compat", "nodejs_compat_populate_process_env"]
}
```

Note: `nodejs_compat_populate_process_env` is default for compat_date ≥ 2025-04-01.

## Pattern (TanStack Start Server Functions)

```typescript
import { createServerFn } from '@tanstack/react-start'

// ✅ CORRECT: process.env inside handler
export const serverFn = createServerFn()
  .handler(async () => {
    const apiUrl = process.env.MY_VAR
    if (!apiUrl) throw new Error('MY_VAR not configured')
    return apiUrl
  })

// ✅ Helper for multiple server functions
function getEnv(key: string): string {
  const value = process.env[key]
  if (!value) throw new Error(`${key} not configured in wrangler.jsonc`)
  return value
}
```

## Pattern (Payload CMS Config)

```typescript
// ✅ CORRECT: getCloudflareContext for Payload config
import { getCloudflareContext } from '@opennextjs/cloudflare'
const { env } = await getCloudflareContext({ async: true })
export default buildConfig({
  db: sqliteD1Adapter({ binding: env.D1 }),
})
```

## FORBIDDEN

```typescript
// ❌ Module-level access - undefined at load time
const API_URL = process.env.API_URL

// ❌ Module-level IIFE - still evaluated at load time
const API_URL = (() => process.env.API_URL)()

// ❌ Static import - breaks client bundle
import { env } from 'cloudflare:workers'
```

## ALLOWED

```typescript
// ✅ Dynamic import in server function - WORKS with wrangler dev + production
const { env } = await import('cloudflare:workers')

// ✅ With Vite dev fallback (see service-bindings.md Local Development section)
async function getCmsBinding() {
  if (import.meta.env.DEV) return createDevFallback();
  const { env } = await import('cloudflare:workers');
  return env.CMS;
}
```

## Why

CF Workers populate `process.env` lazily at **request time**, not **module load time**.
The `nodejs_compat_populate_process_env` flag enables this behavior.

## Available Bindings

| Binding | Type | wrangler.jsonc | Access |
|---------|------|----------------|--------|
| `D1` | Database | `d1_databases` | Payload: `getCloudflareContext()` |
| `R2` | Storage | `r2_buckets` | Payload: `getCloudflareContext()` |
| `CACHE_KV` | KV | `kv_namespaces` | Payload: `getCloudflareContext()` |
| `CMS_API_URL` | String var | `vars` | `process.env.CMS_API_URL` |

## Testing & Mocking

```typescript
// Mock process.env in vitest
beforeEach(() => {
  vi.stubEnv('CMS_API_URL', 'https://cms.test.local/api')
})

afterEach(() => {
  vi.unstubAllEnvs()
})
```

## Reference

- [Cloudflare process.env Docs](https://developers.cloudflare.com/workers/runtime-apis/nodejs/process/)
- [TanStack Issue #3468](https://github.com/TanStack/router/issues/3468) - SSR bindings not passed
- [TanStack Issue #6185](https://github.com/TanStack/router/issues/6185) - cloudflare:workers build failures
- `sites/latinamerica.hu/src/services/cms/server-functions.ts` (working example)
