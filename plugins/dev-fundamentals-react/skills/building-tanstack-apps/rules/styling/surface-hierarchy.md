---
paths: **/src/styles/**/*.css
---

# Surface Hierarchy (4 Levels ONLY)

## The 4 Levels

| Level | Purpose | Tokens |
|-------|---------|--------|
| surface-0 | Base cards | `shadow-sm rounded-lg border bg-background` |
| surface-1 | Elevated | `shadow-md rounded-xl border bg-elevated` |
| surface-2 | Modals | `shadow-lg rounded-2xl border-2 bg-surface` |
| surface-3 | Critical | `shadow-2xl rounded-3xl border-4 ring-4 ring-primary/10` |

## Implementation

```css
/* globals.css - EXACTLY 4 levels */
.surface-0 { @apply shadow-sm rounded-lg border bg-background; }
.surface-1 { @apply shadow-md rounded-xl border bg-elevated; }
.surface-2 { @apply shadow-lg rounded-2xl border-2 bg-surface; }
.surface-3 { @apply shadow-2xl rounded-3xl border-4 ring-4 ring-primary/10; }
```

## FORBIDDEN

- Ad-hoc shadows: `className="shadow-lg"` ❌
- Mixed levels: `className="surface-1 rounded-3xl"` ❌
- Inline styles: `style={{ boxShadow: '...' }}` ❌
- 5+ levels: `.surface-4` ❌
- Hardcoded values in JSX ❌

## Validation

- Elevation ONLY in globals.css
- ONE surface class per element
- NO semantic variables outside domain files
- ALL tokens have meaningful names
