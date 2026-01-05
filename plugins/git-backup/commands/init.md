---
description: Initialize a folder for automatic daily git backup to a private GitHub repo
allowed-tools: Bash, Read, Write, AskUserQuestion
argument-hint: "<folder_path>"
---

# Initialize Git Backup

Set up automatic daily backup for a folder to a private GitHub repository.

## Steps

1. **Get the target folder** from the argument or ask the user:
   - If argument provided, use it (expand ~ to $HOME)
   - If no argument, ask: "Which folder do you want to back up?"

2. **Validate the folder exists**:
   ```bash
   test -d "<folder_path>"
   ```

3. **Check if already a git repo**:
   ```bash
   test -d "<folder_path>/.git"
   ```
   - If yes, check if remote exists: `git -C "<folder_path>" remote get-url origin`
   - If no remote, continue to step 4
   - If remote exists, skip to step 5

4. **Initialize git and configure remote**:
   - If not a git repo: `git -C "<folder_path>" init`
   - Ask user for their private GitHub repo URL:
     - "What's the GitHub repo URL? (e.g., git@github.com:username/repo.git)"
   - Add remote: `git -C "<folder_path>" remote add origin <url>`

5. **Create .gitignore if needed**:
   - Ask user: "Any files/patterns to exclude from backup?"
   - Common suggestions: `.DS_Store`, `*.log`, `node_modules/`, `.env`
   - Create/update .gitignore in the folder

6. **Install launchd job**:
   - Generate job label from folder name: `com.git-backup.<folder-basename>`
   - Run:
     ```bash
     bash "${CLAUDE_PLUGIN_ROOT}/scripts/install-launchd.sh" "<folder_path>" "<job_label>" "${CLAUDE_PLUGIN_ROOT}/scripts/backup.sh"
     ```

7. **Run initial backup**:
   - Ask: "Run initial backup now?"
   - If yes:
     ```bash
     bash "${CLAUDE_PLUGIN_ROOT}/scripts/backup.sh" "<folder_path>"
     ```

8. **Show summary**:
   - Folder path
   - Remote URL
   - Launchd job label
   - Log file location
   - Next scheduled backup (tomorrow 9 AM)

## Restore Instructions

Tell the user: "To restore on a new Mac, run:"
```bash
git clone <repo_url> <folder_path>
```
Then run `/git-backup:init <folder_path>` to set up the daily schedule again.
