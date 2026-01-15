---
paths: **/db/**/*.ts, **/services/**/*.ts, **/hooks/**/*.ts
---

# D1 Atomic Operations

## Rule

MUST use atomic SQL updates. FORBIDDEN: read-then-write patterns.

## Atomic vs Non-Atomic

| ❌ Race Condition | ✅ Atomic |
|-------------------|-----------|
| `SELECT count` → `UPDATE count = val` | `UPDATE count = count + 1` |
| Separate statements | `env.DB.batch([...])` |

## Relative Updates

```sql
-- ✅ Atomic
UPDATE topics SET count = count + 1 WHERE id = ?;
UPDATE users SET credits = credits - ? WHERE id = ? AND credits >= ?;
```

## D1 Batch

```typescript
await env.DB.batch([
  env.DB.prepare('UPDATE topics SET count = count + 1 WHERE id = ?').bind(id),
  env.DB.prepare('INSERT INTO logs (action) VALUES (?)').bind('updated'),
])
// All-or-nothing: any failure rolls back entire batch
```

## Optimistic Locking

```typescript
const result = await env.DB.prepare(
  'UPDATE items SET data = ?, version = version + 1 WHERE id = ? AND version = ?'
).bind(newData, id, currentVersion).run()
if (result.changes === 0) throw new Error('Conflict')
```

## FORBIDDEN in D1

`BEGIN TRANSACTION`, `SELECT FOR UPDATE`, long transactions
