#!/bin/bash
# Git backup script - commits and pushes changes if any exist
# Called by launchd daily or manually via /git-backup:backup

set -e

BACKUP_DIR="$1"
MAX_FILE_SIZE_MB=50

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

# Check for large files before adding
LARGE_FILES=$(find . -type f -not -path './.git/*' -size +${MAX_FILE_SIZE_MB}M 2>/dev/null | head -5)
if [ -n "$LARGE_FILES" ]; then
    echo "Warning: Large files detected (>${MAX_FILE_SIZE_MB}MB):"
    echo "$LARGE_FILES"
    echo ""
    echo "Add these to .gitignore to avoid GitHub warnings/rejection."
    echo "Continuing anyway..."
fi

# Check for embedded git repos
EMBEDDED_REPOS=$(find . -mindepth 2 -name ".git" -type d 2>/dev/null | head -5)
if [ -n "$EMBEDDED_REPOS" ]; then
    echo "Warning: Embedded git repos detected:"
    echo "$EMBEDDED_REPOS" | sed 's/\/.git$//'
    echo ""
    echo "Add these directories to .gitignore to avoid issues."
    echo "Continuing anyway..."
fi

# Add all changes
git add -A

# Commit with timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "Auto backup: $TIMESTAMP"

# Push to remote (try SSH first, then suggest HTTPS on failure)
if ! git push origin HEAD 2>&1; then
    REMOTE_URL=$(git remote get-url origin)
    if [[ "$REMOTE_URL" == git@* ]]; then
        echo ""
        echo "SSH push failed. Try switching to HTTPS:"
        HTTPS_URL=$(echo "$REMOTE_URL" | sed 's|git@github.com:|https://github.com/|')
        echo "  git remote set-url origin $HTTPS_URL"
    fi
    exit 1
fi

echo "Backup complete: $TIMESTAMP"
