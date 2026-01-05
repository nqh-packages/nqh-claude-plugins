# Git Backup

Automatic daily backup of any folder to a private GitHub repo using macOS launchd.

<!-- VISUAL -->
```
┌─────────────────────────────────────────┐
│  Your Folder    ──────►  Private Repo   │
│  ~/.claude             github.com/...   │
│                                         │
│  ⏰ Daily @ 9 AM (via launchd)          │
│  📦 Auto-commit if changes exist        │
│  🔄 Skip if no changes                  │
└─────────────────────────────────────────┘
```
<!-- /VISUAL -->

## Add Marketplace

```
/plugin marketplace add nqh-packages/nqh-claude-plugins
```

## Add Plugin

```
/plugin install git-backup@nqh-plugins
```

## Commands

| Command | Description |
|---------|-------------|
| `/git-backup:init <folder>` | Set up daily backup for a folder |
| `/git-backup:backup <folder>` | Manual backup (commit + push) |
| `/git-backup:status <folder>` | Check backup status and schedule |
| `/git-backup:restore <url> <path>` | Restore from backup to new location |

## Quick Start

```bash
# Set up backup for ~/.claude
/git-backup:init ~/.claude

# Check status anytime
/git-backup:status ~/.claude

# Manual backup
/git-backup:backup ~/.claude
```

## How It Works

1. **init** creates a launchd job that runs daily at 9 AM
2. The job runs a backup script that:
   - Checks for changes (staged, unstaged, untracked)
   - Skips if nothing changed
   - Commits with timestamp message
   - Pushes to your private repo

## New Mac Setup

On a new Mac, restore your backup:

```bash
git clone git@github.com:you/claude-backup.git ~/.claude
/git-backup:init ~/.claude  # Re-enable daily schedule
```

## Log Files

Logs are stored at `~/.git-backup-<job-label>.log`

---

**v1.0.0** · Initial release
