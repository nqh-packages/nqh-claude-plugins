# TanStack Start Scaffolding

## Command

```bash
bun run scripts/create-site.ts <site-name>
```

## What It Does

1. Runs `bun create cloudflare@latest` with TanStack Start
2. Removes standalone `node_modules`
3. Transforms `package.json` (namespace, workspace deps, SVP versions)
4. Assigns port via T9 (first 4 letters → keypad digits)
5. Runs `bun install` from root

## Port Assignment

| Letters | Digits |
|---------|--------|
| ABC | 2 |
| DEF | 3 |
| GHI | 4 |
| JKL | 5 |
| MNO | 6 |
| PQRS | 7 |
| TUV | 8 |
| WXYZ | 9 |

Example: `mybrand` → `mybr` → `6927`
