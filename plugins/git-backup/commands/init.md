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
   - Ask user for their private GitHub repo URL (suggest HTTPS for reliability):
     - "What's the GitHub repo URL? (e.g., https://github.com/username/repo.git)"
   - Add remote: `git -C "<folder_path>" remote add origin <url>`

5. **Create .gitignore - CRITICAL STEP**:

   First, scan for potential issues:
   ```bash
   # Find embedded git repos
   find "<folder_path>" -mindepth 2 -name ".git" -type d 2>/dev/null

   # Find large files (>50MB)
   find "<folder_path>" -type f -size +50M 2>/dev/null
   ```

   Create a .gitignore that excludes:
   - **Always**: `.DS_Store`, `*.log`, `*.db`, `*.db-shm`, `*.db-wal`
   - **Embedded git repos**: Any directories containing `.git` subdirectories
   - **Large files/dirs**: Files >50MB or directories containing them

   **For ~/.claude specifically**, use this default .gitignore:
   ```
   # Large/transient files
   history.jsonl
   *.log
   *.db
   *.db-shm
   *.db-wal
   stats-cache.json

   # Directories with transient data
   debug/
   file-history/
   session-env/
   shell-snapshots/
   telemetry/
   todos/
   statsig/
   plans/
   transcripts/
   ide/
   downloads/
   backups/
   projects/

   # Embedded git repos (plugin cache, marketplaces)
   plugins/cache/
   plugins/marketplaces/
   gmail-mcp-server/

   # OS files
   .DS_Store

   # Local settings (may contain secrets)
   *.local.md
   *.local.json
   ```

   Show the user the proposed .gitignore and ask: "Does this look right? Add/remove anything?"

6. **Verify connectivity**:
   ```bash
   git -C "<folder_path>" ls-remote origin HEAD
   ```
   - If SSH fails, suggest switching to HTTPS
   - If HTTPS fails, check if repo exists

7. **Install launchd job**:
   - Generate job label from folder name: `com.git-backup.<folder-basename>`
   - Run:
     ```bash
     bash "${CLAUDE_PLUGIN_ROOT}/scripts/install-launchd.sh" "<folder_path>" "<job_label>" "${CLAUDE_PLUGIN_ROOT}/scripts/backup.sh"
     ```

8. **Run initial backup**:
   - Ask: "Run initial backup now?"
   - If yes:
     ```bash
     bash "${CLAUDE_PLUGIN_ROOT}/scripts/backup.sh" "<folder_path>"
     ```

9. **Show summary**:
   - Folder path
   - Remote URL
   - Files/dirs excluded (from .gitignore)
   - Launchd job label
   - Log file location
   - Next scheduled backup (tomorrow 9 AM)

## Restore Instructions

Tell the user: "To restore on a new Mac, run:"
```bash
git clone <repo_url> <folder_path>
/git-backup:init <folder_path>  # Re-enable daily schedule
```
