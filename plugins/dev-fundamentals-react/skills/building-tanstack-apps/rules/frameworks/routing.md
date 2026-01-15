---
paths: **/src/routes/**/*.tsx
---

# TanStack Routing

## File-Based Routing

| File | Route | Params |
|------|-------|--------|
| `__root.tsx` | Root layout (always rendered) | - |
| `index.tsx` | `/` | - |
| `about.tsx` | `/about` | - |
| `posts.tsx` | `/posts` layout | - |
| `posts/index.tsx` | `/posts` | - |
| `posts/$postId.tsx` | `/posts/:postId` | `{ postId: string }` |

## Route Definition

```tsx
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/posts/$postId')({
  loader: ({ params }) => fetchPost(params.postId),
  component: PostComponent,
})
```

## Root Route Pattern

```tsx
// __root.tsx
import { Outlet, createRootRoute, HeadContent, Scripts } from '@tanstack/react-router'

export const Route = createRootRoute({
  head: () => ({
    meta: [
      { charSet: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { title: 'App Title' },
    ],
  }),
  component: () => (
    <html>
      <head><HeadContent /></head>
      <body>
        <Outlet />
        <Scripts />
      </body>
    </html>
  ),
})
```

## Type-Safe Links

```tsx
import { Link } from '@tanstack/react-router'

<Link
  to="/posts/$postId"
  params={{ postId: '123' }}
  search={{ tab: 'comments' }}
>
  View Post
</Link>
```

## DO / DON'T

| DO | DON'T |
|----|-------|
| `createFileRoute('/path')` | Manual route config |
| File-based routing | String-based routing |
| Typed params via `Route.useParams()` | `any` types |
