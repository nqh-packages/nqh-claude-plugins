---
paths: **/src/**/*.{ts,tsx}
---

# TypeScript Generics

## Constraints

```typescript
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key]
}

interface HasLength { length: number }
function logLength<T extends HasLength>(arg: T): T {
  console.log(arg.length)
  return arg
}
```

## Defaults

```typescript
type APIResponse<T = unknown> = {
  data: T
  status: number
}
```

## NoInfer (TS 5.8+)

```typescript
// Prevent type widening
function createPair<T>(value: T, values: NoInfer<T>[]): [T, T[]] {
  return [value, values]
}
```
