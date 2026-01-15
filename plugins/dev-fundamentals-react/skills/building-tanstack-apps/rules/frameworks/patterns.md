---
paths: "**/*/src/routes/**/*.tsx"
---

# TanStack Start Patterns

## Routing

```
src/app/__root.tsx, index.tsx, posts.tsx, posts/index.tsx, posts/$postId.tsx
```

## Type Inference (CRITICAL)

| DO | DON'T |
|----|-------|
| `loader: ({ params }) => fetchPost(params.id)` | Explicit `Promise<T>` returns |
| `loaderData?.title` (SSR safe) | `loaderData.title` |
| `loader` → `beforeLoad` → `component` order | Random order |

## Route Definition

```tsx
export const Route = createFileRoute('/dashboard')({
  loader: async () => ({ user: await getUser() }),
  beforeLoad: ({ context }) => { if (!context.user) throw redirect({ to: '/login' }) },
  component: () => { const data = Route.useLoaderData(); return <h1>{data?.user.name}</h1> }
})
```

## Environment Variables

| Type | Access |
|------|--------|
| Server | `process.env.DATABASE_URL` |
| Client | `import.meta.env.VITE_*` |

## Button + Link

Use `createLink(forwardRef(...))` pattern. `<Button asChild><Link /></Button>` breaks (Radix incompatibility).

## Dark Mode FOUC Prevention

Add blocking inline script in `<head>` BEFORE CSS:

```tsx
<script dangerouslySetInnerHTML={{ __html: `(function(){var t=localStorage.getItem('theme');if(t==='dark'||(!t&&matchMedia('(prefers-color-scheme:dark)').matches))document.documentElement.classList.add('dark')})()` }} />
```
