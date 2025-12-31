---
description: Show current session ID
allowed-tools: Bash
---

Run this script and output ONLY its output:

```bash
set -e
source "${CLAUDE_PLUGIN_ROOT}/lib.sh"
ensure_config && get_session_info && show_session_id
```
