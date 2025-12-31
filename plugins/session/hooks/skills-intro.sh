#!/bin/bash
# Session plugin skills context for Claude

cat << 'EOF'
<plugin-reminder>
# Session Skills

When delegating tasks, load `session:delegating` skill if ANY of these apply:
- Task may need to ask user questions
- Task will spawn its own subagents
- Task is too big for subagent context

When user configures new hooks, agents, skills, or plugins, load `session:restarting-sessions` skill.
</plugin-reminder>
EOF
