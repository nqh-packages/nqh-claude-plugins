---
paths: **/src/**/*.{ts,tsx}
---

# TypeScript Patterns

## Discriminated Unions

```typescript
type Success<T> = { type: "success"; data: T }
type Error = { type: "error"; error: string }
type Result<T> = Success<T> | Error

function handle<T>(result: Result<T>): string {
  switch (result.type) {
    case "success": return `Success: ${result.data}`
    case "error": return `Error: ${result.error}`
    default:
      const _: never = result
      return _
  }
}
```

## Type Guards

```typescript
function isString(value: unknown): value is string {
  return typeof value === "string"
}

const strings = mixed.filter(isString)  // Type: string[]
```

## Const Assertions

```typescript
const colors = ["red", "green"] as const
// Type: readonly ["red", "green"]

const Direction = { Up: "UP", Down: "DOWN" } as const
type Direction = typeof Direction[keyof typeof Direction]
```

## Parse Don't Validate

```typescript
type Email = string & { readonly __brand: unique symbol }

function parseEmail(input: string): Email | null {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input) ? input as Email : null
}
```
