---
name: writing-markdown
description: >
  MANDATORY for ALL markdown documentation (skills, specs, patterns, technical docs).
  Enforces technical minimalism - tables over prose, maximum information density, zero fluff.
  PROACTIVELY auto-invoke when: writing/editing SKILL.md, pattern files, spec documents,
  or any technical documentation. Blocking by default with exemption list (README.md, tutorials,
  user-facing guides for non-technical audience).
---

# Markdown Writer

## Quick Reference

**Use this table for every writing decision**:

| Question | Answer | Action |
|----------|--------|--------|
| Comparison/list of facts? | Table | Convert prose → table |
| How-to explanation? | Code block | Show don't tell |
| Section >200 words? | Too long | Split or use pattern file |
| Prose >30% of doc? | Too much | Convert to structure |
| Preamble detected? ("In this...", "Let me...") | Kill it | Delete intro paragraph |
| README/tutorial/user guide? | Exempt | Use traditional style |

## Core Principle

**Maximum signal-to-noise ratio**: Tables > prose, code > explanation, structure > narrative.

**Kill on sight**: Preambles, hedge words without justification, repeated transitions, summary sections that repeat content.

## When to Use

**User requests**:
- Writing skills (SKILL.md, pattern files)
- Creating specs or design docs
- Technical guides or references
- Refactoring verbose documentation

**Auto-invoke when**:
- Creating/editing SKILL.md files
- Writing files in patterns/ directories
- Creating spec documents in specs/
- User mentions "concise", "minimal", "reference-style"

**Exemptions** (traditional docs allowed):
- README.md files
- Tutorial content (explicit learning paths)
- User-facing guides (non-technical audience)

## Transformation Patterns

| Input Pattern | Output Pattern | Token Savings |
|---------------|----------------|---------------|
| Prose explanations of events/features | Comparison table | 75% |
| "First install X. Then configure Y..." | Code blocks with headers | 60% |
| List of features with explanations | Feature comparison table | 65% |
| Section intros ("In this section...") | Delete entirely | 100% |
| Vague headers ("Usage", "Examples") | Complete thoughts ("Workflow: Creating Hooks") | 0% (clarity gain) |
| Long explanations (>200 lines) | Progressive disclosure (core + pattern files) | Context load |

## Complete Example: Before → After

```markdown
## Understanding Hook Events

In this section, we'll explore the different hook events. PreToolUse runs
before tool execution. It can block tools using exit code 2, and it can also
modify tool inputs. PostToolUse runs after tools execute, and while it can
block (with exit code 2), the tool has already run so blocking shows an error
to Claude but doesn't prevent execution.
```

**After** (concise, 24 tokens):
```markdown
## Hook Events

| Event | When | Can Block | Can Modify |
|-------|------|-----------|------------|
| PreToolUse | Before execution | ✅ Stop execution | ✅ Change inputs |
| PostToolUse | After execution | ⚠️ Too late | ❌ Read-only |
```

**Result**: 74 tokens saved (75% reduction), clarity increased.

## Workflow

1. **Identify document type** (skill/spec/guide/reference)

2. **Choose template**
   ```bash
   cp .claude/skills/writing-markdown/templates/skill.md.template ./new-skill/SKILL.md
   cp .claude/skills/writing-markdown/templates/spec.md.template ./specs/feature.md
   ```

3. **Write content** (follow Quick Reference table)

4. **Check size**
   - <150 lines? Good
   - >150 lines? Use progressive disclosure (see patterns/progressive-disclosure.md)

5. **Validate** (**MANDATORY**)
   ```bash
   python3 .claude/skills/writing-markdown/scripts/validate-markdown.py path/to/file.md
   ```
   Must pass all checks

## Validation

**Run before completing**:
```bash
python3 .claude/skills/writing-markdown/scripts/validate-markdown.py path/to/file.md
```

**Checks**:
- Prose ratio <30%
- Section length <200 words
- No preambles/filler
- Headers are complete thoughts
- No hedge words without justification

**Output**:
```
❌ FAIL: Prose ratio 47% (target <30%)
❌ FAIL: Section "Core Concepts" is 312 words (max 200)
⚠️  WARNING: Detected preamble at line 15: "In this section, we'll..."
✅ PASS: Headers are complete thoughts
✅ PASS: No hedge words detected

SCORE: 2/5 checks passed

FIXES:
1. Convert "Features" bullet list (lines 45-52) to comparison table
2. Split "Core Concepts" section or move details to pattern file
3. Delete lines 15-17 (preamble)
```

## Templates

Copy and customize:

```bash
# Skill documentation
cp .claude/skills/writing-markdown/templates/skill.md.template ./new-skill/SKILL.md

# Specification document
cp .claude/skills/writing-markdown/templates/spec.md.template ./specs/feature.md

# Reference documentation
cp .claude/skills/writing-markdown/templates/reference.md.template ./docs/api.md
```

## Pattern Files

**Load these for detailed guidance**:

| File | Use When |
|------|----------|
| `patterns/table-patterns.md` | Designing complex tables, choosing table vs bullets |
| `patterns/code-over-prose.md` | Deciding show vs tell, code block strategies |
| `patterns/header-hierarchy.md` | Naming headers, limiting structure depth |
| `patterns/exemptions.md` | Checking if traditional style allowed |

## Enforcement

**MANDATORY rejection criteria**:
- Preambles ("Let me...", "In this...", "It's important to note...")
- Filler transitions between sections
- >200 word sections without tables/code blocks
- Prose where tables work (comparisons, lists, workflows)
- Hedge language without technical justification
- Documentation without immediate need

**The test**: Can a sleep-deprived engineer find the answer in 10 seconds while on-call? If no → rewrite.

**Before writing**: Ask "Is this document essential?" If answer is "might be useful later" → DON'T WRITE.

## DECISION TREE

```
┌─ Is this a SKILL.md, spec, or pattern file?
│  └─ YES → Use this skill (structured format MANDATORY)
│  └─ NO ↓
│
├─ Is this a README.md or tutorial?
│  └─ YES → Traditional prose allowed (EXEMPT)
│  └─ NO ↓
│
├─ Is this user-facing guide for non-technical audience?
│  └─ YES → Traditional prose allowed (EXEMPT)
│  └─ NO ↓
│
└─ Is this technical reference or documentation?
   └─ YES → Use this skill (structured format)
   └─ NO → Evaluate if doc needed at all
```

## STEP-BY-STEP EXECUTION

### Step 1: Determine Document Type

- [ ] **Skill documentation?**: Use `templates/skill.md.template`
- [ ] **Specification?**: Use `templates/spec.md.template`
- [ ] **Reference?**: Use `templates/reference.md.template`
- [ ] **README/tutorial?**: EXEMPT - traditional prose allowed
- [ ] **User guide?**: EXEMPT - traditional prose allowed

### Step 2: Copy Template

- [ ] **Copy appropriate template** from `.claude/skills/writing-markdown/templates/`
- [ ] **Fill sections** with structured content (tables, bullets, code blocks)
- [ ] **Remove unused sections** if not applicable

### Step 3: Write Content Using Quick Reference

For each section, ask:

- [ ] **Is this a comparison?** → Use table
- [ ] **Is this a how-to?** → Use code block
- [ ] **Is this a list of facts?** → Use table or bullets
- [ ] **Is this >200 words?** → Split into subsections or use pattern file
- [ ] **Is this prose >30% of section?** → Convert to tables/bullets

### Step 4: Kill Preambles and Fluff

- [ ] **Remove**: "In this section...", "Let me...", "It's important to note..."
- [ ] **Remove**: Hedge words without technical justification
- [ ] **Remove**: Repeated transitions between sections
- [ ] **Remove**: Summary sections that repeat content
- [ ] **Remove**: Obvious introductions ("This document describes...")

### Step 5: Optimize Headers

- [ ] **Make headers complete thoughts**: "Workflow: Creating Hooks" NOT "Usage"
- [ ] **Use question format** for problem-solving: "When to Use?" NOT "Use Cases"
- [ ] **Limit depth** to 3 levels max (##, ###, ####)
- [ ] **Avoid generic headers**: "Examples", "Details", "Information"

### Step 6: Validate MANDATORY

- [ ] **Run validator**: `python3 .claude/skills/writing-markdown/scripts/validate-markdown.py <file>`
- [ ] **Check prose ratio**: Must be <30%
- [ ] **Check section length**: Each section <200 words
- [ ] **Check preambles**: None detected
- [ ] **Check headers**: Complete thoughts, not vague
- [ ] **Fix failures**: Address all validation errors before completing

### Step 7: Progressive Disclosure Check

- [ ] **Document <150 lines?**: Good, single file acceptable
- [ ] **Document >150 lines?**: Use progressive disclosure
  - Core concepts in main file
  - Detailed patterns in `patterns/` subdirectory
  - Link from main file: "See `patterns/table-patterns.md` for details"

## ERROR HANDLING

| Error | Detection | Fix |
|-------|-----------|-----|
| **Prose ratio >30%** | Validator fails | Convert explanations to tables, bullets, or code blocks |
| **Section >200 words** | Validator fails | Split into subsections or move to pattern file |
| **Preamble detected** | Validator warns | Delete intro paragraph ("In this section...") |
| **Vague headers** | "Usage", "Examples", "Details" | Rename: "Workflow: X", "Pattern: Y", "Reference: Z" |
| **Hedge words excessive** | "might", "could", "possibly" without reason | Remove or justify with technical constraint |
| **Document >150 lines** | Line count check | Use progressive disclosure, link to pattern files |
| **Missing tables** | Comparison in prose format | Convert "X does A, Y does B" → table with columns |
| **Code in prose** | How-to in paragraph form | Extract to code block with syntax highlighting |
| **Repeated content** | Summary duplicates sections | Delete summary, link to sections instead |
| **No template used** | Starting from blank file | Copy appropriate template first |

## SELF-DIAGNOSIS

**Quality Checks** (run validator before completing):

```bash
# MANDATORY validation before marking complete
python3 .claude/skills/writing-markdown/scripts/validate-markdown.py path/to/file.md
```

**Manual Checks**:

1. **10-Second Test**: Can sleep-deprived engineer find answer quickly?
   - ✅ Yes: Information is scannable (tables, headers, bullets)
   - ❌ No: Too much prose, need to read paragraphs

2. **Structure Dominates**: >70% tables/bullets/code?
   - ✅ Yes: Prose ratio <30%
   - ❌ No: Too much narrative explanation

3. **No Fluff**: All content essential?
   - ✅ Yes: Every sentence adds unique information
   - ❌ No: Preambles, transitions, obvious statements present

4. **Headers Guide**: Can navigate by headers alone?
   - ✅ Yes: Headers are complete thoughts, specific
   - ❌ No: Generic headers like "Usage", "Examples"

5. **Token Efficiency**: Could this be 50% shorter?
   - ✅ No: Already maximally dense
   - ❌ Yes: Convert prose to tables, remove redundancy

6. **Progressive Disclosure**: Large docs split appropriately?
   - ✅ Yes: Core <150 lines, details in pattern files
   - ❌ No: Single massive file >150 lines

**Validation Output Example**:
```
❌ FAIL: Prose ratio 47% (target <30%)
❌ FAIL: Section "Core Concepts" is 312 words (max 200)
⚠️  WARNING: Detected preamble at line 15: "In this section, we'll..."
✅ PASS: Headers are complete thoughts
✅ PASS: No hedge words detected

SCORE: 2/5 checks passed

FIXES:
1. Convert "Features" bullet list (lines 45-52) to comparison table
2. Split "Core Concepts" section or move details to pattern file
3. Delete lines 15-17 (preamble)
```

## SELF-IMPROVEMENT

**Triggers** (when to improve this skill):

1. **Validator fails with same error repeatedly**
   - Root cause: Pattern not caught by current rules
   - Fix: Enhance validator script with new detection rule
   - Log: Record failure pattern, update validation logic

2. **User says "too verbose" or "can't find answer"**
   - Root cause: Still too much prose or poor structure
   - Fix: Tighten prose ratio threshold, improve table detection
   - Log: Record example, add to anti-patterns

3. **Document review finds preamble** validator missed
   - Root cause: Preamble detection pattern incomplete
   - Fix: Add phrasing to forbidden patterns list
   - Log: Record missed preamble, update regex

4. **Engineer takes >10 seconds to find info**
   - Root cause: Headers not descriptive enough or structure unclear
   - Fix: Enhance header quality rules, improve section organization
   - Log: Record search scenario, create better header examples

5. **Prose converted to table improves clarity**
   - Root cause: Missed opportunity for structured format
   - Fix: Add example to transformation patterns guide
   - Log: Record before/after, add to skill examples

**Improvement Mechanics** (file-based):

```bash
# Log markdown quality failures
log_markdown_failure() {
  local file="$1"
  local failure_type="$2"
  local validator_output="$3"

  cat >> .claude/skills/writing-markdown/improvement-log.md <<EOF
## FAILURE: $(date)
**File**: ${file}
**Type**: ${failure_type}
**Validator Output**:
\`\`\`
${validator_output}
\`\`\`
**Root Cause**: [analyze pattern]
**Proposed Fix**: [validator enhancement or skill update]

EOF
}

# Example usage
if validator_fails; then
  log_markdown_failure \
    "SKILL.md" \
    "prose_ratio_exceeded" \
    "$(cat validation_output.txt)"
fi

# Review log every 5 failures
failure_count=$(grep -c "^## FAILURE:" .claude/skills/writing-markdown/improvement-log.md)
if [ $((failure_count % 5)) -eq 0 ]; then
  echo "⚠️ Threshold reached: Review and enhance validator"
  # Aggregate patterns, update validation rules
fi
```

**Rating Thresholds**:
- Validator passes all checks (5/5) → 5/5 (perfect structure)
- Validator passes 4/5 checks → 4/5 (minor issues)
- Validator passes 3/5 checks → 3/5 (needs revision)
- Validator passes <3/5 checks → 1/5 (major restructuring needed)
- User finds answer in <10 seconds → 5/5 (scannable)
- User takes >30 seconds → 2/5 (too verbose or unclear structure)

**Validator Enhancement Cycle**:
1. Collect 5 validation failures of same type
2. Identify common pattern (e.g., new preamble phrasing)
3. Add detection rule to validator script
4. Update skill examples with caught pattern
5. Test on existing docs
6. Measure improvement (fewer failures)
