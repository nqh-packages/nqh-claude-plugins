---
name: writing-typescript-logs
description: Implements structured logging with @nqh/logger (Pino) for TypeScript/Node.js apps. Use when adding logging to apps/packages, migrating console.log statements, or implementing correlation IDs, masking, sampling, or canonical log lines.
subagent-compatible: true
---

# Structured Logging (TypeScript)

Pino-based logging via `@nqh/logger` package.

## Triggers

| Use | Skip |
|-----|------|
| TypeScript/Node.js apps | Python (writing-python-logs) |
| API routes, auth, payments | Shell (writing-shell-logs) |
| Multiple `console.log` statements | Browser-only code, simple utils |

## Quick Start

```typescript
import { createLogger, maskSensitiveData } from '@nqh/logger';

const logger = createLogger({ name: 'my-service' });

logger.info({ userId: '123' }, 'User authenticated');
logger.error({ err: new Error('timeout') }, 'DB query failed');

// Mask before logging user input
const masked = maskSensitiveData(credentials);
logger.debug(masked, 'Login attempt');
```

**Output**: `{"level":30,"time":1732053845123,"name":"my-service","userId":"123","msg":"User authenticated"}`

## Core Functions

| Function | Usage |
|----------|-------|
| `createLogger({ name })` | Base logger (env-aware) |
| `maskSensitiveData(data)` | Auto-redact secrets |
| `withCorrelationId` | Router middleware |
| `createCanonicalLogger(req)` | Per-request summary |
| `createSampledLogger(base, opts)` | Reduce volume |

## Log Levels

| Level | Numeric | Default |
|-------|---------|---------|
| trace | 10 | Never |
| debug | 20 | DEV |
| info | 30 | - |
| warn | 40 | PROD |
| error | 50 | Yes |
| fatal | 60 | Yes |

**Env**: `LOG_LEVEL=debug bun run dev`

## Patterns

### Authentication with Masking

```typescript
const masked = maskSensitiveData(credentials);
logger.debug(masked, 'Login attempt');
// password, apiKey, token → [REDACTED]
// email → u***@domain.com
// credit card → 4532****5678
```

### Canonical Logs (API Routes)

```typescript
const log = createCanonicalLogger(request);
log.success({ count: users.length, db_queries: 1 });
// One log per request with duration + status
```

### Sampling (High-Volume)

```typescript
const logger = createSampledLogger(baseLogger, { sampleRate: 10, alwaysLog: ['error', 'warn'] }, 'deterministic');
logger.info('Health check'); // 10% logged
logger.error('Failed'); // Always logged
```

### Correlation IDs

```typescript
// router.tsx
import { withCorrelationId } from '@nqh/logger';
export const router = createRouter({ beforeLoad: withCorrelationId });
```

## Error Message Quality (MANDATORY)

```typescript
// BAD
logger.error({ err }, 'Failed');

// GOOD
logger.error({
  code: 'DB_TIMEOUT_001',
  err,
  operation: 'findUser',
  action: 'Check DB connection or retry',
  timeout: 5000
}, 'DB query failed');
```

**Required**: `code` (e.g., `DOMAIN_ISSUE_001`) + `action` field + context

## Auto-Masked Fields

| Pattern | Result |
|---------|--------|
| password, apiKey, token, secret, auth | `[REDACTED]` |
| Email | `u***@domain.com` |
| Credit card (Luhn-valid) | `4532****5678` |
| Phone (10+ digits) | `[REDACTED]` |

## Workers Limitations

| Feature | Workers Support |
|---------|----------------|
| Basic logging | Yes (console fallback) |
| Async transports | No |
| pino-pretty | No (Node.js only) |

## Migration

| Before | After |
|--------|-------|
| `console.log(msg)` | `logger.info({ data }, msg)` |
| `console.error(err)` | `logger.error({ err }, msg)` |
| `console.log('User ${id}')` | `logger.info({ userId }, 'User action')` |

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Logs not appearing | Check `LOG_LEVEL`, `NODE_ENV` |
| Pretty in production | Set `NODE_ENV=production` |
| Missing correlation IDs | Add `withCorrelationId` to router |
| Sensitive data leaked | Use `maskSensitiveData()` |
| Stack traces missing | Pass error as `{ err }` |
