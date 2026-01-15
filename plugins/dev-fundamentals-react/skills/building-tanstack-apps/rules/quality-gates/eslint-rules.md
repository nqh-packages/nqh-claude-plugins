# ESLint Rules (15 Total)

## Core (7)

| Rule | Config | Purpose |
|------|--------|---------|
| **File Size** | `max-lines: 350` | Target 300 LOC |
| **File Naming** | `kebabCase` | Consistent names |
| **Code Naming** | camelCase/PascalCase/SCREAMING_SNAKE_CASE | Conventions |
| **Import Aliases** | `@/` NOT `../../` | Clean imports |
| **Magic Numbers** | Extract to constants | NO hardcoded values |
| **File Headers** | JSDoc @what/@why/@props | Documentation |
| **Import Order** | Alphabetical | Auto-sorted |

## Design (3)

| Rule | Enforcement |
|------|-------------|
| **Tokens** | Tailwind + shared-styles.css ONLY |
| **No Hardcoded** | NO inline colors/spacing/fonts |
| **Custom** | `@layer utilities` in CSS |

## Accessibility (4)

**Alt text** (MUST) | **ARIA** (valid) | **Keyboard** (warn) | **Semantic** (`<button>` NOT `<div onClick>`)

## Security (4)

**Forbidden**: `eval()`, `setTimeout('code')`, `new Function()`, `<a href="javascript:">`

## Allowed Magic Numbers

`0, 1, -1, 2, 12, 16, 24, 60, 100, 1000` (array bounds, booleans, %, ms→s, CSS grid, base font)

## Exemptions

**500 LOC**: Types, tests, configs, generated | **NO headers**: `*.test.ts`, `*.config.ts`, `*.types.ts`, `index.ts`

## Auto-Fix

Import aliases, import order, Prettier (via `.husky/pre-commit`)
