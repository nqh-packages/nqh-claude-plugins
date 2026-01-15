---
paths: **/wrangler.jsonc, **/wrangler.json, **/wrangler.toml
---

# Cloudflare Worker-to-Worker Routing

## Rule

Worker-to-Worker communication MUST use **Service Bindings** (see `service-bindings.md`).

HTTP fetch with `custom_domain` is **DEPRECATED** - use only as fallback for legacy code.

## Primary Pattern: Service Bindings

```jsonc
// ✅ RECOMMENDED: Service Binding (zero latency, direct RPC)
{
  "services": [
    { "binding": "CMS", "service": "latinamerica-hu-cms" }
  ]
}
```

See `service-bindings.md` for full implementation guide.

## Fallback Pattern: Custom Domains (DEPRECATED)

Only use if Service Bindings cannot be implemented:

```jsonc
// ⚠️ DEPRECATED: HTTP fetch with custom domain
{ "pattern": "cms.example.com", "custom_domain": true }

// ❌ FAILS - same-zone fetch blocked
{ "pattern": "cms.example.com/*", "zone_name": "example.com" }
```

## Why Service Bindings > Custom Domains

| Aspect | Custom Domains | Service Bindings |
|--------|---------------|------------------|
| Latency | Network round-trip | Zero (same thread) |
| Reliability | HTTP issues possible | Direct invocation |
| Debugging | Hard to trace | Clear call stack |

## Symptoms of HTTP Fetch Issues

- Intermittent "Failed to load content"
- CMS works externally but fails Worker-to-Worker
- 500 errors with no CF logs

## Reference

- **Primary**: `service-bindings.md`
- [Custom Domains Docs](https://developers.cloudflare.com/workers/configuration/routing/custom-domains/) (fallback only)
