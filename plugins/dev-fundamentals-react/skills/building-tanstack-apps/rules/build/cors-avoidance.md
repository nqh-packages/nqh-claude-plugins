# CORS Avoidance via Server-Side Loading

---
paths: **/services/**/*.ts, **/routes/**/*.tsx, **/api/**/*.ts
---

## Rule

1. **Worker-to-Worker**: Use **Service Bindings** (see `cloudflare/service-bindings.md`)
2. **External APIs**: Use server-side loaders/functions
3. **NEVER**: Client-side fetch to any API

## Comparison

| Approach | CORS? | Latency | For Worker-to-Worker? |
|----------|-------|---------|----------------------|
| Client `fetch()` | YES | High | ❌ FORBIDDEN |
| Server `fetch()` | No | Medium | ❌ Use Service Binding |
| **Service Binding** | No | **Zero** | ✅ REQUIRED |

## Pattern: Worker-to-Worker (CMS, etc.)

```typescript
// ✅ CORRECT: Service Binding
const searchServer = createServerFn({ method: 'GET' })
  .handler(async ({ data }) => {
    const { env } = await import('cloudflare:workers');
    const res = await env.CMS.fetch(new Request(url, { method: 'GET' }));
    return res.json();
  });
```

## Pattern: External Third-Party APIs

```typescript
// ✅ CORRECT: Server-side fetch for external APIs (not on your CF account)
const externalApiServer = createServerFn({ method: 'GET' })
  .handler(async ({ data }) => {
    const res = await fetch('https://api.stripe.com/v1/charges');
    return res.json();
  });
```

## FORBIDDEN

```typescript
// ❌ Client-side fetch
useEffect(() => { fetch('https://cms.example.com/api/search') }, []);

// ❌ HTTP fetch to another Worker (use Service Binding instead)
const res = await fetch(process.env.CMS_API_URL + '/search');
```

## When to Use What

| Target | Solution |
|--------|----------|
| CMS Worker | Service Binding (`env.CMS.fetch()`) |
| External API (Stripe, etc.) | Server-side `fetch()` |
| Real-time | WebSocket/SSE |

## Reference

- `cloudflare/service-bindings.md` (primary for Worker-to-Worker)
