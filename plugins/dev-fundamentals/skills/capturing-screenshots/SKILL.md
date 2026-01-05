---
name: capturing-screenshots
description: Captures screenshots using Playwright. REQUIRES --device and capture mode. Supports element/viewport/full-page modes, hover/focus states, retina scale, custom output, masking, and animation freezing.
---

# Playwright Screenshots

## Quick Reference

```bash
# REQUIRED: 'capture' subcommand, --device and capture mode
screenshot capture <url> --<mode> -D <device> [options]

# Examples
screenshot capture https://example.com -v -D desktop                    # Viewport, desktop
screenshot capture https://example.com -e "nav" -s hover -D mobile      # Element hover
screenshot capture https://example.com -v -D mobile,tablet,desktop -l   # Multi-device, light only
```

## Required Flags

| Flag | Description |
|------|-------------|
| `--device, -D` | Device preset or WxH (REQUIRED, can repeat) |
| Capture mode | One of: `-e`, `-v`, `-F` (REQUIRED) |
| `--state, -s` | Element state (REQUIRED with `-e`) |

## Capture Modes (one REQUIRED)

| Flag | Description | Output |
|------|-------------|--------|
| `--element, -e <selector>` | Specific element | JPEG/PNG |
| `--viewport-only, -v` | Visible viewport | JPEG/PNG |
| `--full-page, -F` | Entire page (max 7500px, WebP) | WebP |

## Device Presets

| Preset | Dimensions | Preset | Dimensions |
|--------|------------|--------|------------|
| `desktop` | 1920x1080 | `iPhone-15` | 393x852 |
| `tablet` | 768x1024 | `iPhone-15-Pro-Max` | 430x932 |
| `mobile` | 375x667 | `Pixel-7` | 412x915 |
| `iPad` | 768x1024 | `Galaxy-S23` | 360x780 |
| `iPad-Pro` | 1024x1366 | Custom | `WxH` (e.g., `1440x900`) |

## Element Options

| Flag | Description |
|------|-------------|
| `--state, -s` | `default`, `hover`, `focus` (REQUIRED) |
| `--nth, -n` | Index when multiple match (0-indexed) |
| `--padding, -P <px>` | Add padding around element (default: 0) |

## Theme Options

| Flag | Description |
|------|-------------|
| (none) | Both light + dark |
| `--light-only, -l` | Light mode only |
| `--dark-only, -d` | Dark mode only |

## Timing Options

| Flag | Default | Description |
|------|---------|-------------|
| `--wait, -w <selector>` | - | Wait for element before capture |
| `--delay <ms>` | 0 | Delay after page load |
| `--network-timeout <ms>` | 30000 | Network idle timeout |

## Styling Options

| Flag | Description |
|------|-------------|
| `--no-animations` | Freeze CSS animations/transitions |
| `--mask, -m <selector>` | Hide element (repeatable) |
| `--scale <factor>` | Device scale (1 or 2 for retina) |

## Visibility Options

| Flag | Description |
|------|-------------|
| `--reveal-hidden, -R` | Force scroll-triggered elements visible (opacity 0→1) |
| `--scroll-page, -S` | Scroll entire page before capture (trigger lazy content) |
| `--inject-css, -C <css>` | Inject custom CSS before capture |

## Output Options

| Flag | Default | Description |
|------|---------|-------------|
| `--format, -f` | jpeg | `png` or `jpeg` |
| `--quality, -q` | 90 | JPEG quality (0-100) |
| `--output, -o` | /tmp/screenshots | Custom output directory |
| `--no-open` | false | Don't auto-open Finder |
| `--skip-health-check` | false | Skip server health check |

## Comparison Options

| Flag | Description |
|------|-------------|
| `--compare <url>` | Second URL for side-by-side comparison |
| `--compare-click <selector>` | Different click selector for compare URL |
| `--click <selector>` | Click element before capture (menus, dropdowns) |
| `--click-delay <ms>` | Delay after click (default: 300) |

## Compare Command

Compare any two images (not just captures):

```bash
# Side-by-side comparison (default)
screenshot compare left.png right.png -o combined.jpg

# Vertical stack
screenshot compare before.png after.png -o stacked.jpg --mode stack

# Overlay with blend mode (for visual diff)
screenshot compare old.png new.png -o diff.jpg --mode overlay --blend difference
```

### Compare Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| `side-by-side` | Horizontal layout (default) | A/B comparison |
| `stack` | Vertical layout | Before/after |
| `overlay` | Blend modes | Visual diff detection |

### Blend Modes (for overlay)

| Mode | Description |
|------|-------------|
| `difference` | Highlights changes (recommended for diff) |
| `exclusion` | Similar to difference, lighter |
| `multiply` | Darker combination |
| `screen` | Lighter combination |
| `over` | Simple overlay (default) |
| `soft-light` | Soft contrast |
| `hard-light` | Strong contrast |

## Examples

```bash
# Element capture with hover state
screenshot capture https://example.com -e "button" -s hover -D desktop -l

# Multiple devices
screenshot capture https://example.com -v -D mobile -D tablet -D desktop

# Retina quality
screenshot capture https://example.com -v -D iPhone-15 --scale 2

# Wait for lazy content
screenshot capture https://example.com -v -D desktop --wait ".lazy-image"

# Mask sensitive data
screenshot capture https://example.com -v -D desktop -m ".email" -m ".api-key"

# Custom output, no Finder
screenshot capture https://example.com -v -D desktop -o ./screenshots --no-open

# Delay for animations
screenshot capture https://example.com -v -D desktop --delay 500 --no-animations

# Reveal hidden scroll-triggered elements
screenshot capture https://example.com -v -D desktop -R

# Scroll page to trigger lazy-loading before capture
screenshot capture https://example.com -v -D desktop -S

# Inject custom CSS
screenshot capture https://example.com -v -D desktop -C "body { background: red !important; }"

# Element with padding (prevents clipping)
screenshot capture https://example.com -e ".card" -s default -D desktop -P 20

# Compare local vs production
screenshot capture http://localhost:5173 -v -D desktop --compare https://example.com

# Click to open menu before capture
screenshot capture https://example.com -v -D desktop --click "[data-menu]"

# Compare two local images
screenshot compare before.png after.png -o comparison.jpg --mode side-by-side

# Visual diff with overlay
screenshot compare old.png new.png -o diff.jpg --mode overlay --blend difference
```

## Output Structure

```
/tmp/screenshots/<app>-<route>-<mode>-<timestamp>/
├── desktop-light.jpg
├── desktop-dark.jpg
├── tablet-light.jpg
└── ...
```

Naming: `{device}-{theme}.{format}`

## Folder Naming

| Component | Source |
|-----------|--------|
| App | Hostname or detected from cwd |
| Route | URL pathname |
| Mode | `-viewport`, `-element-{selector}-{state}`, `-fullpage` |
| Timestamp | `YYYYMMDD-HHMMSS` |

## Prerequisites

```bash
cd .claude/skills/capturing-screenshots
bun install
npx playwright install chromium
```

## Global CLI Setup

```bash
# Link the TypeScript entry point
ln -sf ~/.claude/skills/capturing-screenshots/scripts/capture.ts ~/.local/bin/capture

# Create alias in shell config
alias screenshot="bun ~/.claude/skills/capturing-screenshots/scripts/capture.ts"
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Chromium not found | `npx playwright install chromium` |
| Element not found | Check selector, try `-n 0` for first match |
| Timeout on element | Element may be hidden at viewport size |
| Large full-page | Install `sharp` for auto-resize |

## When to Use

| Use | Don't Use |
|-----|-----------|
| Responsive testing | Single quick screenshot (use browser) |
| Theme verification | Video/animation recording |
| Visual QA | PDF generation (use pdf skill) |
| Design implementation check | |
