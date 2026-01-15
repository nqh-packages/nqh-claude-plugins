---
paths: **/styles/globals.css, **/routes/__root.tsx
---

# FOUC Prevention for CSS

## Rule

TanStack Start apps MUST use visibility-based FOUC prevention: inline hide in `__root.tsx`, reveal at END of `globals.css`.

## Problem

| Symptom | Cause |
|---------|-------|
| Unstyled flash on page load | CSS loads after HTML renders |
| Missing gradients/spacing/radii | Tailwind CSS not parsed yet |
| Animations play before styles | JS hydrates before CSS |

## Pattern

### Step 1: Hide in `__root.tsx` (inline style in `<head>`)

```tsx
<head>
  <HeadContent />
  {/* FOUC Prevention: Hide until CSS loads */}
  <style
    id="fouc-guard"
    dangerouslySetInnerHTML={{
      __html: `html{visibility:hidden}`,
    }}
  />
</head>
```

### Step 2: Reveal at END of `globals.css`

```css
/* FOUC PREVENTION - MUST BE LAST IN FILE */
html {
  visibility: visible !important;
}
```

## Why This Works

| Phase | What Happens |
|-------|--------------|
| 1. HTML loads | Inline style hides page immediately |
| 2. CSS parses | Tailwind/custom styles load |
| 3. End of CSS | `!important` overrides inline, reveals page |
| 4. React hydrates | Page already styled, no flash |

## Examples

| ❌ DON'T | ✅ DO |
|----------|-------|
| `opacity: 0` (causes CLS) | `visibility: hidden` (no layout shift) |
| Put reveal in middle of CSS | Put reveal at END of file |
| Skip `!important` | Use `!important` (beats inline) |
| Use class toggle (needs JS) | Use pure CSS cascade |

## Evidence

nailsbystella FOUC fix (2025-12-28): `__root.tsx:53-59`, `globals.css:517-523`
