#!/usr/bin/env bash
# @what Outputs session skills context for Claude
# @why Re-inject after compaction so Claude doesn't forget skills

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
