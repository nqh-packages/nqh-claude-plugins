---
paths: **/src/**/*.{ts,tsx}
---

# Spacing Scale & Layout

## Core Spacing

| Category | Pattern | Value |
|----------|---------|-------|
| Sections | `space-y-8` or `gap-8` | 32px |
| Groups | `space-y-4` or `gap-4` | 16px |
| Within | `space-y-2` or `gap-2` | 8px |
| Icons | `h-4 w-4` | 16px standard |
| Width | `max-w-sm` to `max-w-7xl` | Constrained |

## Layouts

| Pattern | Classes |
|---------|---------|
| Horizontal | `flex items-center gap-2` |
| Vertical | `flex flex-col space-y-2` |
| Grid | `grid grid-cols-2 gap-4` |
| Space between | `flex justify-between items-center` |

## Container Pattern

```tsx
// Backgrounds full-width, content constrained
<main>
  <section className="bg-white py-20">
    <Container>
      <h1>Hero</h1>
    </Container>
  </section>
</main>

// Container component
export function Container({ className, children }) {
  return (
    <div className={cn("mx-auto max-w-7xl px-4 sm:px-6 lg:px-8", className)}>
      {children}
    </div>
  );
}
```

## Grid Rules

**Must be 4px/8px multiples**: p-4, gap-8, mt-6 (NOT p-[17px])

## Touch Targets

Min 44x44px on mobile for interactive elements

## Icon + Text Alignment

**Use inline elements with `align-middle`, NOT flexbox.** Flexbox `items-center` causes ~12px offset issues.

```tsx
// ✅ CORRECT: Inline + align-middle
<p className="text-[11px] uppercase">
  <Icon className="inline-block size-[1em] align-middle mr-2" />
  <span className="align-middle">{label}</span>
</p>

// ❌ WRONG: Flexbox + negative margin (fights alignment)
<div className="flex items-center gap-2 text-[11px]">
  <Icon className="size-[1em] -mt-2" />
  <span>{label}</span>
</div>
```

| Rule | Why |
|------|-----|
| `inline-block` on icon | Makes icon inline element |
| `align-middle` on both | Aligns to middle of text |
| `size-[1em]` | Icon scales with font size |
| `mr-2` for spacing | Replaces flex `gap` |
| **NO flexbox** | Avoids structural offset issues |
