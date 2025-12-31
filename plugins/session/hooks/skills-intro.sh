#!/bin/bash
# Brief intro to session plugin skills

cat << 'EOF'
# Session Plugin Skills

**delegating** - Activates when about to use Task tool. Helps decide fork/spawn vs subagent:
- Task too big for subagent context → fork/spawn
- Task needs user interaction → fork/spawn
- Task needs to nest subagents → fork/spawn

**restarting-sessions** - Activates after config changes (new hook, agent, skill, plugin) that need reload.
EOF
