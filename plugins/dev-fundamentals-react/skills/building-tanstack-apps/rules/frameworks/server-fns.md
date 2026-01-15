---
paths: **/src/routes/**/*.tsx
---

# TanStack Server Functions

## Basic Server Function

```tsx
import { createServerFn } from '@tanstack/start'

// GET (default)
export const getServerTime = createServerFn('GET', async () => {
  return new Date().toISOString()
})

// POST with validation
export const createUser = createServerFn('POST', async (data: { name: string }) => {
  return await db.user.create({ data })
})
```

## Where to Call

| Location | Pattern |
|----------|---------|
| **Route loaders** | `loader: () => getData()` |
| **Components** | `const fn = useServerFn(myServerFn)` |
| **Event handlers** | `mutation.mutate({ name: 'John' })` |

## With TanStack Query

```tsx
import { useMutation } from '@tanstack/react-query'

const updateUser = createServerFn('POST', async (data: { name: string }) => {
  return await db.user.update({ data })
})

function UserForm() {
  const mutation = useMutation({
    mutationFn: updateUser,
    onSuccess: () => {
      // Invalidate queries, show toast
    }
  })

  return (
    <form onSubmit={(e) => {
      e.preventDefault()
      mutation.mutate({ name: 'John' })
    }}>
      <button disabled={mutation.isPending}>
        {mutation.isPending ? 'Saving...' : 'Save'}
      </button>
    </form>
  )
}
```

## Error Handling

```tsx
import { redirect, notFound } from '@tanstack/react-router'

// Redirects
export const requireAuth = createServerFn('GET', async () => {
  const user = await getCurrentUser()
  if (!user) throw redirect({ to: '/login' })
  return user
})

// Not found
export const getPost = createServerFn('GET', async (id: string) => {
  const post = await db.findPost(id)
  if (!post) throw notFound()
  return post
})
```

## DO / DON'T

| DO | DON'T |
|----|-------|
| Server-only database access | Expose secrets to client |
| Input validation | Skip validation |
| Compose server functions | Duplicate logic |
| Type inference | Explicit `Promise<T>` |
