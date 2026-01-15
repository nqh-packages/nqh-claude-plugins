---
name: building-tanstack-apps
description: Automatically activates when user mentions TanStack Start, SSR, server functions, type-safe routing, middleware, or framework setup. Full-stack React framework with Cloudflare/Railway deployment support.
---

# TanStack Start

Use this skill when working with TanStack Start for React applications, including:
- Creating new TanStack Start projects with React
- Implementing SSR, streaming, and server-side rendering
- Setting up server functions, middleware, and authentication
- Configuring routing with TanStack Router
- Deploying to Vercel, Netlify, Cloudflare, or custom hosting
- Migrating from Next.js to TanStack Start
- Integrating databases (Prisma, Drizzle) and auth providers (Clerk, Auth.js)

---

## Quick Start

The fastest way to get started:

```bash
bun create @tanstack/start@latest
# or
npm create @tanstack/start@latest
```

Clone an example:

```bash
npx gitpick TanStack/router/tree/main/examples/react/start-basic my-app
cd my-app
npm install && npm run dev
```

**Available Examples:**
- start-basic - Basic setup
- start-basic-auth - Authentication with Prisma
- start-clerk-basic - Clerk authentication
- start-supabase-basic - Supabase integration
- start-workos - WorkOS enterprise auth
- start-convex-trellaux - Convex + Trello clone

---

## Breaking Changes & Migration

### v1.139.x - Vite Config Import Changes (November 2023)

**Issue**: `@tanstack/react-start/config` module removed

**Breaking Change**:
```typescript
// ❌ BROKEN (v1.139+)
import { defineConfig } from '@tanstack/react-start/config'
import { TanStackRouterVite } from '@tanstack/router-plugin/vite'

// ✅ CORRECT (v1.139+)
import { defineConfig } from 'vite'
import { tanstackStart } from '@tanstack/react-start/plugin/vite'
```

**Migration Steps**:

1. **Update vite.config.ts imports**:
   ```diff
   - import { defineConfig } from '@tanstack/react-start/config'
   - import { TanStackRouterVite } from '@tanstack/router-plugin/vite'
   + import { defineConfig } from 'vite'
   + import { tanstackStart } from '@tanstack/react-start/plugin/vite'
   ```

2. **Update plugin configuration**:
   ```diff
   export default defineConfig({
     plugins: [
       tsconfigPaths(),
   -   TanStackRouterVite({
   -     routesDirectory: './src/routes',
   -     generatedRouteTree: './src/routeTree.gen.ts',
   -   }),
   +   tanstackStart({
   +     router: {
   +       routesDirectory: './src/routes',
   +       generatedRouteTree: './src/routeTree.gen.ts',
   +     },
   +   }),
       react(),
     ],
   })
   ```

3. **Plugin order matters**: React plugin MUST come after TanStack Start plugin

**References**:
- [Migrating TanStack Start from Vinxi to Vite](https://blog.logrocket.com/migrating-tanstack-start-vinxi-vite/)
- [Build from Scratch Guide](https://tanstack.com/start/latest/docs/framework/react/build-from-scratch)

---

## Overview

**TanStack Start** is a full-stack React framework powered by:
- **TanStack Router** - Type-safe routing with nested routes, search params, data loading
- **Vite** - Fast development with HMR and optimized production builds

**Key Features:**
- Full-document SSR - Server-side rendering for performance and SEO
- Streaming - Progressive page loading
- Server Functions - Type-safe RPCs between client and server
- Middleware & Context - Request/response handling and data injection
- Server Routes & API Routes - Backend endpoints alongside frontend
- Universal Deployment - Deploy to any Vite-compatible hosting provider
- End-to-End Type Safety - Full TypeScript support across the stack

**Limitations:**
- React Server Components are not yet supported (actively in development)

---

## Common Patterns

### Authentication

**Partner Solutions:**
- [Clerk](https://clerk.dev) - Complete auth platform with UI components, social logins, MFA
- [WorkOS](https://workos.com) - Enterprise auth with SSO, directory sync, compliance

**DIY Options:**
- Better Auth - TypeScript-first auth library
- Auth.js (NextAuth.js) - Popular React auth library
- Supabase Auth - Open source Firebase alternative

**Architecture Patterns:**

**Session Management:**
- HTTP-Only Cookies (Recommended) - Secure, automatic browser handling, CSRF protection
- JWT Tokens - Stateless, good for APIs, requires careful XSS handling
- Server-Side Sessions - Centralized control, easy revocation, needs storage

**Route Protection:**
- Layout Route Pattern (Recommended) - Protect entire subtrees with parent layouts
- Component-Level Protection - Granular UI control
- Server Function Guards - Server-side validation before operations

**Examples:**
- [Clerk Integration](https://github.com/TanStack/router/tree/main/examples/react/start-clerk-basic)
- [WorkOS Integration](https://github.com/TanStack/router/tree/main/examples/react/start-workos)
- [Basic Auth with Prisma](https://github.com/TanStack/router/tree/main/examples/react/start-basic-auth)

---

### Server Functions

> **Note**: Static patterns moved to `.claude/rules/code-style/server-functions.md`

Define server-only logic callable from anywhere (loaders, components, hooks).

See `.claude/rules/code-style/server-functions.md` for complete patterns, error handling, middleware integration, and authentication strategies.

---

### Routing

> **Note**: Static patterns moved to `.claude/rules/code-style/tanstack-patterns.md`

**File-Based Routing** with type-safe routing and SSR support.

See `.claude/rules/code-style/tanstack-patterns.md` for:
- File structure patterns
- Root route setup
- Dynamic routes
- Type inference (CRITICAL)
- SSR safety
- Router integration with components

---

### Middleware

Customize server routes and server functions:

```tsx
import { createMiddleware } from '@tanstack/react-start'

// Logging middleware
const logger = createMiddleware().server(async ({ next }) => {
  console.log('Request received')
  const result = await next()
  console.log('Response sent')
  return result
})

// Auth middleware with context
const auth = createMiddleware({ type: 'function' })
  .server(async ({ next }) => {
    const user = await getCurrentUser()
    if (!user) throw redirect({ to: '/login' })
    return next({ context: { user } })
  })

// Use with server function
const getProfile = createServerFn()
  .middleware([auth])
  .handler(async ({ context }) => {
    return context.user.profile
  })
```

**Global Middleware:**

```tsx
// src/start.ts
import { createStart } from '@tanstack/react-start'

export const startInstance = createStart(() => ({
  requestMiddleware: [corsMiddleware],
  functionMiddleware: [authMiddleware],
}))
```

---

### Environment Variables

**Server-Only (no prefix):**

```typescript
// Server function - access any variable
const connectDB = createServerFn().handler(async () => {
  const db = await connect(process.env.DATABASE_URL)
  return db
})
```

**Client-Safe (`VITE_` prefix):**

```typescript
// Client component - only VITE_ variables
export function App() {
  return <h1>{import.meta.env.VITE_APP_NAME}</h1>
}
```

**Environment Files:**

```
.env.local          # Local overrides (gitignored)
.env.production     # Production-specific
.env.development    # Development-specific
.env                # Default (committed)
```

---

## Full Documentation

For comprehensive guides, see the `references/` directory:

### Core Guides
- [Execution Model](file:.claude/skills/building-tanstack-apps/references/execution-model.md)
- [Code Execution Patterns](file:.claude/skills/building-tanstack-apps/references/code-execution-patterns.md)
- [Server Entry Point](file:.claude/skills/building-tanstack-apps/references/server-entry-point.md)
- [Client Entry Point](file:.claude/skills/building-tanstack-apps/references/client-entry-point.md)

### Features
- [Authentication (Full Guide)](file:.claude/skills/building-tanstack-apps/references/authentication.md)
- [Server Routes](file:.claude/skills/building-tanstack-apps/references/server-routes.md)
- [Static Server Functions](file:.claude/skills/building-tanstack-apps/references/static-server-functions.md)
- [Streaming Data](file:.claude/skills/building-tanstack-apps/references/streaming-data.md)
- [Selective SSR](file:.claude/skills/building-tanstack-apps/references/selective-ssr.md)
- [SPA Mode](file:.claude/skills/building-tanstack-apps/references/spa-mode.md)
- [Static Prerendering](file:.claude/skills/building-tanstack-apps/references/static-prerendering.md)

### Deployment & Integration
- [Hosting](file:.claude/skills/building-tanstack-apps/references/hosting.md)
- [Databases](file:.claude/skills/building-tanstack-apps/references/databases.md)
- [Observability](file:.claude/skills/building-tanstack-apps/references/observability.md)
- [Tailwind CSS Integration](file:.claude/skills/building-tanstack-apps/references/tailwind-integration.md)
- [Path Aliases](file:.claude/skills/building-tanstack-apps/references/path-aliases.md)

### Troubleshooting
- [Hydration Errors](file:.claude/skills/building-tanstack-apps/references/hydration-errors.md)

### Migration
- [Migrate from Next.js](file:.claude/skills/building-tanstack-apps/references/migrate-from-nextjs.md)
- [Build from Scratch](file:.claude/skills/building-tanstack-apps/references/build-from-scratch.md)

### Tutorials
- [Reading and Writing Files](file:.claude/skills/building-tanstack-apps/references/tutorial-reading-writing-file.md)
- [Fetching from External API](file:.claude/skills/building-tanstack-apps/references/tutorial-fetching-external-api.md)

---

## Additional Resources

- **Official Documentation**: https://tanstack.com/start/latest/docs
- **GitHub Repository**: https://github.com/TanStack/router
- **Examples**: https://tanstack.com/start/latest/docs/framework/react/examples
- **Discord Community**: https://tanstack.com/discord

**Note**: This skill focuses on React. For Solid.js support, refer to the official documentation.
