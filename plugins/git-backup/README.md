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
│  ⚠️  Warns about large files/git repos  │
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
| `/git-backup:doctor <folder>` | Diagnose issues with backup setup |

## Quick Start

```bash
# Set up backup for ~/.claude
/git-backup:init ~/.claude

# Check for issues
/git-backup:doctor ~/.claude

# Check status anytime
/git-backup:status ~/.claude

# Manual backup
/git-backup:backup ~/.claude
```

## How It Works

1. **init** scans for large files and embedded git repos, creates .gitignore, then sets up launchd
2. The launchd job runs daily at 9 AM and:
   - Checks for changes (staged, unstaged, untracked)
   - Warns about large files (>50MB) or embedded git repos
   - Skips if nothing changed
   - Commits with timestamp message
   - Pushes to your private repo (HTTPS recommended)

## Smart .gitignore

For `~/.claude`, init creates a .gitignore that excludes:
- Large transient files (`history.jsonl`, `*.db`)
- Session data (`projects/`, `todos/`, `debug/`)
- Plugin cache (embedded git repos)
- Sensitive files (`*.local.json`, `*.local.md`)

## New Mac Setup

On a new Mac, restore your backup:

```bash
git clone https://github.com/you/claude-backup.git ~/.claude
/git-backup:init ~/.claude  # Re-enable daily schedule
```

## Troubleshooting

Run `/git-backup:doctor <folder>` to diagnose issues:
- ❌ Not a git repository
- ❌ No remote configured
- ❌ Cannot reach remote
- ⚠️ Large files found
- ⚠️ Embedded git repos found
- ⚠️ Launchd job not active

## Log Files

Logs are stored at `~/.git-backup-<job-label>.log`

---

**v1.1.0** · Added doctor command, smart .gitignore, large file/embedded repo detection
**v1.0.0** · Initial release
