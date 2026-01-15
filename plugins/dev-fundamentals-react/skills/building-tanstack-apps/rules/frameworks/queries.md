---
paths: **/src/**/*.tsx
---

# TanStack Query Integration

## Route Loaders (Preferred)

```tsx
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/users')({
  loader: () => getUsers(), // Server function
  component: Users,
})

function Users() {
  const users = Route.useLoaderData() // SSR + client cache
  return <div>{users.map(u => <User key={u.id} {...u} />)}</div>
}
```

## Client-Side Queries

```tsx
import { useQuery, useMutation } from '@tanstack/react-query'

function UserProfile() {
  // Query
  const { data, isLoading } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
  })

  // Mutation
  const mutation = useMutation({
    mutationFn: updateUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['user', userId] })
    },
  })

  if (isLoading) return <div>Loading...</div>
  return <div>{data.name}</div>
}
```

## Suspense Pattern

```tsx
import { Suspense } from 'react'

function Page() {
  return (
    <Suspense fallback={<LoadingSkeleton />}>
      <AsyncComponent />
    </Suspense>
  )
}
```

## DO / DON'T

| DO | DON'T |
|----|-------|
| Route loaders for SSR data | `useQuery` in every component |
| `useMutation` for updates | Manual `fetch` in `onClick` |
| `Suspense` boundaries | Loading states everywhere |
| Invalidate queries after mutations | Refetch manually |
