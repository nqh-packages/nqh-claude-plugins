---
paths: **/wrangler.jsonc, **/wrangler.json, **/server-functions.ts, **/services/**/*.ts
---

# Cloudflare Service Bindings (Primary Pattern)

## Rule

Worker-to-Worker communication MUST use Service Bindings. HTTP fetch is FORBIDDEN for same-account Workers.

## Why Service Bindings

| Aspect | HTTP Fetch | Service Bindings |
|--------|-----------|------------------|
| **Latency** | Network round-trip | **Zero** (same thread) |
| **Routing** | DNS → CDN → Worker | **Direct RPC** |
| **Reliability** | Subject to HTTP issues | **Direct invocation** |
| **Cost** | Standard | **Same cost, better perf** |
| **Official recommendation** | Fallback only | **Primary** |

> "When you use Service Bindings, there is zero overhead or added latency. Both Workers run on the same thread of the same Cloudflare server... there is no networking!" — [Cloudflare Blog](https://blog.cloudflare.com/introducing-worker-services/)

## Configuration

### 1. Target Worker (CMS)

No changes needed - the target Worker just needs to be deployed.

### 2. Calling Worker (Frontend)

```jsonc
// wrangler.jsonc
{
  "services": [
    {
      "binding": "CMS",
      "service": "latinamerica-hu-cms"
    }
  ]
}
```

### 3. TypeScript Types

```typescript
// src/env.d.ts
interface CloudflareEnv {
  CMS: Fetcher; // Service Binding to CMS Worker
}
```

## Pattern (TanStack Start Server Functions)

```typescript
import { createServerFn } from '@tanstack/react-start';

// Helper to get Service Binding
async function getCmsBinding(): Promise<Fetcher> {
  const { env } = await import('cloudflare:workers');
  if (!env.CMS) throw new Error('CMS service binding not configured');
  return env.CMS;
}

// ✅ CORRECT: Use Service Binding
export const getTopicsServer = createServerFn({ method: 'GET' })
  .handler(async ({ data }) => {
    const cms = await getCmsBinding();
    const url = `https://cms.latinamerica.hu/api/topics?locale=${data.locale}`;
    const res = await cms.fetch(new Request(url, { method: 'GET' }));
    if (!res.ok) throw new Error(`CMS error: ${res.status}`);
    return res.json();
  });
```

## FORBIDDEN Patterns

```typescript
// ❌ FORBIDDEN: Direct HTTP fetch to another Worker
const res = await fetch(process.env.CMS_API_URL + '/topics');

// ❌ FORBIDDEN: Hardcoded CMS URL in fetch
const res = await fetch('https://cms.latinamerica.hu/api/topics');

// ❌ FORBIDDEN: Using env var for Worker URL
const url = `${process.env.CMS_API_URL}/topics`;
const res = await fetch(url);
```

## Migration from HTTP Fetch

| Before | After |
|--------|-------|
| `fetch(process.env.CMS_API_URL + path)` | `env.CMS.fetch(new Request(url))` |
| `fetch('https://cms.example.com' + path)` | `env.CMS.fetch(new Request(url))` |

## When HTTP Fetch is Allowed

HTTP fetch is ONLY allowed for:
- External third-party APIs (not on your Cloudflare account)
- APIs that don't have a Worker deployment

## Local Development

### The Problem

`cloudflare:workers` module **only exists in Cloudflare runtime**. Vite's dev server cannot resolve it.

| Dev Server | `cloudflare:workers` | Service Bindings |
|------------|---------------------|------------------|
| `vite dev` | ❌ FAILS | Not available |
| `wrangler dev` | ✅ WORKS | ✅ Full support |

### Option A: Multi-Worker wrangler dev (Recommended)

```bash
# Terminal 1: Build and run CMS Worker
cd sites/latinamerica.hu-cms && pnpm build && wrangler dev

# Terminal 2: Run frontend Worker
cd sites/latinamerica.hu && wrangler dev
```

**Pros**: Real Service Bindings, production parity
**Cons**: No HMR for CMS, must rebuild on changes

### Option B: Remote Bindings

```jsonc
// wrangler.jsonc - connect to deployed CMS
{
  "services": [{ "binding": "CMS", "service": "latinamerica-hu-cms", "remote": true }]
}
```

**Pros**: Real bindings, no CMS build needed
**Cons**: Hits production data

### Option C: HTTP Fallback (Development Only)

```typescript
async function getCmsBinding(): Promise<CmsServiceBinding> {
  if (import.meta.env.DEV) {
    const cmsUrl = import.meta.env.VITE_CMS_API_URL || 'http://localhost:3000';
    return { fetch: (req) => fetch(new Request(cmsUrl + new URL(req.url).pathname, req)) };
  }
  const { env } = await import('cloudflare:workers');
  return env.CMS;
}
```

**Pros**: Fast iteration, HMR works
**Cons**: Not production-representative

## Reference

- [Service Bindings Docs](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/)
- [Service Bindings HTTP](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/http/)
- [Cloudflare Blog: Introducing Services](https://blog.cloudflare.com/introducing-worker-services/)

## Evidence

- Issue: HTTP fetch to CMS returns 500 from Worker, works from curl
- Solution: Service Bindings bypass HTTP routing entirely
