---
name: writing-shadcn-components
description: Design custom UIs with shadcn/ui components. Visual composition patterns, component combinations, and layout strategies. Auto-activates on shadcn/ui, component design, visual hierarchy, or "how do I make X".
---

# shadcn/ui Component Patterns

## Component Architecture

| Type | Location | Import |
|------|----------|--------|
| **shadcn/ui** | `src/components/ui/` | `@/components/ui/*` |
| **App-Specific** | `src/components/` | `@/components/*` |

### Component Discovery (Use MCP)

**shadcn MCP server** is the default for all UI work:

| Action | MCP Tool |
|--------|----------|
| Browse components | `list_items_in_registries` |
| Search components | `search_items_in_registries` |
| Get install command | `get_add_command_for_items` |
| View component | `view_items_in_registries` |

```bash
cd apps/{app} && bunx --bun shadcn@latest add <component>
```
---

# When to Use

- Design/compose/build UI with shadcn/ui
- Combine components (Card + Avatar, Button + Badge)
- Visual hierarchy (spacing, sizing, colors)
- Layouts (forms, cards, dashboards, tables)
- "How do I make X look like Y"

# Core Patterns

> **Note**: Static spacing/layout patterns moved to `.claude/rules/code-style/spacing-scale.md`

See `.claude/rules/code-style/spacing-scale.md` for complete spacing scale, layout patterns, color patterns, and container strategy.

# Quick Examples

> **Note**: Static composition patterns moved to `.claude/rules/code-style/shadcn-ui-patterns.md`

See `.claude/rules/code-style/shadcn-ui-patterns.md` for:
- Component selection guide
- Common composition patterns (Input + Icon, Button + Badge, Stat Card, Login Form, Card + Avatar, Table Actions)
- Component location strategy
- Discovery protocol

# Router Integration

## TanStack Router + Button Styling

| Pattern                             | Works? | Why                                                                            |
| ----------------------------------- | ------ | ------------------------------------------------------------------------------ |
| `<Button asChild><Link /></Button>` | ❌     | Radix Slot + TanStack Router incompatibility → React Fragment className errors |
| `createLink(forwardRef(...))`       | ✅     | **Official TanStack Router pattern** for custom components                     |

```tsx
import { createLink } from '@tanstack/react-router'
import { forwardRef } from 'react'

const ButtonLink = createLink(
  forwardRef<HTMLAnchorElement, React.AnchorHTMLAttributes<HTMLAnchorElement>>(
    (props, ref) => <a ref={ref} {...props} />
  )
)

<ButtonLink
  to="/publications"
  className="inline-flex h-9 items-center justify-center rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-accent hover:text-accent-foreground"
>
  View Publications
</ButtonLink>
```

**Creates native `<a>` with TanStack Router context + full router props (`to`, `params`, `search`, `hash`, `activeProps`)**

Reference: `apps/latinamerica.hu/src/components/masthead.tsx:28-32, 115-126`

# Component Selection

| Component  | Variant       | Use Case                                                    |
| ---------- | ------------- | ----------------------------------------------------------- |
| **Button** | Default       | Primary action (1 per screen)                               |
|            | Outline       | Secondary actions                                           |
|            | Ghost         | Tertiary, icon-only (MUST have `aria-label`)                |
|            | Destructive   | Delete, remove, cancel (MUST use `AlertDialog`)             |
| **Badge**  | Default       | New items, active status                                    |
|            | Secondary     | Neutral states, categories                                  |
|            | Destructive   | Errors, alerts                                              |
|            | Outline       | Tags, filters (low emphasis)                                |
| **Card**   | Basic         | Content containers                                          |
|            | Header/Footer | Actionable content                                          |
|            | Interactive   | Clickable (hover)                                           |
|            | Stat          | Metrics display                                             |
| **Alert**  | Default       | Informational                                               |
|            | Destructive   | Errors, critical warnings                                   |
|            | Custom border | Success (`border-green-600`), Warning (`border-orange-600`) |

## ibelick Constraints

| Pattern | Rule |
|---------|------|
| Icon buttons | `aria-label` |
| Destructive | `AlertDialog` |
| Viewport | `h-dvh` |
| Inputs | Allow paste |
| Errors | Contextual |
| Primitives | Base UI |

```tsx
// ✅
<Button variant="ghost" aria-label="Close"><X className="size-4" /></Button>
<AlertDialog><AlertDialogTrigger asChild><Button variant="destructive">Delete</Button></AlertDialogTrigger></AlertDialog>
<main className="h-dvh">

// ❌
<Button variant="ghost"><X /></Button>
<Button variant="destructive" onClick={handleDelete}>
<main className="h-screen">
```

## DECISION TREE

```
┌─ Need a component?
│  └─ YES ↓
│
├─ Use shadcn MCP to search for component
│  ├─ FOUND → Install: cd apps/{app} && bunx --bun shadcn@latest add <component>
│  └─ NOT FOUND ↓
│
├─ Will 3+ apps use this logic?
│  ├─ YES → Create in packages/systems/ (shared logic only)
│  ├─ NO → Create in apps/{app}/src/components/ (local)
│  └─ MAYBE → Start local, extract after Rule of 3
│
└─ What pattern to use?
   ├─ Primitive → CVA + TypeScript (React 19: NO forwardRef)
   ├─ Composition → Combine existing @/components/ui/*
   └─ Router link → Use createLink pattern (NOT asChild)
```

## STEP-BY-STEP EXECUTION

### Step 1: SEARCH EXISTING COMPONENTS

- [ ] Use shadcn MCP: `search_items_in_registries` to find shadcn components
- [ ] Check `apps/{app}/src/components/ui/` for installed primitives
- [ ] Check `apps/{app}/src/components/` for app-specific components
- [ ] Check `packages/systems/` for shared logic (3+ apps)

### Step 2: DETERMINE COMPONENT LOCATION

**Decision Matrix:**

| Scenario | Location | Import |
|----------|----------|--------|
| shadcn/ui primitive exists | `apps/{app}/src/components/ui/` | `@/components/ui` |
| shadcn/ui primitive missing | Use MCP: `get_add_command_for_items` | `@/components/ui` |
| Shared logic (3+ apps) | `packages/systems/` | `@nqh/systems/*` |
| 1-2 apps only | `apps/{app}/src/components/` | `@/components/*` |
| Wrapper (<20 LOC) | `apps/{app}/src/components/` | Import base from `@/components/ui` |

### Step 3: ADD MISSING PRIMITIVES (if needed)

- [ ] Use shadcn MCP: `search_items_in_registries` to find component
- [ ] Use MCP: `get_add_command_for_items` to get install command
- [ ] Run: `cd apps/{app} && bunx --bun shadcn@latest add <component>`
- [ ] Verify installation in `apps/{app}/src/components/ui/`

### Step 4: DESIGN COMPONENT STRUCTURE

**For Primitives (CVA pattern - React 19):**
- [ ] Define base classes (common to all variants)
- [ ] Define variants (visual options: size, variant, etc.)
- [ ] Define defaultVariants
- [ ] Create TypeScript types with `React.ComponentProps<"element">`
- [ ] Use `data-slot` for composition (NO forwardRef in React 19)
- [ ] Export component + variants

**For Compositions:**
- [ ] Import primitives from `@/components/ui`
- [ ] Combine with layout (flex, grid, spacing)
- [ ] Apply design tokens from `globals.css`
- [ ] Add interaction states (hover, focus, disabled)

**For Router Links:**
- [ ] Use `createLink(forwardRef(...))` pattern
- [ ] Apply Button styles via className
- [ ] NEVER use `<Button asChild><Link /></Button>` (incompatible)

### Step 5: IMPLEMENT COMPONENT

- [ ] Create component file: `{component-name}.tsx`
- [ ] Import dependencies (CVA, cn, primitives)
- [ ] Implement component logic
- [ ] Add TypeScript types
- [ ] Export component + types

### Step 6: VALIDATE AGAINST STANDARDS

- [ ] Check design tokens usage (NO hardcoded values)
- [ ] Verify spacing scale from `.claude/rules/code-style/spacing-scale.md`
- [ ] Confirm accessibility (ARIA, semantic HTML, keyboard)
- [ ] Test responsive behavior
- [ ] Validate TypeScript types

### Step 7: DOCUMENT & EXPORT

**For app components:**
- [ ] Create barrel export in `apps/{app}/src/components/index.ts` if needed
- [ ] Document with JSDoc headers (@what, @why, @props)

**For shared logic (packages/systems/):**
- [ ] Export in `packages/systems/src/index.ts`
- [ ] Run `bun registry:update` to update REGISTRY.md

## ERROR HANDLING

| Error | Detection | Fix |
|-------|-----------|-----|
| **Component already exists** | Found in app components/ | Import and reuse, create variant wrapper if needed |
| **shadcn add fails** | bunx command error | Check internet, verify component name via MCP, check shadcn version |
| **TypeScript errors** | Type mismatch, missing types | Use `React.ComponentProps<"element">`, VariantProps |
| **Styles not applying** | Component renders without styles | Check Tailwind v4, verify globals.css imported, rebuild |
| **Router link breaks** | Fragment className errors | Use createLink pattern instead of asChild |
| **Import alias broken** | Cannot resolve @/ | Check tsconfig.json paths, verify components.json |

## SELF-DIAGNOSIS

Run these checks when component creation fails:

**Environment Checks:**
- [ ] Is app set up with components.json?
- [ ] Is shadcn/ui CLI available? (`bunx --bun shadcn@latest --version`)
- [ ] Are import aliases configured? (Check tsconfig.json)
- [ ] Is Tailwind v4 configured correctly?

**Component Structure:**
- [ ] Does component follow CVA pattern for variants?
- [ ] Using React 19 patterns? (NO forwardRef, use ComponentProps)
- [ ] Are TypeScript types correct?
- [ ] Is cn() utility used for className merging?

**Design Token Compliance:**
- [ ] Are all colors from design system?
- [ ] Are all spacing values from scale?
- [ ] Are font sizes from typography scale?
- [ ] No hardcoded px/rem values?

**Integration:**
- [ ] Is component exported correctly?
- [ ] Can it be imported from expected path?
- [ ] Does it work with TanStack Router (if link)?
- [ ] Is it SSR-compatible (if TanStack Start)?

## SELF-IMPROVEMENT

**Triggers (file-based):**

| Trigger | Action | File Check |
|---------|--------|------------|
| **New component pattern discovered** | Document in `.claude/rules/code-style/shadcn-ui-patterns.md` | Check if pattern already exists |
| **Better composition found** | Update examples in patterns file | Compare against existing compositions |
| **shadcn/ui version update** | Re-audit all apps, update if changed | Check shadcn MCP for updates |
| **Rule of 3 triggered** | Extract shared logic to packages/systems/ | Count usages across apps/ directory |
| **Router pattern improved** | Update router integration section | Test against TanStack Router latest |

**Improvement Pattern:**

1. **Discover**: Find new component pattern or better composition
2. **Document**: Update `.claude/rules/code-style/shadcn-ui-patterns.md`:
   ```markdown
   ### {Pattern Name}

   **Use Case**: {when to use}
   **Implementation**: {code example}
   **Location**: {where to create}
   ```
3. **Implement**: Create reference implementation in app
4. **Validate**: Check design tokens, a11y, TypeScript, SSR compatibility
5. **Share**: Pattern available for future component creation

**Session Start Check:**
- [ ] Use shadcn MCP to check for new components
- [ ] Check if any app components need extraction (Rule of 3)
- [ ] Verify app shadcn setup is current
- [ ] Update any deprecated patterns in documentation
