---
description: Diagnose git backup setup and identify potential issues
allowed-tools: Bash, Read
argument-hint: "<folder_path>"
---

# Git Backup Doctor

Check a folder's backup setup for potential issues.

## Steps

1. **Get the target folder** from argument or current directory

2. **Run diagnostics**:

   ```bash
   cd "<folder_path>"

   echo "=== Git Backup Doctor ==="
   echo ""

   # Check if git repo
   if [ ! -d .git ]; then
       echo "❌ Not a git repository"
       exit 1
   fi
   echo "✓ Git repository"

   # Check remote
   REMOTE=$(git remote get-url origin 2>/dev/null)
   if [ -z "$REMOTE" ]; then
       echo "❌ No remote configured"
   else
       echo "✓ Remote: $REMOTE"
   fi

   # Check connectivity
   if git ls-remote origin HEAD &>/dev/null; then
       echo "✓ Remote accessible"
   else
       echo "❌ Cannot reach remote (check auth/network)"
   fi

   # Check .gitignore exists
   if [ -f .gitignore ]; then
       echo "✓ .gitignore exists"
   else
       echo "⚠ No .gitignore - large files may be committed"
   fi

   # Check for large files not in gitignore
   LARGE=$(find . -type f -not -path './.git/*' -size +50M 2>/dev/null | head -5)
   if [ -n "$LARGE" ]; then
       echo "⚠ Large files (>50MB) found:"
       echo "$LARGE" | sed 's/^/    /'
   else
       echo "✓ No large files"
   fi

   # Check for embedded git repos
   EMBEDDED=$(find . -mindepth 2 -name ".git" -type d 2>/dev/null | head -5)
   if [ -n "$EMBEDDED" ]; then
       echo "⚠ Embedded git repos found:"
       echo "$EMBEDDED" | sed 's/\/.git$//' | sed 's/^/    /'
   else
       echo "✓ No embedded git repos"
   fi

   # Check launchd job
   BASENAME=$(basename "$PWD")
   JOB_LABEL="com.git-backup.$BASENAME"
   if launchctl list 2>/dev/null | grep -q "$JOB_LABEL"; then
       echo "✓ Launchd job active: $JOB_LABEL"
   else
       echo "⚠ Launchd job not found: $JOB_LABEL"
   fi

   # Check last backup
   LAST_COMMIT=$(git log -1 --format="%ar: %s" 2>/dev/null)
   if [ -n "$LAST_COMMIT" ]; then
       echo "✓ Last commit: $LAST_COMMIT"
   fi

   # Check pending changes
   CHANGES=$(git status --short | wc -l | tr -d ' ')
   if [ "$CHANGES" -gt 0 ]; then
       echo "⚠ Pending changes: $CHANGES files"
   else
       echo "✓ No pending changes"
   fi
   ```

3. **Report summary**:
   - List all issues found
   - Suggest fixes for each issue
