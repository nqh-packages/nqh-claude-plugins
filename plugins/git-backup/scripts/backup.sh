#!/bin/bash
# Git backup script - commits and pushes changes if any exist
# Called by launchd daily or manually via /git-backup:backup

set -e

BACKUP_DIR="$1"

if [ -z "$BACKUP_DIR" ]; then
    echo "Error: No backup directory specified"
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Directory does not exist: $BACKUP_DIR"
    exit 1
fi

if [ ! -d "$BACKUP_DIR/.git" ]; then
    echo "Error: Not a git repository: $BACKUP_DIR"
    exit 1
fi

cd "$BACKUP_DIR"

# Check if remote exists
if ! git remote get-url origin &>/dev/null; then
    echo "Error: No remote 'origin' configured"
    exit 1
fi

# Check for changes (staged, unstaged, or untracked)
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "No changes to backup"
    exit 0
fi

# Add all changes
git add -A

# Commit with timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "Auto backup: $TIMESTAMP"

# Push to remote
git push origin HEAD

echo "Backup complete: $TIMESTAMP"
