---
description: Fork session to new terminal with a new task
allowed-tools: Bash, AskUserQuestion
---

# Fork Session

Fork this session to work on a parallel task. The forked session shares context but starts fresh.

## Step 1: Understand the fork request

Read the user's message (argument or conversation context). DO NOT just pass it through.

**If argument provided**: Analyze what the user wants to accomplish. Consider:
- What task are they asking to fork off?
- Is there relevant context from our conversation?
- Should the prompt be refined for clarity?

**If no argument**: Ask the user:

```
Question: "What do you want to work on in the forked session?"
Header: "Fork task"
Options:
- "Bug fix" / "Fix a bug while keeping current work"
- "Experiment" / "Try an alternative approach"
- "Parallel task" / "Work on something else in parallel"
- "Other" / "I'll type my own prompt"
```

## Step 2: Build the fork prompt

Based on your understanding, craft a clear prompt that:
1. States the task clearly
2. Includes relevant context from conversation if helpful
3. Is actionable for the forked session

Example refinements:
| User says | Refined prompt |
|-----------|----------------|
| "fix the bug" | "Fix the auth redirect bug we discussed - the issue is in login.tsx:42" |
| "try redis" | "Experiment with Redis caching for the API endpoints instead of in-memory" |

## Step 3: Execute fork

Run this script with your refined prompt:

```bash
set -e
FORK_PROMPT="$1"
source "${CLAUDE_PLUGIN_ROOT}/lib.sh"
ensure_config && get_session_info && build_command fork && execute_fork "$FORK_PROMPT"
```

The forked session will start with context from this session plus your prompt.
