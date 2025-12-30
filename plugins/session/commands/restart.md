---
description: Resume this session in new terminal
allowed-tools: Bash
---

Run this script and output ONLY its output:

```bash
set -e
source "${CLAUDE_PLUGIN_ROOT}/lib.sh"
ensure_config && get_session_info && build_command restart && execute_restart
```
