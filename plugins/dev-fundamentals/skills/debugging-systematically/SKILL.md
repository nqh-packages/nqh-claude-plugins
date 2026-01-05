---
name: debugging-systematically
description: MANDATORY framework for ALL bug fixes. Enforces 4-phase scientific process with CONFIDENCE CHECKPOINT. Presents root cause(s) with confidence scores, lets USER PICK which to fix, then suggests saving pattern to `/rules create`. Phases - Investigation/Wolf Fence, Pattern Analysis/Rubber Ducking, Hypothesis/5 Whys, Confidence Report (USER CHOICE), Implementation.
triggers:
  - plan_mode: true
---

# Systematic Debugging

## Activation Protocol

**MANDATORY:** When this skill is invoked, IMMEDIATELY call `EnterPlanMode` before any investigation.

### Plan Mode Scope

In plan mode, create an investigation plan that:
1. Documents the reported symptoms and error context
2. Identifies which files/components to investigate (Wolf Fence targets)
3. Lists evidence to gather (logs, stack traces, environment checks)
4. Plans reproduction steps
5. Gets user approval before executing Phase 1

**Exit plan mode only after user approves the investigation approach.**

---

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST

If you haven't completed Phase 1 & 2, you cannot propose fixes.

## When to Use

Use for ANY technical issue:

- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**

- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Investigation & Isolation (The "Wolf Fence")

**Goal:** Isolate the exact location of the failure.

1.  **Read Error Messages & Stack Traces**
    - Don't skim. Read line-by-line.
    - Note specific error codes, file paths, and line numbers.
    - **Self-Correction:** Do not assume the error message describes the _root_ cause, only the _symptom_.

2.  **Reproduce & Minimize (Delta Debugging)**
    - Can you trigger it reliably?
    - **Minimize inputs:** Remove one variable/line at a time until the bug disappears. The last thing removed is the trigger.
    - If not reproducible → Add logging, don't guess.

3.  **Wolf Fence Algorithm (Binary Search)**
    - If the error location is unknown (e.g., silent failure or wrong output), do NOT read the whole file.
    - **Divide and Conquer:**
      - "Fence" the code in half (via logs or breakpoints).
      - Is the wolf (bug) on the left or right?
      - Repeat until the specific offending line/function is isolated.

4.  **Gather Evidence (Multi-Component)**
    - For microservices/pipelines: Trace the data.
    - Log INPUT and OUTPUT at every component boundary.
    - **Verify Environment:** `env`, `permissions`, `versions`.

### Phase 2: Pattern Analysis & "Rubber Ducking"

**Goal:** Prove you understand the broken logic before fixing it.

1.  **Rubber Ducking (Explain it to the User)**
    - **MANDATORY STEP:** Explain the suspected broken code block line-by-line to the user.
    - "Here is my understanding of what this block does..."
    - If you cannot explain _exactly_ how the state changes on a specific line, you do not understand the bug.

2.  **Find Working Examples**
    - Where does similar code work correctly?
    - Diff the working vs. broken versions.

3.  **Identify Differences**
    - List every difference (versions, call order, data types).
    - Don't assume "that small change can't matter."

### Phase 3: Hypothesis & The "5 Whys"

**Goal:** Identify the ROOT cause, not just the proximate cause.

1.  **Form Single Hypothesis**
    - State: "I think X is the cause because Y."

2.  **The 5 Whys (Root Cause Depth)**
    - Ask "Why?" 5 times to get past the symptom.
    - _Example:_
      - 1. Why did it crash? -> Variable was null.
      - 2. Why was it null? -> API returned 404.
      - 3. Why did API return 404? -> User ID was truncated.
      - 4. Why was ID truncated? -> DB column is too short. (ROOT CAUSE)
    - **Fixing the null check (Level 1) is a failure. You must fix the DB column (Level 4).**

3.  **Test Minimally**
    - Prove the hypothesis _without_ fixing it yet (e.g., hardcode the correct value to see if it passes).

### Phase 3.5: Root Cause Confidence Report (MANDATORY CHECKPOINT)

**Goal:** Research best practices, then present findings to user BEFORE any fix attempt.

**STOP HERE. Do NOT proceed to Phase 4 until user approves.**

1.  **Research Best Practices First**

    Before generating the confidence report, MUST research:

    - **Web Search**: Search for latest best practices for this bug type/pattern
    - **Documentation**: Check official docs for the technology involved (use context7 MCP if available)
    - **Known Issues**: Search for similar bugs in issue trackers, Stack Overflow
    - **Security Implications**: Check if this bug type has security considerations (OWASP, CVE databases)

    ```
    🔍 Researching: [bug pattern/technology]
    - Searched: [what you searched for]
    - Found: [key findings that inform the fix approach]
    - Best practice: [recommended approach from authoritative sources]
    ```

2.  **Generate Confidence Report**

    Present each identified root cause with (informed by research):

    | Root Cause | Confidence | Evidence | Risk Level | Fix Complexity |
    |------------|------------|----------|------------|----------------|
    | [Cause A]  | HIGH (90%) | [Evidence gathered] | [Impact if wrong] | [Effort estimate] |
    | [Cause B]  | MEDIUM (60%) | [Evidence gathered] | [Impact if wrong] | [Effort estimate] |
    | [Cause C]  | LOW (30%) | [Evidence gathered] | [Impact if wrong] | [Effort estimate] |

    **Confidence Levels:**
    - **HIGH (80-100%)**: Reproduced, isolated, 5-Whys complete, minimal hypothesis tested, best practice confirmed
    - **MEDIUM (50-79%)**: Strong evidence but some gaps, not fully isolated, or no best practice found
    - **LOW (<50%)**: Educated guess, limited evidence, needs more investigation

3.  **Present Options to User**

    ```
    ## Root Cause Analysis Complete

    I've identified [N] potential root cause(s):

    **Option A: [Cause Name]** (Confidence: X%)
    - Evidence: [what I found]
    - Fix approach: [how to fix]
    - Risk: [what could go wrong]

    **Option B: [Cause Name]** (Confidence: Y%)
    - Evidence: [what I found]
    - Fix approach: [how to fix]
    - Risk: [what could go wrong]

    **Recommendation:** Option [X] because [reason]

    Which option should I pursue? (A/B/investigate more)
    ```

4.  **Wait for User Decision**
    - User selects option → Proceed to Phase 4
    - User requests more investigation → Return to Phase 1 or 2
    - User provides new info → Update confidence report

5.  **Suggest Memory Addition**

    After presenting the report, suggest:

    ```
    💡 **Save to Project Memory?**

    This debugging pattern could help future sessions:
    - Bug pattern: [description]
    - Root cause type: [category]
    - Solution approach: [summary]

    Run `/rules create` to add this to `.claude/rules/` for future reference.
    ```

### Phase 4: Implementation & Regression

**Goal:** Fix the root cause without breaking anything else.

1.  **Create Failing Test Case**
    - **REQUIRED SUB-SKILL:** Use `superpowers:test-driven-development`.
    - Create a test that fails _only_ because of this bug.

2.  **Implement Single Fix**
    - Address the Level 4/5 Root Cause.
    - **AI Guardrail:** Verify all imported libraries actually exist (no hallucinations).

3.  **Verify & Regression Check**
    - Does the test pass?
    - **Did you break old functionality?** (Run related tests).

4.  **Architectural Stop-Loss**
    - If Fix #1 fails, try Fix #2.
    - **If Fix #2 fails: STOP.**
    - Do not attempt Fix #3. You are "thrashing."
    - Return to Phase 1. Your hypothesis is wrong.

## Red Flags - STOP and Follow Process

If you catch yourself thinking:

- "Quick fix for now, investigate later"
- "I'll just add a null check" (Symptom fix)
- "It's probably X, let me try changing it"
- "I don't need to reproduce it, I see the bug"
- **"One more fix attempt" (when already tried 2)**

**ALL of these mean: STOP. Return to Phase 1.**

## Quick Reference

| Phase                    | Technique                  | Goal                              |
| ------------------------ | -------------------------- | --------------------------------- |
| **1. Investigation**     | Wolf Fence / Binary Search | Find the exact line/component     |
| **2. Analysis**          | Rubber Ducking             | Verify understanding of logic     |
| **3. Hypothesis**        | 5 Whys                     | Find the _Root_ Cause             |
| **3.5a. RESEARCH**       | Web/Docs/Issues Search     | Find best practices for fix       |
| **3.5b. CHECKPOINT**     | Confidence Report          | **USER PICKS option before fix**  |
| **4. Implement**         | TDD + Regression           | Fix it permanently                |
| **Post-fix**             | Memory Suggestion          | Save pattern via `/rules create`  |
