# shadcn/ui

## Rule

Per-app setup. Use `shadcn` MCP server for all UI work.

## Setup

```
components.json + src/lib/utils.ts + src/components/ui/
```

## Install

```bash
cd apps/{app} && bunx --bun shadcn@latest add button
```

## Tailwind v4

```css
:root { --background: hsl(0 0% 100%); }
@theme inline { --color-background: var(--background); }
```

## React 19

NO `forwardRef`. Use `React.ComponentProps<"element">` + `data-slot`.

## FORBIDDEN

`tailwind.config.ts` | `forwardRef` | hardcoded colors

## Base UI Support (shadcn 3.0+)

### Library Selection

```bash
# Full customization including library selection
npx shadcn create

# During init, select library:
# - Radix (default, current behavior)
# - Base UI (accessible primitives from MUI team)
```

### Visual Styles

| Style | Description |
|-------|-------------|
| **Vega** | Classic shadcn/ui look |
| **Nova** | Reduced padding/margins for compact layouts |
| **Maia** | Soft and rounded with generous spacing |
| **Lyra** | Boxy and sharp, pairs with mono fonts |
| **Mira** | Compact, made for dense interfaces |

### Base UI (REQUIRED)

| Aspect | Value |
|--------|-------|
| **Library** | Base UI (NOT Radix) |
| **Team** | MUI |
| **Accessibility** | WCAG 2.1+ |

CLI auto-detects from `components.json`
