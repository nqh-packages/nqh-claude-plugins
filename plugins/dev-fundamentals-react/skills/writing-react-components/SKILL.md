---
name: writing-react-components
description: >
  React component implementation standards with Tailwind, motion/react, accessible primitives,
  and performance-first patterns. Auto-activates when writing React components, pages, or features.
  MANDATORY skill for all React frontend implementation.
---

# React Component Implementation Standards

MANDATORY standards for all React component implementation. Use PROACTIVELY when writing any React frontend code.

## Stack Requirements

| Tool | Purpose | Status |
|------|---------|--------|
| **Tailwind CSS** | Styling | MUST use defaults unless custom exists |
| **motion/react** | JS animation | MUST use when animation required |
| **tw-animate-css** | Entrance/micro animations | SHOULD use for simple animations |
| **cn utility** | Class logic | MUST use (clsx + tailwind-merge) |

### cn Utility Pattern

```typescript
// lib/utils.ts
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

## Component Primitives

### Hierarchy (STRICT)

| Priority | Source | When |
|----------|--------|------|
| 1 | Project's existing primitives | ALWAYS check first |
| 2 | Base UI | New primitives (preferred) |
| 3 | React Aria | Alternative to Base UI |
| 4 | Radix | When Base UI incompatible |

### Rules

| Rule | Enforcement |
|------|-------------|
| MUST use accessible primitives | Keyboard/focus behavior |
| MUST use project's existing primitives first | Check before adding |
| NEVER mix primitive systems | Same interaction surface |
| SHOULD prefer Base UI | New primitives |
| MUST add `aria-label` | Icon-only buttons |
| NEVER rebuild keyboard/focus by hand | Unless explicitly requested |

### Example: Dialog

```tsx
// ✅ CORRECT: Using Base UI
import { Dialog } from '@base-ui-components/react/dialog';

// ❌ WRONG: Rolling your own
const Dialog = ({ open, onClose }) => {
  // Manual focus trap, escape handler, etc.
};
```

## Interaction Patterns

| Pattern | Requirement |
|---------|-------------|
| **Destructive actions** | MUST use AlertDialog |
| **Loading states** | SHOULD use structural skeletons |
| **Full height** | NEVER `h-screen`, use `h-dvh` |
| **Fixed elements** | MUST respect `safe-area-inset` |
| **Error display** | MUST show next to action |
| **Input fields** | NEVER block paste |

### Safe Area Pattern

```tsx
// Fixed bottom element
<div className="fixed bottom-0 pb-[env(safe-area-inset-bottom)]">
  <Button>Action</Button>
</div>

// Full viewport
<main className="min-h-dvh pt-[env(safe-area-inset-top)]">
  {children}
</main>
```

## Animation Standards

### Rules

| Rule | Why |
|------|-----|
| NEVER add animation unless explicitly requested | Restraint over excess |
| MUST animate only compositor props | 60fps guarantee |
| NEVER animate layout properties | Jank, reflows |
| SHOULD avoid paint properties | Except small UI |
| SHOULD use `ease-out` on entrance | Natural deceleration |
| NEVER exceed 200ms for feedback | User perception |
| MUST pause loops when off-screen | Performance |
| SHOULD respect `prefers-reduced-motion` | Accessibility |
| NEVER custom easing curves | Unless explicitly requested |
| SHOULD avoid large image/surface animation | GPU memory |

### Compositor Props (ALLOWED)

```css
/* ✅ ALLOWED: transform, opacity */
.animate-in {
  transform: translateY(0);
  opacity: 1;
}

/* ❌ FORBIDDEN: layout properties */
.animate-in {
  width: 100%;      /* NO */
  height: auto;     /* NO */
  top: 0;           /* NO */
  left: 0;          /* NO */
  margin: 0;        /* NO */
  padding: 16px;    /* NO */
}
```

### Paint Props (LIMITED)

```css
/* ⚠️ LIMIT to small, local UI (text, icons) */
.hover-state {
  background: var(--hover);  /* Small elements only */
  color: var(--accent);      /* Small elements only */
}
```

### motion/react Pattern

```tsx
import { motion } from 'motion/react';

// Entrance animation
<motion.div
  initial={{ opacity: 0, y: 8 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.2, ease: 'easeOut' }}
>
  {content}
</motion.div>

// Interaction feedback (<200ms)
<motion.button
  whileTap={{ scale: 0.98 }}
  transition={{ duration: 0.1 }}
>
  Click
</motion.button>
```

### tw-animate-css Pattern

```tsx
// Simple entrance (no JS needed)
<div className="animate-in fade-in slide-in-from-bottom-2 duration-200">
  {content}
</div>

// Exit
<div className="animate-out fade-out slide-out-to-bottom-2 duration-150">
  {content}
</div>
```

### Reduced Motion

```tsx
// CSS approach
<div className="motion-safe:animate-in motion-safe:fade-in">
  {content}
</div>

// JS approach
import { useReducedMotion } from 'motion/react';

function Component() {
  const prefersReduced = useReducedMotion();
  return (
    <motion.div
      initial={{ opacity: prefersReduced ? 1 : 0 }}
      animate={{ opacity: 1 }}
    />
  );
}
```

## Typography

| Pattern | Usage | Class |
|---------|-------|-------|
| **Headings** | Balance lines | `text-balance` |
| **Body/paragraphs** | Prettier wrapping | `text-pretty` |
| **Data/numbers** | Aligned columns | `tabular-nums` |
| **Dense UI** | Overflow handling | `truncate` or `line-clamp-*` |
| **Letter spacing** | NEVER modify | No `tracking-*` |

```tsx
// ✅ CORRECT
<h1 className="text-balance">Long heading that balances well</h1>
<p className="text-pretty">Body text with better line breaks</p>
<td className="tabular-nums">1,234.56</td>
<span className="truncate">Very long text that truncates</span>

// ❌ WRONG
<h1 className="tracking-tight">Don't modify letter spacing</h1>
```

## Layout

### Z-Index Scale (FIXED)

| Token | Value | Use |
|-------|-------|-----|
| `z-0` | 0 | Base |
| `z-10` | 10 | Elevated cards |
| `z-20` | 20 | Dropdowns |
| `z-30` | 30 | Fixed headers |
| `z-40` | 40 | Modals |
| `z-50` | 50 | Toasts |

```tsx
// ✅ CORRECT: Use scale
<header className="fixed z-30">Nav</header>
<dialog className="z-40">Modal</dialog>

// ❌ WRONG: Arbitrary z-index
<div className="z-[999]">Don't do this</div>
```

### Square Elements

```tsx
// ✅ CORRECT: size-* for squares
<div className="size-10">Avatar</div>
<button className="size-8">Icon</button>

// ❌ LESS GOOD: w-* + h-*
<div className="w-10 h-10">Avatar</div>
```

## Performance

| Rule | Why |
|------|-----|
| NEVER animate large `blur()` or `backdrop-filter` | GPU intensive |
| NEVER apply `will-change` outside active animation | Memory hog |
| NEVER use `useEffect` for render logic | Can be computed |

### useEffect Anti-Pattern

```tsx
// ❌ WRONG: useEffect for derived state
const [fullName, setFullName] = useState('');
useEffect(() => {
  setFullName(`${firstName} ${lastName}`);
}, [firstName, lastName]);

// ✅ CORRECT: Compute during render
const fullName = `${firstName} ${lastName}`;

// ✅ CORRECT: useMemo for expensive computation
const sortedItems = useMemo(
  () => items.toSorted((a, b) => a.name.localeCompare(b.name)),
  [items]
);
```

## Design Constraints

| Rule | Why |
|------|-----|
| NEVER use gradients | Unless explicitly requested |
| NEVER use purple/multicolor gradients | AI slop aesthetic |
| NEVER use glow as primary affordance | Inaccessible |
| SHOULD use Tailwind default shadows | Unless custom requested |
| MUST give empty states one clear action | Guidance |
| SHOULD limit accent color to one per view | Focus |
| SHOULD use existing theme/Tailwind tokens | Consistency |

### Empty State Pattern

```tsx
// ✅ CORRECT: One clear action
<div className="flex flex-col items-center gap-4">
  <p className="text-muted-foreground">No items yet</p>
  <Button>Create your first item</Button>
</div>

// ❌ WRONG: Multiple competing actions
<div>
  <p>No items</p>
  <Button>Create</Button>
  <Button>Import</Button>
  <Button>Learn more</Button>
</div>
```

## Decision Tree

```
Component needed?
├─ Check project's existing primitives → USE if exists
├─ Needs keyboard/focus behavior?
│   ├─ YES → Use accessible primitive (Base UI > React Aria > Radix)
│   └─ NO → Plain div/button/etc.
├─ Animation needed?
│   ├─ Entrance/micro only → tw-animate-css
│   ├─ JS coordination needed → motion/react
│   └─ None requested → NO animation
└─ Styling?
    └─ Tailwind defaults → cn() for logic
```

## Checklist

### Before Implementation
- [ ] Checked existing project primitives
- [ ] Selected accessible primitive if needed
- [ ] Not mixing primitive systems

### Styling
- [ ] Using cn() for class logic
- [ ] Using Tailwind defaults (no custom unless exists)
- [ ] Fixed z-index scale (no arbitrary)
- [ ] size-* for square elements

### Animation
- [ ] Only added if explicitly requested
- [ ] Compositor props only (transform, opacity)
- [ ] Under 200ms for feedback
- [ ] prefers-reduced-motion handled

### Typography
- [ ] text-balance on headings
- [ ] text-pretty on body
- [ ] tabular-nums on data
- [ ] No tracking-* modifications

### Interaction
- [ ] AlertDialog for destructive actions
- [ ] h-dvh not h-screen
- [ ] safe-area-inset on fixed elements
- [ ] Errors next to action
- [ ] Never blocking paste

### Performance
- [ ] No large blur/backdrop-filter animations
- [ ] No will-change outside animation
- [ ] No useEffect for render logic

### Design
- [ ] No gradients (unless requested)
- [ ] No glow affordances
- [ ] One accent per view
- [ ] Empty states have one action
