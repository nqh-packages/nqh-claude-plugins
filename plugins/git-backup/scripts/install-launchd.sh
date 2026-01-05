#!/bin/bash
# Install launchd plist for daily backup at 9 AM
# Usage: install-launchd.sh <backup_dir> <job_label>

set -e

BACKUP_DIR="$1"
JOB_LABEL="$2"
BACKUP_SCRIPT="$3"

if [ -z "$BACKUP_DIR" ] || [ -z "$JOB_LABEL" ] || [ -z "$BACKUP_SCRIPT" ]; then
    echo "Usage: install-launchd.sh <backup_dir> <job_label> <backup_script>"
    exit 1
fi

PLIST_PATH="$HOME/Library/LaunchAgents/${JOB_LABEL}.plist"

# Unload existing job if present
if launchctl list | grep -q "$JOB_LABEL"; then
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
fi

# Create plist
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${JOB_LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${BACKUP_SCRIPT}</string>
        <string>${BACKUP_DIR}</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>${HOME}/.git-backup-${JOB_LABEL}.log</string>
    <key>StandardErrorPath</key>
    <string>${HOME}/.git-backup-${JOB_LABEL}.log</string>
    <key>RunAtLoad</key>
    <false/>
</dict>
</plist>
EOF

# Load the job
launchctl load "$PLIST_PATH"

echo "Installed launchd job: $JOB_LABEL"
echo "Plist: $PLIST_PATH"
echo "Log: $HOME/.git-backup-${JOB_LABEL}.log"
echo "Schedule: Daily at 9:00 AM"
