---
description: Check git backup status for a folder (last commit, remote, schedule)
allowed-tools: Bash, Read
argument-hint: "<folder_path>"
---

# Backup Status

Show the backup status for a folder including git info and launchd schedule.

## Steps

1. **Get the target folder** from argument or current working directory

2. **Check git status**:
   ```bash
   git -C "<folder_path>" status --short
   ```

3. **Get last commit info**:
   ```bash
   git -C "<folder_path>" log -1 --format="%h %s (%ar)"
   ```

4. **Get remote URL**:
   ```bash
   git -C "<folder_path>" remote get-url origin
   ```

5. **Check launchd job**:
   - Derive job label: `com.git-backup.<folder-basename>`
   - Check if loaded:
     ```bash
     launchctl list | grep "<job_label>"
     ```
   - Check plist exists:
     ```bash
     test -f "$HOME/Library/LaunchAgents/<job_label>.plist"
     ```

6. **Check log file** (last few lines if exists):
   ```bash
   tail -5 "$HOME/.git-backup-<job_label>.log" 2>/dev/null
   ```

7. **Report summary**:
   ```
   Folder: <path>
   Remote: <url>
   Last backup: <commit info>
   Pending changes: <count or "none">
   Launchd job: <loaded/not loaded>
   Schedule: Daily at 9:00 AM
   Last log:
     <log lines>
   ```
