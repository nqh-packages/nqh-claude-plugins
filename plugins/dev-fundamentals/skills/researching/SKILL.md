---
name: researching
description: Orchestrates research by delegating to research-agent subagents and synthesizing results. Use when external information, source validation, or best practices discovery needed.
---

# Researching

Orchestrator skill for delegating research to `research-agent` subagents and synthesizing findings for user.

## Phase 0: Should You Research?

```
NEED external info, docs, or validation?
├── YES → Continue to Phase 1
└── NO → Skip this skill
```

**Blind Spot Check** - Before skipping, ask yourself:
- What good questions am I not asking about this topic?
- What would an expert investigate that I'm skipping?

If either reveals gaps → research anyway.

## Phase 1: Assess Complexity

| Factor | Single Agent | Multi-Agent |
|--------|--------------|-------------|
| Scope | Narrow, defined | Multi-aspect |
| Parallel | Sequential | 3+ directions |
| Context | Fits one window | Exceeds 200K |

**Decision**:
```
Query has 3+ independent aspects?
├── YES → Spawn multiple research-agent subagents in parallel
└── NO → Spawn single research-agent subagent
```

**Default**: Single agent. Escalate only when parallelization justifies cost.

## Phase 2: Delegate to Research Agent(s)

```typescript
Task({
  subagent_type: "research-agent",
  prompt: "Research: [specific question with clear scope]",
  description: "Research [topic]"
})
```

**Prompt must include**:

| Element | Required | Why |
|---------|----------|-----|
| Purpose | YES | Clear research goal |
| Boundaries | YES | What's in/out of scope |
| Output format | YES | What to return |
| Blind spot prompts | RECOMMENDED | Reveal unknown unknowns |

**Blind Spot Prompts** - Include 1-2 in delegation prompt:
- "What good questions am I not asking about [topic]?"
- "What do experts disagree on about [topic], and why?"
- "What would an expert investigate that a layperson would skip?"
- "What are open/unsolved questions about [topic]?"

## Phase 3: Synthesize Results

When research-agent returns:

1. **Review findings** - Check source scores, coverage
2. **Report to user** - Structured summary with sources

**Synthesis format**:
```markdown
## Research Summary: [Topic]

**Key Findings**:
| # | Finding | Confidence | Source |
|---|---------|------------|--------|

**Sources** (by score):
| Score | Source | Type |
```

## Validation

- [ ] Complexity assessed before delegation
- [ ] Research-agent prompt has purpose + boundaries + format
- [ ] Results synthesized with source scores

---

## SELF-DIAGNOSIS

### When to Check
- Research returns low-quality sources
- Missing coverage on query aspects
- User rejects findings

### Environment Checks
- [ ] research-agent available in `.claude/agents/`
- [ ] Firecrawl API key in `~/.zshrc`
- [ ] Output directory `~/tmp/` exists

### Failure Analysis
- [ ] Did complexity assessment match actual needs?
- [ ] Was delegation prompt specific enough?
- [ ] Are source thresholds too strict/loose?

---

## SELF-IMPROVEMENT

**LLM-driven**: Claude reads `data/feedback.json` at session start.

### Feedback Schema

```json
{
  "sessions": [{
    "session_id": "uuid",
    "timestamp": "ISO8601",
    "query_type": "simple|comparative|complex",
    "agents_spawned": 1,
    "source_quality_avg": 75,
    "user_satisfaction": "accepted|revised|rejected"
  }]
}
```

### Session Start Intelligence

1. Read data/feedback.json
2. Calculate: avg source quality, acceptance rate
3. If rejection rate >30%: tighten delegation prompts
4. If source quality <70 avg: adjust thresholds

### Learning Triggers

| Trigger | Action |
|---------|--------|
| User rejects >30% | Review delegation prompt quality |
| Source avg <70 | Raise minimum threshold |
| Multi-agent used for simple query | Tighten complexity assessment |

---

## FEEDBACK INTERFACE

**After each session, Claude appends to `data/feedback.json`:**

```json
{
  "session_id": "[generate UUID]",
  "timestamp": "[ISO8601]",
  "query_type": "simple|comparative|complex",
  "agents_spawned": 1,
  "source_quality_avg": 75,
  "user_satisfaction": "accepted|revised|rejected"
}
```
