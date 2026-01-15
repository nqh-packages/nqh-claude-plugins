---
paths: **/ai/**/*.ts, **/workers/**/*.ts
---

# Cloudflare AI Debugging

## Rule

Use `console.warn` (ESLint). View with `wrangler tail` or AI Gateway dashboard.

## Logging

```typescript
console.warn(`[ai] ${topic}: ${response}`)  // NOT console.log
```

## Viewing

| Method | Command |
|--------|---------|
| Terminal | `wrangler tail --format=pretty` |
| Dashboard | Workers > Logs > Live |
| AI Gateway | AI > AI Gateway > Logs (full prompt/response) |

## Enable

```toml
# wrangler.toml
logpush = true
```
