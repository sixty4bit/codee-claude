#!/bin/bash
# Simple backup script for codee-claude workspace
# Run manually or add to cron: 0 2 * * * ~/clawd/personas/codee/codee-claude/scripts/backup.sh

set -e

BACKUP_DIR="${BACKUP_DIR:-$HOME/backups/codee}"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_PATH="$BACKUP_DIR/$TIMESTAMP"

mkdir -p "$BACKUP_PATH"

echo "Backing up to $BACKUP_PATH..."

# Beads databases
echo "- Beads databases..."
mkdir -p "$BACKUP_PATH/beads"
cp -r "$HOME/clawd/personas/codee/codee-claude/.beads" "$BACKUP_PATH/beads/codee-claude" 2>/dev/null || true
cp -r "$HOME/clawd/personas/codee/llapp/.beads" "$BACKUP_PATH/beads/llapp" 2>/dev/null || true

# Memory files
echo "- Memory files..."
cp -r "$HOME/clawd/personas/codee/memory" "$BACKUP_PATH/" 2>/dev/null || true

# Workspace config files (not full repos - those are in git)
echo "- Config files..."
mkdir -p "$BACKUP_PATH/config"
cp "$HOME/clawd/personas/codee/codee-claude/MEMORY.md" "$BACKUP_PATH/config/" 2>/dev/null || true
cp "$HOME/clawd/personas/codee/MEMORY.md" "$BACKUP_PATH/config/persona-MEMORY.md" 2>/dev/null || true
cp "$HOME/clawd/personas/codee/USER.md" "$BACKUP_PATH/config/" 2>/dev/null || true
cp "$HOME/clawd/personas/codee/TOOLS.md" "$BACKUP_PATH/config/" 2>/dev/null || true

# Cleanup old backups (keep last 7 days)
echo "- Cleaning old backups..."
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null || true

echo "Backup complete: $BACKUP_PATH"
ls -la "$BACKUP_PATH"
