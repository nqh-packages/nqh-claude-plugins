---
name: tdd-methodology
description: Platform-agnostic TDD discipline for test-writing agents. RED-GREEN-REFACTOR enforcement, ZOMBIES case analysis, coverage gates, and anti-pattern detection. Used by react-test-pro, react-native-test-pro, swift-test-pro agents.
version: 1.0.0
author: nqh
triggers:
  - tdd
  - red green refactor
  - test first
  - failing test
  - coverage threshold
  - test driven
---

# TDD Methodology

Platform-agnostic Test-Driven Development discipline. This skill provides the **process**; language-specific agents provide the **implementation**.

## The Iron Laws

1. **NEVER trust a test you haven't seen fail**
2. **Write test BEFORE implementation** (no exceptions)
3. **Minimal code to pass** (no future-proofing)
4. **Refactor while green** (tests are safety net)

## RED-GREEN-REFACTOR Cycle

| Phase | Action | Duration | Evidence Required |
|-------|--------|----------|-------------------|
| **RED** | Write failing test | 30s | Test output shows failure |
| **GREEN** | Minimal code to pass | 30-60s | Test output shows pass |
| **REFACTOR** | Improve code quality | 30-60s | All tests still pass |

### Phase Details

#### RED (Write Failing Test)

```
1. Write test that describes desired behavior
2. Run test → MUST FAIL
3. Verify failure message is clear and correct
4. If test passes → assumption wrong OR feature exists
```

**Evidence format**: `{file}:{line} - RED: {what fails} (expected X, got Y)`

#### GREEN (Minimal Implementation)

```
1. Write MINIMUM code to pass test
2. No extra features, no optimization
3. Run test → MUST PASS
4. Commit: "feat: {what works}"
```

**Evidence format**: `{file}:{line} - GREEN: {what passes}`

**Forbidden**: Writing logic for untested cases

#### REFACTOR (Improve While Green)

```
1. Improve code structure, naming, performance
2. Run tests after each change → MUST STAY GREEN
3. Extract duplicates, simplify logic
4. Commit: "refactor: {what improved}"
```

**Evidence format**: `{file}:{line-range} - REFACTOR: {what improved}, tests green`

## ZOMBIES Case Analysis

Before writing tests, enumerate cases using ZOMBIES:

| Case | Question | Example |
|------|----------|---------|
| **Z**ero | Empty inputs, nulls, empty collections? | `validate("")` → error |
| **O**ne | Single valid item? | `add([1])` → `[1]` |
| **M**any | Large collections, multiple events? | `add([1,2,3,4,5])` → handles |
| **B**oundary | Edges (n-1, n, n+1)? | limit=10 → test 9,10,11 |
| **I**nterface | Correct types/structures? | Returns `Result<T>` not `null` |
| **E**xceptions | Force error conditions? | Network down, DB full |
| **S**imple | Easiest path to green? | Happy path first |

## Coverage Gates

| Phase | Threshold | Critical Paths |
|-------|-----------|----------------|
| P1 (MVP) | 70% | 100% auth, 100% payments |
| P2 | 75% | 100% CMS, 90% workflows |
| P3 | 85% | 100% critical, 90% features |
| P4 | 90% | 100% all public APIs |

### Coverage Types

| Type | Measures | Target |
|------|----------|--------|
| **Statement** | Lines executed | 85% |
| **Branch** | If/else paths | 80% |
| **Function** | Functions called | 85% |
| **Mutation** | Assertions catch bugs | 80%+ |

## Anti-Patterns (STOP Immediately)

### Process Anti-Patterns

| Pattern | Why It Fails | Fix |
|---------|--------------|-----|
| **Test After** | Tests mirror implementation | Write test FIRST |
| **Skip Refactor** | Tech debt accumulates | Always refactor |
| **100% Obsession** | Shallow tests for metric | Target 80-85% |
| **Over-Mocking** | Tests break on refactor | Mock externals only |

### Test Code Anti-Patterns

| Pattern | Example | Fix |
|---------|---------|-----|
| **The Liar** | Async completes before assert | Use proper async patterns |
| **The Giant** | 50+ assertions in one test | Split into focused tests |
| **The Mockery** | 10+ mocks for one test | Rethink design |
| **The Peeping Tom** | Tests share state | Independent test data |
| **Implementation Testing** | Tests internal state | Test behavior only |

### Red Flags (Return to Phase 1)

If you think:
- "I'll write tests after the feature"
- "This edge case won't happen"
- "I'll just change the assertion to match output"
- "I need to mock 15 things"
- "It works on my machine"

## Test Organization

### File Placement

| Test Type | Location | Naming |
|-----------|----------|--------|
| Unit | Colocated | `{file}.test.{ext}` |
| Integration | `tests/integration/` | `{feature}.integration.test.{ext}` |
| E2E | `tests/e2e/` | `{flow}.spec.{ext}` |

### Test Pyramid Ratios

| Layer | Ratio | Speed | Confidence |
|-------|-------|-------|------------|
| Unit | 70% | Fast (<100ms) | Function-level |
| Integration | 20% | Medium (<5s) | Component boundaries |
| E2E | 10% | Slow (<30s) | User journeys |

## Test Doubles

| Double | Use When | Complexity |
|--------|----------|------------|
| **Stub** | Return canned data | Low |
| **Mock** | Verify interactions | Medium |
| **Fake** | Working simplified impl | Medium |
| **Spy** | Track real object calls | High |

**Rule**: Use the simplest double that solves the problem.

## Evidence-Based Completion

Every test cycle must document:

```
RED: user-service.test.ts:42 - Failing test for getUserById
     Expected: User object, Got: null

GREEN: user-service.ts:23 - Implemented getUserById
       Test passes

REFACTOR: user-service.ts:23-45 - Extracted DB query logic
          All 127 tests pass, coverage: 94%
```

## CI Integration

### Required Gates

| Gate | Enforcement |
|------|-------------|
| Tests pass | Block merge on failure |
| Coverage threshold | Block if below target |
| No skipped tests | Warn or block |
| Performance | Unit <100ms, E2E <30s |

### Post-Push

```bash
gh run view  # Verify CI passes
```

## Quick Reference

| Phase | Technique | Output |
|-------|-----------|--------|
| Before | ZOMBIES | Case enumeration |
| RED | Write failing test | Failure evidence |
| GREEN | Minimal implementation | Pass evidence |
| REFACTOR | Improve structure | Refactor evidence |
| After | Coverage check | Threshold met |

## Integration with Language Agents

This skill is used by:

- **react-test-pro**: Vitest + RTL + MSW patterns
- **react-native-test-pro**: Jest + RNTL + Detox patterns
- **swift-test-pro**: Swift Testing + ViewInspector patterns

Each agent applies this methodology with platform-specific tools.
