---
paths: "**/src/**/*.tsx"
---

# Web Standards Checklist

## Design System

| Category | Rule |
|----------|------|
| **Tokens** | NO magic numbers (`p-4`, NOT `17px`), Semantic colors, 4px/8px spacing grid |
| **Typography** | 2 fonts max, 1.25 ratio scale |
| **Icons** | Single set (Lucide/Heroicons) |
| **Hierarchy** | Size = importance, high contrast (primary), whitespace (premium) |

## Interaction

| Category | Rule |
|----------|------|
| **States** | Hover (visible), Focus (replace outline), Active (feedback) |
| **Motion** | `duration-200` transitions, NO instant |
| **Loading** | Skeletons over spinners |

## Accessibility

| Rule | Requirement |
|------|-------------|
| **Contrast** | 4.5:1 WCAG AA |
| **Touch** | 44x44px min mobile |
| **Alt** | Descriptive OR empty (decorative) |
| **Semantic** | `<button>` actions, `<a>` links |

## TanStack Start

| Category | Pattern |
|----------|---------|
| **Architecture** | Server functions, isomorphic loaders, type-safe routing, `__root.tsx` |
| **Performance** | RSC default, TanStack Query, URL state, WebP/AVIF lazy |
| **Security** | Sanitize input, CSP, HttpOnly cookies |
| **Type Inference** | NO explicit `Promise<T>`, `loaderData?.title` (SSR safe), let router infer |

## Container (Golden Rule)

**Backgrounds** = full-width | **Content** = Container (`max-w-7xl` 1280px, `max-w-screen-2xl` 1440px, `max-w-prose` 65ch)

```tsx
<section className="bg-white py-20">
  <Container><h1>Hero</h1></Container>
</section>
```

## Animation (ibelick)

| Rule | Requirement |
|------|-------------|
| **Compositor only** | ONLY animate `transform`, `opacity` |
| **Feedback** | <200ms for interactions |
| **Reduced motion** | Respect `prefers-reduced-motion` |
| **Off-screen** | Pause looping animations when not visible |
| **Library** | Use `motion/react` for JS animations |

## Typography (ibelick)

| Rule | Requirement |
|------|-------------|
| **Headings** | `text-balance` for wrapping |
| **Body** | `text-pretty` for readability |
| **Data** | `tabular-nums` for numbers |
| **Letter-spacing** | NO modifications unless explicit |

## Layout (ibelick)

| Rule | Requirement |
|------|-------------|
| **Full viewport** | `h-dvh` NOT `h-screen` |
| **Squares** | `size-x` NOT `w-x h-x` |
| **Z-index** | Fixed scale (10, 20, 30, 40, 50) |

## Performance (ibelick)

| Rule | Requirement |
|------|-------------|
| **Blur** | Avoid animating large `blur`/`backdrop-filter` |
| **will-change** | Skip unless proven necessary |
| **Render** | Prefer render logic over `useEffect` |

## Interaction (ibelick)

| Rule | Requirement |
|------|-------------|
| **Destructive** | Use `AlertDialog` for destructive actions |
| **Paste** | NEVER block paste in inputs |
| **Errors** | Display contextually near source |
| **Icon buttons** | MUST have `aria-label` |

## Best Practices

**DO**: Mobile first, dark mode, lazy load, semantic HTML
**DON'T**: Scrolljacking, autoplay, "click here", >7 nav items, stock photos
