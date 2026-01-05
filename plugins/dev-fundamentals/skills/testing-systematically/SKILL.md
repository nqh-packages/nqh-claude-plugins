---
name: testing-systematically
description: MANDATORY framework for verifying code behavior with CONFIDENCE CHECKPOINT. Presents test strategy with risk/coverage confidence, lets USER PICK approach, then suggests saving pattern to `/rules create`. Phases - Strategy/Pyramid, Case Analysis/ZOMBIES, Risk Confidence Report (USER CHOICE), Execution/Red-Green, Refinement/F.I.R.S.T.
---

# Systematic Testing

## Overview

Writing tests *after* code often leads to testing the implementation, not the behavior. Flaky tests are worse than no tests.

**Core principle:** Verify behavior, not implementation details. A test that never fails is a hallucination.

**Violating the letter of this process guarantees regression.**

## The Iron Law

NEVER TRUST A TEST YOU HAVEN'T SEEN FAIL
If you write the test after the code is working, you must break the code to verify the test fails.

## When to Use

Use for ANY code modification:
- New features
- Bug fixes (Regression tests)
- Refactoring
- Legacy code updates

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Strategy & Scope (The Pyramid)

**Goal:** Determine the correct layer for verification.

1. **Identify the Behavior**
   - Don't test "Function X calls Function Y".
   - Test "When User does X, System results in Y".

2. **Select the Layer (The Testing Pyramid)**

| Layer | When to Use | Pros | Cons |
|-------|-------------|------|------|
| **Unit** | Default choice | Fastest, Cheapest, Isolated | May miss integration bugs |
| **Integration** | Service ↔ DB, API ↔ Service | Tests boundaries | Slower, more setup |
| **E2E** | Critical user journeys | Full system test | Slow, Brittle |

3. **Legacy Code Exception**
   - If code is untestable (tight coupling), write a **Characterization Test** (Golden Master) first.
   - Capture current behavior (even if buggy) before refactoring to make it unit-testable.

### Phase 2: Case Analysis (ZOMBIES & BICEP)

**Goal:** Enumerate *what* to test before writing code. Don't guess happy paths only.

**Use the ZOMBIES Mnemonic:**

| Case | Question | Example |
|------|----------|---------|
| **Zero** | Empty inputs, nulls, empty collections? | `add("", "")` → `""` |
| **One** | Single valid item? | `add("a")` → error (requires 2+ items) |
| **Many** | Large collections, multiple events? | `add([1,2,3,4,5])` → handles efficiently |
| **Boundary** | Edges (n-1, n, n+1)? | Limit 10 → test 9, 10, 11 |
| **Interface** | Correct types/structures? | Returns `Result<T>` not `null` |
| **Exceptions** | Force error conditions? | Network down, DB full |
| **Simple** | Easiest path to green? | Default happy path |

**Sub-Check (Right-BICEP):**
- **Right:** Are the results correct?
- **Inverse:** Can you verify by reversing (e.g., check division by multiplying)?
- **Cross-check:** Can you verify using a different method/library?

**Blind Spot Check (Reveal Unknown Unknowns)**

After ZOMBIES enumeration, ask:
- "What edge cases do experts test that laypeople miss?"
- "What do experts disagree on about testing this type of code?"
- "What good questions am I not asking about test coverage?"
- "What are open questions about testing this technology/pattern?"

If any reveal new test cases → add to ZOMBIES list.

### Phase 2.5: Risk Analysis Confidence Report (MANDATORY CHECKPOINT)

**Goal:** Research best practices, then present test strategy to user BEFORE writing tests.

**STOP HERE. Do NOT proceed to Phase 3 until user approves.**

1.  **Research Testing Best Practices First**

    Before generating the risk report, MUST research:

    - **Web Search**: Search for latest testing best practices for this component/feature type
    - **Documentation**: Check official testing docs for the framework (use context7 MCP if available)
    - **Test Patterns**: Search for established test patterns (Testing Library, Playwright, Vitest best practices)
    - **Coverage Standards**: Check industry standards for this type of code (API, UI, utility, etc.)

    ```
    🔍 Researching: [component type/testing context]
    - Searched: [what you searched for]
    - Found: [key findings that inform test strategy]
    - Best practice: [recommended testing approach from authoritative sources]
    ```

2.  **Generate Risk/Coverage Report**

    Present each identified risk/behavior to test with (informed by research):

    | Behavior/Risk | Confidence | Coverage Strategy | Priority | Complexity |
    |---------------|------------|-------------------|----------|------------|
    | [Behavior A]  | HIGH (95%) | [Test approach] | CRITICAL | [Effort] |
    | [Behavior B]  | MEDIUM (70%) | [Test approach] | HIGH | [Effort] |
    | [Edge Case C] | LOW (40%) | [Test approach] | MEDIUM | [Effort] |

    **Confidence Levels:**
    - **HIGH (80-100%)**: Clear behavior, ZOMBIES complete, boundary cases identified, best practice confirmed
    - **MEDIUM (50-79%)**: Main paths clear but edge cases uncertain, or no best practice found
    - **LOW (<50%)**: Behavior unclear, needs clarification before testing

3.  **Present Test Strategy Options to User**

    ```
    ## Test Strategy Analysis Complete

    I've identified [N] behaviors/risks requiring tests:

    **Option A: Comprehensive** (Confidence: X%)
    - Tests: [list of test cases]
    - Coverage: [what's covered]
    - Effort: [time/complexity estimate]
    - Risk: [what might be missed]

    **Option B: Critical Path Only** (Confidence: Y%)
    - Tests: [list of test cases]
    - Coverage: [what's covered]
    - Effort: [time/complexity estimate]
    - Risk: [what might be missed]

    **Option C: TDD Minimal** (Confidence: Z%)
    - Tests: [list of test cases]
    - Coverage: [what's covered]
    - Effort: [time/complexity estimate]
    - Risk: [what might be missed]

    **Recommendation:** Option [X] because [reason]

    Which test strategy should I pursue? (A/B/C/customize)
    ```

4.  **Wait for User Decision**
    - User selects option → Proceed to Phase 3
    - User requests clarification → Explain specific test cases
    - User customizes → Adjust test strategy accordingly

5.  **Suggest Memory Addition**

    After presenting the report, suggest:

    ```
    💡 **Save Test Pattern to Project Memory?**

    This testing pattern could help future sessions:
    - Component type: [e.g., API endpoint, React component, utility]
    - Test strategy: [e.g., ZOMBIES boundary focus, integration-first]
    - Common edge cases: [reusable patterns]

    Run `/rules create` to add this to `.claude/rules/` for future reference.
    ```

### Phase 3: Execution (Red - Green)

**Goal:** Write the test and code in the correct order.

1. **Red (Write the Failing Test)**
   - Write the test *before* the implementation.
   - **Run it.** It MUST fail.
   - If it passes, your assumption is wrong, or the feature exists.
   - *Check:* Does the failure message clearly explain *why* it failed?

2. **Green (Make it Pass)**
   - Write the *minimum* amount of code to pass the test.
   - Do not "future-proof" or add extra features yet.
   - **Sin:** Writing logic for cases you haven't written tests for yet.

### Phase 4: Refinement (Refactor & F.I.R.S.T.)

**Goal:** Ensure tests are maintainable assets, not liabilities.

1. **Refactor Code AND Tests**
   - Now that it's green, clean up the implementation.
   - **Crucial:** Test code is production code. Remove duplication in tests.

2. **Apply F.I.R.S.T. Principles:**

| Principle | What to Check | Example |
|-----------|---------------|---------|
| **Fast** | <100ms per test | No network calls, slow DB queries |
| **Independent** | No execution order dependency | Each test sets up its own data |
| **Repeatable** | Same result every time | Freeze time, seed randomness |
| **Self-Validating** | Pass/Fail without manual inspection | Assert output, don't log for review |
| **Timely** | Written *with* or *before* code | No "I'll test it later" |

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "I'll write the tests after I finish the feature"
- "I don't need to test this edge case, it won't happen"
- "The test failed, so I'll just change the assertion to match the output"
- "I need to mock 15 different objects to test this function" (Architecture smell)
- "It works on my machine"

**ALL of these mean: STOP. Return to Phase 1.**

## Quick Reference

| Phase | Technique | Goal |
|-------|-----------|------|
| **1. Strategy** | Pyramid / Characterization | Pick the right layer |
| **2. Analysis** | ZOMBIES / BICEP | Enumerate edge cases |
| **2.5a. RESEARCH** | Web/Docs/Patterns Search | Find testing best practices |
| **2.5b. CHECKPOINT** | Risk Confidence Report | **USER PICKS test strategy** |
| **3. Execution** | Red-Green | Prove failure first |
| **4. Refinement** | F.I.R.S.T. | Ensure reliability |
| **Post-test** | Memory Suggestion | Save pattern via `/rules create` |

## Resources

This skill includes example resource directories:

### scripts/
Placeholder for test utilities and helpers that can be executed without loading into context.

### references/
Placeholder for detailed testing guides, framework documentation, or comprehensive test patterns that should inform Claude's process.

### assets/
Placeholder for test templates, boilerplate test files, or example fixtures meant to be copied or used in test output.