---
description: Restore a backed-up folder from GitHub repo to a new location
allowed-tools: Bash, AskUserQuestion
argument-hint: "<repo_url> <target_path>"
---

# Restore Backup

Clone a backed-up repository to a target location and optionally set up daily backups.

## Steps

1. **Get repo URL and target path**:
   - If both provided as arguments, use them
   - If only one argument, ask for the missing one
   - If no arguments, ask:
     - "What's the GitHub repo URL?"
     - "Where should I restore it to?"

2. **Validate target doesn't exist** (or is empty):
   ```bash
   test -e "<target_path>"
   ```
   - If exists and not empty, ask: "Target exists. Overwrite?"

3. **Clone the repository**:
   ```bash
   git clone "<repo_url>" "<target_path>"
   ```

4. **Ask about daily backup**:
   - "Set up daily automatic backup for this folder?"
   - If yes, run the init steps to install launchd job:
     ```bash
     bash "${CLAUDE_PLUGIN_ROOT}/scripts/install-launchd.sh" "<target_path>" "com.git-backup.<basename>" "${CLAUDE_PLUGIN_ROOT}/scripts/backup.sh"
     ```

5. **Report success**:
   - Show restored path
   - Show file count
   - Show last commit date from backup
   - If launchd installed, show schedule info
