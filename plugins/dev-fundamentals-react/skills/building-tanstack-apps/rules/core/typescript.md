---
paths: "**/*.ts, **/*.tsx, **/*.mts, **/*.cts"
---

# TypeScript Code Style

## Naming

| Category | Convention | Example |
|----------|-----------|---------|
| Files | `kebab-case.{tsx,ts}` | `user-profile.tsx` |
| Hooks | `use-kebab-case.ts` | `use-auth.ts` |
| Variables | `camelCase` | `userName` |
| Functions | `camelCase` | `formatDate` |
| Components | `PascalCase` | `UserProfile` |
| Constants | `SCREAMING_SNAKE_CASE` | `API_BASE_URL` |
| Interfaces | `PascalCase` (NO "I") | `User` |

## File Size

- Target: 300 LOC
- Cap: 350 LOC (ESLint enforced)

## Magic Numbers

FORBIDDEN. Allowed: `0, 1, -1, 2, 12, 16, 24, 60, 100, 1000`

## Import Aliases

- `@/` - App-internal (includes `@/components/ui/*` for shadcn)
- `@nqh/shared` - Cross-app utils
- `@nqh/systems/*` - Domain logic

## Design Tokens

- Tailwind classes ONLY
- NO hardcoded values in JSX
- Custom classes in `@layer utilities`
