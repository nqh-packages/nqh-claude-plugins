# CF Workers SSR Global Scope

---
paths: **/vite.config.ts, sites/**/src/**/*.{ts,tsx}
---

## Rule

CF Workers FORBID async I/O at module level. Guard browser APIs with optional chaining.

## Forbidden at Module Level

`new AbortController()`, `fetch()`, `setTimeout()`, `crypto.randomUUID()`, static imports of client-only libs

## Fixes

| Problem | Solution |
|---------|----------|
| Client-only lib | Dynamic `import()` in `useEffect` |
| Transitive dep | Vite stub plugin (build only) |
| Browser API | `navigator.platform?.` not just `typeof navigator` |
| CF runtime module | Dynamic path construction (see below) |

## Dynamic Import Path Construction

Vite statically analyzes all `import()` calls, even with `/* @vite-ignore */`. To prevent analysis of CF Workers runtime modules:

```typescript
// ❌ WRONG: Vite still analyzes this
const { env } = await import(/* @vite-ignore */ 'cloudflare:workers');

// ✅ CORRECT: Dynamic construction prevents static analysis
const cfModule = 'cloudflare:' + 'workers';
const { env } = await import(cfModule);
```

Use this pattern for any CF runtime module (`cloudflare:workers`, `cloudflare:sockets`, etc.) when the import is behind a dev check but Vite still fails.

## Vite Stub Plugin

```typescript
function stubModule(name: string, exports: string[]): Plugin {
  const stub = exports.map(e => `export const ${e} = () => null;`).join('\n')
  return {
    name: `stub-${name}`, enforce: 'pre',
    resolveId(id) { if (id === name) return `\0${name}` },
    load(id) { if (id === `\0${name}`) return stub },
  }
}
```

## Known Issues

| Package | Fix |
|---------|-----|
| `lenis` | Dynamic import |
| `react-resizable-panels` | Stub plugin |
| `pino` | Lazy init in server fns |
| `cloudflare:workers` | Dynamic path construction |
| `cloudflare:sockets` | Dynamic path construction |
