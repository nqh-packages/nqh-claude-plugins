---
paths: sites/**/package.json, sites/**/vite.config.ts
---

# Site Port Configuration

## Rule

MUST specify port in `package.json` dev script for shell function detection (`sc`, `dev`, `grab`).

## Format

```json
{
  "scripts": {
    "dev": "vite --port {PORT}"
  }
}
```

## Why

Shell functions (`_get_site_port`) extract port from package.json dev script. If port only in vite.config.ts, detection fails → proxy errors.

## Port Generation Algorithm

| Type | Formula | Range | Example |
|------|---------|-------|---------|
| **Frontend** | T9(first 4 alpha chars) | 2222-9999 | teander → 8326 |
| **CMS** | "1" + first 3 digits of frontend | 1222-1999 | teander-cms → 1832 |

**Collision-free by design**: Frontend ports start with 2-9, CMS ports always start with 1.

## T9 Mapping

| Letters | Digit |
|---------|-------|
| ABC | 2 |
| DEF | 3 |
| GHI | 4 |
| JKL | 5 |
| MNO | 6 |
| PQRS | 7 |
| TUV | 8 |
| WXYZ | 9 |

## Current Assignments

| Site | Frontend | CMS |
|------|----------|-----|
| teander | 8326 (tean) | 1832 (1+tea) |
| latinamerica.hu | 2708 | 1270 |
| otthonvarazs | 6884 (otth) | 1688 (1+ott) |
| nailsbystella | 6245 (nail) | 1624 (1+nai) |
| ngoquochuy | 6467 (ngoq) | 1646 (1+ngo) |

## Scripts

```bash
# Check ports for sites
bun run scripts/lib/port-utils.ts --check teander latinamerica.hu otthonvarazs

# Get port for a specific site
bun run scripts/lib/port-utils.ts mysite
bun run scripts/lib/port-utils.ts mysite --cms
```

## Anti-Pattern

```json
// ❌ Port only in vite.config.ts
{ "dev": "vite" }

// ✅ Port in package.json
{ "dev": "vite --port 2708" }
```
