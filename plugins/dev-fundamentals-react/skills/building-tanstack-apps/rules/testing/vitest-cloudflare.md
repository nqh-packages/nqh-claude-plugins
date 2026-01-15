---
paths: **/__tests__/**/*.test.ts, **/vitest.config.*, **/vitest.setup.*
---

# Vitest Testing for Cloudflare Workers

## Rule

CF Workers tests MUST mock `getCloudflareContext` and configure mock isolation.

## Mock Isolation (REQUIRED)

```typescript
// vitest.config.mts
export default defineConfig({
  test: {
    mockReset: true,
    clearMocks: true,
    restoreMocks: true,
    fileParallelism: false,
  },
})

// vitest.setup.ts
beforeEach(() => {
  vi.resetModules()
})
```

## getCloudflareContext Mock Pattern

```typescript
import { getCloudflareContext } from '@opennextjs/cloudflare'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import { myEndpoint } from '@/endpoints/my-endpoint'

vi.mock('@opennextjs/cloudflare', () => ({
  getCloudflareContext: vi.fn(),
}))

const mockGetCloudflareContext = getCloudflareContext as ReturnType<typeof vi.fn>
const mockAI = { run: vi.fn() }
const mockVectorize = { query: vi.fn() }
const mockCacheKV = { get: vi.fn(), put: vi.fn() }

beforeEach(() => {
  vi.clearAllMocks()
  mockGetCloudflareContext.mockResolvedValue({
    env: { AI: mockAI, VECTORIZE: mockVectorize, CACHE_KV: mockCacheKV },
  })
})
```

## Examples

| ❌ Wrong | ✅ Right |
|----------|----------|
| Import after `vi.mock()` | All imports above `vi.mock()` |
| No `fileParallelism: false` | Mock isolation configured |
| Direct `getCloudflareContext` call | Mocked with `vi.fn()` |

## Anti-Spillover Pattern

```typescript
// When another test mocks your module
let mergeResults: typeof import('@/lib/rrf').mergeResults

beforeAll(async () => {
  const actual = await vi.importActual<typeof import('@/lib/rrf')>('@/lib/rrf')
  mergeResults = actual.mergeResults
})
```

## Evidence

- `vitest.config.mts:14-21`
- `vitest.setup.ts:1-16`
- `author-expertise.test.ts:6-14`
