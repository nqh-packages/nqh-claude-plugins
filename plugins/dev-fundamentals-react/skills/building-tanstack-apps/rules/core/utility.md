---
paths: **/src/**/*.{ts,tsx}
---

# TypeScript Utility Types

## Built-in

| Utility | Purpose |
|---------|---------|
| `Partial<T>` | All optional |
| `Required<T>` | All required |
| `Readonly<T>` | All readonly |
| `Pick<T, K>` | Select subset |
| `Omit<T, K>` | Exclude properties |
| `Record<K, T>` | Object with keys |
| `ReturnType<T>` | Extract return |
| `Parameters<T>` | Extract params |
| `Awaited<T>` | Unwrap Promise |

```typescript
type UserPreview = Pick<User, "id" | "name">
type UserWithoutId = Omit<User, "id">
type UserType = ReturnType<typeof getUser>
```

## Custom

```typescript
// Deep Partial
type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P]
}

// Keys of type
type KeysOfType<T, V> = {
  [K in keyof T]: T[K] extends V ? K : never
}[keyof T]

// Require specific props
type RequireProps<T, K extends keyof T> = T & Required<Pick<T, K>>
```
