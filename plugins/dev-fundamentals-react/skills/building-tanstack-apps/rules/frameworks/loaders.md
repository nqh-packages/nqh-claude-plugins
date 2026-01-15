---
paths: **/src/routes/**/*.tsx
---

# TanStack Loaders

## Loader Pattern

```tsx
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/posts')({
  loader: () => getUsers(), // Implicit return, router infers type
  component: Posts,
})

function Posts() {
  const posts = Route.useLoaderData() // Typed automatically
  return <div>{posts.map(p => <Post key={p.id} {...p} />)}</div>
}
```

## Type Inference (CRITICAL)

| Pattern | ✅ DO | ❌ DON'T |
|---------|------|----------|
| **Loader returns** | `loader: ({ params }) => fetchPost(params.id)` | `loader: async (...): Promise<Post> => ...` |
| **loaderData access** | `loaderData?.title` (SSR safe) | `loaderData.title` (breaks SSR) |
| **Route order** | `loader` → `beforeLoad` → `component` | Random order |

## SSR Safety

```tsx
// ✅ Safe - handles undefined during SSR
export const Route = createFileRoute('/post/$id')({
  loader: ({ params }) => fetchPost(params.id),
  component: () => {
    const post = Route.useLoaderData()
    return <h1>{post?.title ?? 'Loading...'}</h1> // Optional chaining
  }
})

// ❌ Breaks during SSR
component: () => {
  const post = Route.useLoaderData()!
  return <h1>{post.title}</h1> // Runtime error
}
```

## Loader Dependencies

```tsx
export const Route = createFileRoute('/posts')({
  loaderDeps: ({ search }) => ({ filter: search.q }), // Re-fetch when search.q changes
  loader: ({ deps }) => fetchPosts(deps.filter),
})
```

## DO / DON'T

| DO | DON'T |
|----|-------|
| Implicit return types | `Promise<Post>` explicit types |
| `loaderData?.field` | `loaderData.field` or `loaderData!` |
| Let router infer everything | Add `as any` |
| `loader` before `component` | Random definition order |
