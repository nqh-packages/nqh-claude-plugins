---
name: delegating
description: Activates when Claude is about to use Task tool for delegation. Helps decide if fork/spawn is better than subagent. Load when delegating tasks, using Task tool, or when task is large/complex.
version: 1.0.0
---

# When to Branch Instead of Subagent

## Decision Tree

```
About to delegate?
│
├── Task is small, focused, no user interaction?
│   └── Subagent ✓
│
└── ANY of these true?
    • Task may require clarifying with user
    • Task will need its own subagents
    • Task is too large for subagent context
    │
    └── Fork or Spawn
```

## When Subagent is NOT Enough

| Condition | Why Fork/Spawn |
|-----------|----------------|
| May need user clarification | Subagents cannot interact with user |
| Will need own subagents | Subagents cannot spawn subagents |
| Too large for subagent context | Subagents have limited context window |

## Step 1: Analyze Context and Guess Tasks

Before asking, analyze the conversation to identify:
- What tasks have we discussed that could be delegated?
- What problems or bugs have we identified?
- What alternative approaches have been mentioned?
- What related work could branch off?

Generate 2-3 specific guesses based on context.

## Step 2: Present Guesses as Options

Ask the user with YOUR GUESSES as options:

```
Question: "What should I delegate to a new session?"
Header: "Delegate"
Options:
- "<Your guess 1>" / "<Brief explanation>"
- "<Your guess 2>" / "<Brief explanation>"
- "<Your guess 3>" / "<Brief explanation>"
- "Other" / "I'll describe something else"
```

Example based on a conversation about auth bugs:
```
Question: "What should I delegate to a new session?"
Header: "Delegate"
Options:
- "Fix the OAuth redirect bug" / "The issue in login.tsx:42 we identified"
- "Refactor auth middleware" / "The cleanup we discussed for better error handling"
- "Write auth integration tests" / "Cover the edge cases we found"
- "Other" / "I'll describe something else"
```

## Step 3: Determine Fork vs Spawn

Based on the chosen task, decide:

| Task characteristic | Choice |
|---------------------|--------|
| Builds on our discussion | Fork |
| References things we talked about | Fork |
| Completely independent | Spawn |
| Different project/codebase | Spawn |
| User wants clean slate | Spawn |

## Step 4: Build the Prompt

Craft a clear, actionable prompt:
1. State the task clearly
2. Include relevant context if forking
3. Reference specific files/lines if known

## Step 5: Execute

### Fork (related task)

```bash
set -e
FORK_PROMPT="$1"
source "${CLAUDE_PLUGIN_ROOT}/lib.sh"
ensure_config && get_session_info && build_command fork && execute_fork "$FORK_PROMPT"
```

### Spawn (unrelated task)

```bash
set -e
SPAWN_PROMPT="$1"
source "${CLAUDE_PLUGIN_ROOT}/lib.sh"
ensure_config && build_spawn_command && execute_spawn "$SPAWN_PROMPT"
```

For clean slate spawn, pass empty string: `execute_spawn ""`
