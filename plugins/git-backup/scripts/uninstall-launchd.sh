#!/bin/bash
# Uninstall launchd plist for a backup job
# Usage: uninstall-launchd.sh <job_label>

set -e

JOB_LABEL="$1"

if [ -z "$JOB_LABEL" ]; then
    echo "Usage: uninstall-launchd.sh <job_label>"
    exit 1
fi

PLIST_PATH="$HOME/Library/LaunchAgents/${JOB_LABEL}.plist"

if [ ! -f "$PLIST_PATH" ]; then
    echo "No launchd job found: $JOB_LABEL"
    exit 0
fi

# Unload the job
launchctl unload "$PLIST_PATH" 2>/dev/null || true

# Remove plist
rm -f "$PLIST_PATH"

# Remove log file
rm -f "$HOME/.git-backup-${JOB_LABEL}.log"

echo "Uninstalled launchd job: $JOB_LABEL"
