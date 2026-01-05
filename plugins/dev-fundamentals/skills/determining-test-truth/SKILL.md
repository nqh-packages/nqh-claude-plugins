---
name: determining-test-truth
description: Decision framework for determining whether a failing test indicates buggy code or an incorrect test (the Oracle Problem). Use when tests fail unexpectedly, when AI agents modify tests, or before any test assertion changes. Prevents the dangerous anti-pattern of fixing tests to match buggy code.
---

# Determining Test Truth

## Purpose

When a test fails, determine whether the **code is wrong** (fix the code) or the **test is wrong** (fix the test). This skill prevents AI agents from the dangerous anti-pattern of modifying tests to match buggy implementations.

## The Core Problem

| Approach | What Happens | Risk |
|----------|--------------|------|
| Tests verify code (correct) | Test fails → Code is wrong → Fix the code | None |
| Tests match code (dangerous) | Test fails → "Fix" the test → Bug stays hidden | HIGH |

**Default assumption**: Code is wrong, not the test. Burden of proof is on proving the test is incorrect.

## WHEN TO USE

| Trigger | Action |
|---------|--------|
| Test fails unexpectedly | Activate BEFORE modifying anything |
| AI agent about to modify test assertions | MANDATORY activation |
| User mentions "fix the test" | Pause and analyze |
| Test-pro agents (*-test-pro) working | Background guidance |
| Reviewing AI-generated test changes | Validation checkpoint |

---

## Phase 0: Trigger Detection

```
START: Test Failure or Test Modification
│
├─→ Test was passing before code change?
│   └─→ YES → HIGH probability: CODE is wrong
│
├─→ AI agent about to modify test assertion?
│   └─→ YES → MANDATORY: Run full decision algorithm
│
├─→ User says "fix the test to pass"?
│   └─→ YES → WARNING: Potential anti-pattern. Ask clarifying questions
│
└─→ Writing new tests (TDD)?
    └─→ YES → Test IS the specification. Code must satisfy it.
```

---

## Phase 1: Identify Oracle Type

**The Oracle Problem**: How do we know what the correct output should be?

```
What type of oracle exists for this test?
│
├─→ TDD (Test-First)
│   ├── Test was written BEFORE implementation
│   ├── Test defines the expected behavior
│   └── VERDICT: Test is truth. Fix the CODE.
│
├─→ Specification Oracle
│   ├── Formal requirements document exists
│   ├── Contract (OpenAPI, Pact) defines behavior
│   └── VERDICT: Spec is truth. Compare both test and code to spec.
│
├─→ Contract Oracle (External)
│   ├── Pact Broker / OpenAPI spec exists
│   ├── Contract stored externally (immutable)
│   └── VERDICT: Contract is truth. Neither test nor code can override.
│
├─→ Property Oracle
│   ├── Invariants defined (property-based tests)
│   ├── Properties like: idempotent, commutative, round-trip
│   └─→ VERDICT: Properties are truth. Both test and code must satisfy.
│
├─→ Reference Implementation
│   ├── Trusted "slow but correct" version exists
│   └── VERDICT: Reference is truth (with caution).
│
├─→ Human Oracle (Legacy/Unclear)
│   ├── No specification exists
│   ├── Behavior was "working in production"
│   └── VERDICT: Production behavior is presumed correct. FLAG UNCERTAINTY.
│
└─→ No Oracle (Ambiguous)
    ├── Cannot determine correct behavior
    └── VERDICT: STOP. Cannot proceed. Ask user for clarification.
```

---

## Phase 2: Apply Decision Algorithm

```
TEST FAILS - DECISION ALGORITHM
│
├─→ Step 1: Was test passing before?
│   ├── YES + Code changed → 95% CODE is wrong
│   ├── YES + Code unchanged → Investigate environment
│   └── NO (new test) → Test IS the spec
│
├─→ Step 2: Does test match requirements?
│   ├── YES → Test is correct. Fix code.
│   ├── NO → Test may be wrong. Verify requirement.
│   └── UNCLEAR → Ask user before proceeding
│
├─→ Step 3: Is test testing BEHAVIOR or IMPLEMENTATION?
│   ├── BEHAVIOR (what user sees) → Test is likely correct
│   └── IMPLEMENTATION (internal state) → Test may be brittle
│
├─→ Step 4: Run mutation testing (if available)
│   ├── High mutation score (>80%) → Test is meaningful
│   ├── Low score (<50%) → Test may be weak/tautological
│   └── Use: `bun run test:mutation` or `stryker run`
│
└─→ Step 5: Final verdict
    ├── HIGH confidence code is wrong → Fix code
    ├── HIGH confidence test is wrong → Fix test (with justification)
    ├── MEDIUM confidence → Ask user
    └── LOW confidence → STOP. Gather more information.
```

---

## Phase 3: Safeguards Before Modifying Tests

**MANDATORY checklist before ANY test modification:**

### Pre-Modification Checks

- [ ] **Oracle identified**: What is the source of truth?
- [ ] **Requirement confirmed**: Does a spec/contract/TDD test define expected behavior?
- [ ] **History checked**: Was this test passing before? When did it start failing?
- [ ] **Code investigated**: Have you examined the code for bugs FIRST?
- [ ] **User consulted**: If uncertain, have you asked the user?

### Red Flags (STOP if any are true)

| Red Flag | Why It's Dangerous | Action |
|----------|-------------------|--------|
| Test was passing before code change | Code likely introduced bug | Fix the code, not the test |
| Changing assertion to match current output | Circular validation | FORBIDDEN without justification |
| No requirement changed | Test still reflects correct behavior | Fix the code |
| Making test less strict | Hiding potential bugs | Investigate code first |
| "Just make it pass" mentality | Anti-pattern | STOP and analyze |

### Allowed Test Modifications

| Situation | Action | Justification Required |
|-----------|--------|----------------------|
| Requirement genuinely changed | Update test | Document requirement change |
| Test was incorrect from start | Fix test | Cite correct requirement |
| Test is flaky/non-deterministic | Stabilize test | Document timing issue |
| Test is tautological | Rewrite test | Cite test smell |
| Test duplicates another | Remove test | Reference duplicate |

---

## Phase 4: Validation Techniques

### Mutation Testing (Primary Validation)

**Purpose**: Verify tests catch real bugs, not just execute code.

```bash
# JavaScript/TypeScript (Stryker)
bun run test:mutation

# Interpret results:
# - Score >80%: Tests are meaningful
# - Score <50%: Tests may be weak/tautological
# - Surviving mutants: Show untested logic
```

| Mutation Score | Interpretation | Action |
|----------------|----------------|--------|
| 90-100% | Excellent tests | Trust test verdicts |
| 80-89% | Good tests | Minor gaps acceptable |
| 50-79% | Weak tests | Strengthen before trusting |
| <50% | Tests unreliable | Cannot trust test as oracle |

### Contract Verification (External Truth)

If contracts exist (Pact, OpenAPI):

```bash
# Pact verification
pact-broker can-i-deploy --pacticipant MyService

# OpenAPI validation
dredd api.yaml http://localhost:3000
```

**Key insight**: Contracts are external to both code and tests. They cannot be "fixed" by either side.

### Property-Based Testing (Invariant Validation)

Properties define what MUST be true for ALL inputs:

```typescript
// Example: Properties that can't be gamed
fc.assert(fc.property(fc.array(fc.integer()), (arr) => {
  const sorted = sort([...arr]);
  // Property: sorted array is idempotent
  return deepEqual(sorted, sort([...sorted]));
}));
```

---

## AI Agent Guidelines

### MANDATORY Rules for Test-Writing Agents

1. **NEVER modify test assertions to match current code behavior**
   - If test fails, investigate CODE first
   - Assume test is correct until proven otherwise

2. **FLAG uncertainty explicitly**
   ```
   ⚠️ UNCERTAIN: Cannot determine if test or code is correct
   Evidence: [list observations]
   Recommendation: [ask user / gather more info]
   ```

3. **Require justification for test changes**
   - Every test modification needs documented reason
   - "Making test pass" is NOT a valid reason

4. **Validate AI test changes**
   - Run mutation testing after AI modifies tests
   - Score <80% = AI fix may be incorrect

### Circular Validation Anti-Pattern

```
❌ DANGEROUS PATTERN:
1. Code has bug
2. Test fails
3. AI "fixes" test to match buggy code
4. Test passes
5. Bug hidden in production

✅ CORRECT PATTERN:
1. Code has bug
2. Test fails
3. AI investigates code
4. AI fixes code
5. Test passes (validates fix)
```

---

## Validation Checklist

Before concluding test vs code decision:

- [ ] Oracle type identified and documented
- [ ] Test history checked (was it passing before?)
- [ ] Requirement/specification consulted
- [ ] Code investigated for bugs FIRST
- [ ] If modifying test: justification documented
- [ ] If uncertain: user consulted
- [ ] Mutation testing run (if available)
- [ ] No red flags triggered

---

## Quick Reference: Decision Matrix

| Scenario | Test Age | Code Changed | Oracle | Verdict |
|----------|----------|--------------|--------|---------|
| TDD test fails | Written first | Yes | Test | Fix CODE |
| Legacy test fails | Old | Yes | Production | Likely fix CODE |
| New test fails | Just written | No | Test | Fix CODE |
| Test after refactor | Old | Yes (refactor) | Test | Fix CODE (regression) |
| Requirement changed | Old | No | New spec | Update TEST |
| Test was always wrong | Old | No | Spec | Fix TEST |
| Unclear situation | Any | Any | None | ASK USER |

---

## SELF-DIAGNOSIS

**Run when skill produces incorrect verdicts**

### Environment Checks
- [ ] Can access test history (git log)?
- [ ] Can access requirements/specs?
- [ ] Mutation testing available?
- [ ] Contract definitions accessible?

### Failure Analysis
- [ ] Is oracle type being identified correctly?
- [ ] Are red flags being detected?
- [ ] Is AI overriding safeguards?
- [ ] Are users being consulted when uncertain?

---

## SELF-IMPROVEMENT

**LLM-driven**: Claude reads `data/feedback.json` at session start.

### Feedback Schema

```json
{
  "sessions": [
    {
      "session_id": "uuid",
      "timestamp": "ISO8601",
      "oracle_type": "tdd|spec|contract|property|reference|human|none",
      "initial_verdict": "fix_code|fix_test|uncertain",
      "final_outcome": "code_fixed|test_fixed|both_fixed|user_decided",
      "was_correct": true|false,
      "red_flags_triggered": ["flag1", "flag2"],
      "user_satisfaction": "accepted|revised|rejected"
    }
  ]
}
```

### Session Start Intelligence

1. Read `data/feedback.json`
2. IF sessions.length > 0:
   a. Calculate verdict accuracy from last 10 sessions
   b. Identify oracle types with high error rates
   c. Surface patterns as "LEARNED INSIGHTS"
3. ELSE:
   a. Proceed with default algorithm
   b. Note: "First session - no historical data"

### Learning Triggers

| Trigger | Action |
|---------|--------|
| "fix_test" verdicts rejected >40% | Tighten code-first bias |
| Oracle type "none" >30% | Improve oracle detection |
| Red flags ignored →wrong outcome | Strengthen red flag warnings |
| User overrides >50% | Adjust confidence thresholds |

---

## FEEDBACK INTERFACE

**After each session, Claude appends to `data/feedback.json`:**

```json
{
  "session_id": "[generate UUID]",
  "timestamp": "[ISO8601]",
  "oracle_type": "[identified type]",
  "initial_verdict": "[recommendation]",
  "final_outcome": "[what actually happened]",
  "was_correct": [boolean],
  "red_flags_triggered": [],
  "user_satisfaction": "[accepted|revised|rejected]"
}
```

---

## Sources (Research Base)

This skill is built on research from 8 parallel agents covering:

- **TDD Principles**: Martin Fowler, Kent Beck, Testing Trophy (Kent C. Dodds)
- **Oracle Problem**: IEEE Survey (Barr, Harman, McMinn et al.), Cem Kaner
- **Mutation Testing**: Stryker, pitest, Trail of Bits security research
- **Contract Testing**: Pact, OpenAPI, PactFlow bi-directional contracts
- **Property-Based Testing**: fast-check, Hypothesis, QuickCheck patterns
- **AI Testing Risks**: Meta research (93.7% incorrect oracles), GitClear study
- **Test Smells**: xUnit Patterns, testsmells.org catalog
- **Approval Testing**: ApprovalTests, golden master patterns
