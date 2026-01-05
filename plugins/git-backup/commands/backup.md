---
description: Manually trigger a git backup for a folder
allowed-tools: Bash
argument-hint: "<folder_path>"
---

# Manual Backup

Trigger an immediate backup (commit + push) for a folder.

## Steps

1. **Get the target folder** from argument or current working directory

2. **Run backup script**:
   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/backup.sh" "<folder_path>"
   ```

3. **Report result**:
   - If "No changes to backup": Tell user no changes were found
   - If "Backup complete": Show the commit message and confirm push succeeded
   - If error: Show the error message
