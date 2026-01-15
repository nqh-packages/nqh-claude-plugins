---
paths: **/wrangler.{jsonc,toml,json}
---

# Wrangler Secrets Management

## Rule

NEVER put secrets in `wrangler.jsonc` or `wrangler.toml`. Use `wrangler secret put` instead.

## Forbidden

```jsonc
// wrangler.jsonc - NEVER DO THIS
"vars": {
  "PAYLOAD_SECRET": "actual-secret-value",
  "API_KEY": "re_xxx..."
}
```

## Correct Approach

| Environment | Method |
|-------------|--------|
| Local dev | `.env` file (gitignored) |
| Production | `wrangler secret put KEY --env production` |

## Commands

```bash
# List secrets (names only)
wrangler secret list --env production

# Set secret (interactive prompt)
wrangler secret put PAYLOAD_SECRET --env production

# Delete secret
wrangler secret delete API_KEY --env production
```

## Reference

[CF Docs](https://developers.cloudflare.com/workers/configuration/secrets/)
