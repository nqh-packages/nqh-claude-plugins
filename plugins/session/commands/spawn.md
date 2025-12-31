---
description: Delegate task to new agent (fresh context, no history)
allowed-tools: Bash, AskUserQuestion
---

# Spawn Session

Delegate a task to a new Claude agent with fresh context. Use this when the task doesn't need our conversation history - unlike fork which carries context forward.

## Step 1: Understand the spawn request

Read the user's message (argument or conversation context). DO NOT just pass it through.

**If argument provided**: Analyze what the user wants to accomplish. Consider:
- What task are they asking to start fresh?
- Should the prompt be refined for clarity?

**If no argument**: Ask the user:

```
Question: "What do you want to delegate to a new agent?"
Header: "Delegate"
Options:
- "Different project" / "Work on something unrelated in this directory"
- "Delegate task" / "Hand off an independent task to a new agent"
- "Clean slate" / "Start fresh with no initial prompt"
- "Other" / "I'll type my own prompt"
```

If user selects "Clean slate", pass empty string to execute.

## Step 2: Build the spawn prompt

Based on your understanding, craft a clear prompt (if any) that:
1. States the task clearly
2. Is actionable for the new session

## Step 3: Execute spawn

Run this script with your prompt (or empty string for clean slate):

```bash
set -e
SPAWN_PROMPT="$1"
source "${CLAUDE_PLUGIN_ROOT}/lib.sh"
ensure_config && build_spawn_command && execute_spawn "$SPAWN_PROMPT"
```

The new session will start fresh with no context from this session.
