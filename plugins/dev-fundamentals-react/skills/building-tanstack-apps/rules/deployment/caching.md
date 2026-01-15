# Cloudflare Caching

## Rule

Cache aggressively, purge surgically. Use Cache-Tag for invalidation.

## Architecture

| Layer | TTL |
|-------|-----|
| Browser | 1y (static), 0 (HTML) |
| Edge | 30d |
| KV | 30d |
| D1 | Origin |

## KV Namespaces

| Site | ID |
|------|-----|
| otthonvarazs | `1fd851a9696b4c8aa5b44cd8d473219d` |
| latinamerica | `9b2bd9b4c0824466a8a107ae4d961947` |
| teander | `b404e3ec469f491b9e4e5e14bb510bc0` |

## Zone IDs

| Site | ID |
|------|-----|
| otthonvarazs.eu | `6ce8f08b2b22c69b4b101569105ee2dd` |
| latinamerica.hu | `4e02d03741b1a9eb3169f5831bf4ed81` |

## Cache Headers

```typescript
// Static: 'public, max-age=31536000, immutable'
// HTML: 'public, max-age=0, s-maxage=2592000, stale-while-revalidate=86400'
// API: 'public, max-age=0, s-maxage=86400'
```

## Invalidation

```typescript
import { createCacheInvalidationHooks } from '@nqh/payload-cms/hooks'
const hooks = createCacheInvalidationHooks({ zoneId: ZONE_ID })
```

## Dashboard (Manual)

Enable: Tiered Cache, Cache Reserve, Early Hints

## OpenNext + Bun

Remove `pnpm-lock.yaml` before deploying CMS sites.

## FORBIDDEN

Cache user-specific data, POST responses, without invalidation strategy
