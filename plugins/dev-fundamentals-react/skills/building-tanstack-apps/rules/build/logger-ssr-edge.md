---
paths: **/components/**/*.tsx, **/routes/**/*.tsx, **/server/**/*.ts
---

# Logger SSR/Edge Compatibility

## Rule

NEVER create `@nqh/logger` at module level in SSR code. Use lazy init or console.

## Problem

`pino.transport()` uses dynamic `require()` → fails in Vite SSR and CF Workers.

## Symptoms

| Symptom | Cause |
|---------|-------|
| `unable to determine transport target` | Module-level logger in SSR |
| Server crash on first request | Logger before runtime check |

## Safe Locations

| Location | Safe? |
|----------|-------|
| Server functions | Yes |
| Route loaders | Yes |
| API routes | Yes |
| Component body | NO |
| Module top-level | NO |

## Patterns

```typescript
// ❌ Module-level (crashes SSR)
const logger = createLogger({ name: 'Form' })

// ✅ Console for client
console.info('[Form] submitted:', data)

// ✅ Logger in server function
const handler = createServerFn({ method: 'POST' }).handler(async ({ data }) => {
    const logger = createLogger({ name: 'FormHandler' })
    logger.info({ data }, 'submitted')
})
```
