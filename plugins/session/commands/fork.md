---
description: Fork session to new terminal with a new task
allowed-tools: Bash, AskUserQuestion
---

# Fork Session

Fork this session to work on a parallel task. The forked session shares context but starts fresh.

## Step 1: Get the fork prompt

If no argument provided, ask the user what they want to work on in the forked session:

```
Question: "What do you want to work on in the forked session?"
Header: "Fork task"
Options:
- "Bug fix" / "Fix a bug while keeping current work"
- "Experiment" / "Try an alternative approach"
- "Parallel task" / "Work on something else in parallel"
- "Other" / "I'll type my own prompt"
```

After selection, ask for specifics if needed. Build a clear prompt for the forked session.

## Step 2: Execute fork

Run this script with the prompt:

```bash
set -e
FORK_PROMPT="$1"
source "${CLAUDE_PLUGIN_ROOT}/lib.sh"
ensure_config && get_session_info && build_command fork && execute_fork "$FORK_PROMPT"
```

The forked session will start with the prompt you specified.
