# dev-fundamentals-typescript

TypeScript/Node.js testing specialist with Vitest and MSW.

<!-- VISUAL -->
```
dev-fundamentals-typescript (addon)
└── agents/
    └── typescript-test-pro    # Expert TypeScript test writer
```
<!-- /VISUAL -->

**Requirements**: `dev-fundamentals@nqh-plugins` (core plugin with shared skills)

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

## Add Plugin

```
/plugin install dev-fundamentals@nqh-plugins
/plugin install dev-fundamentals-typescript@nqh-plugins
```

## Agent

**typescript-test-pro** - Expert TypeScript/Node.js test writer with LLM-optimized JSON output.

Features:
- Vitest 4.0+ (ESM-native)
- MSW 2.0+ for API mocking
- Type-safe mocking patterns (`vi.fn<Args, Return>()`)
- Specialized patterns for:
  - Cloudflare Workers
  - SQLite databases
  - CLI tools
  - Generics and schemas (Zod/Valibot)
- 85%+ coverage targets

Uses skills from core: `tdd-methodology`, `testing-systematically`, `determining-test-truth`, `waiting-for-conditions`, `writing-typescript-logs`

---

**v0.1.0** · Initial release
