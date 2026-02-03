# Environment Setup

How to rebuild the codee-claude environment from scratch.

## Prerequisites

- macOS (arm64)
- Node.js 25+ (`node -v`)
- Git configured with GitHub access

## 1. Clone Repositories

```bash
# Main workspace
cd ~/clawd/personas/codee

# codee-claude (this repo)
git clone git@github.com:sixty4bit/codee-claude.git

# beads-ui (visualization)
git clone https://github.com/mantoni/beads-ui.git
```

## 2. Install Beads CLI

```bash
# Download latest release
curl -fsSL https://github.com/steveyegge/beads/releases/latest/download/bd-darwin-arm64 -o ~/.local/bin/bd
chmod +x ~/.local/bin/bd

# Verify
bd --version
```

Make sure `~/.local/bin` is in your PATH.

## 3. Initialize Beads in codee-claude

```bash
cd ~/clawd/personas/codee/codee-claude
bd init --prefix codee
```

## 4. Install Beads UI

```bash
npm i beads-ui -g

# Start (from codee-claude directory)
cd ~/clawd/personas/codee/codee-claude
bdui start --open
```

Runs at http://127.0.0.1:3000

## 5. Related Projects

### LLAPP
```bash
cd ~/clawd/personas/codee
git clone git@github.com:leverage-leadership/llapp.git
cd llapp
bundle install
```

Runs via LaunchAgents (see llapp's README or TOOLS.md).

## Environment Variables

```bash
# Add to ~/.zshrc or equivalent
export PATH="$HOME/.local/bin:$PATH"
export BD_BIN="$HOME/.local/bin/bd"
```

## Directory Structure

```
~/clawd/personas/codee/
├── codee-claude/          # This repo - processes, commands, beads DB
│   ├── .beads/            # Beads database
│   ├── .claude/commands/  # Claude Code commands
│   ├── processes/         # vibe2win and other process docs
│   └── projects/          # Project-specific configs
├── beads-ui/              # Beads visualization (cloned)
├── llapp/                 # LLAPP Rails app
└── memory/                # Session memory files
```

## Beads Database Location

The beads database lives at:
```
~/clawd/personas/codee/codee-claude/.beads/beads.db
```

**This file should be backed up regularly.**

## Backup (TODO)

Currently NO automated backups are configured. Should set up:

1. **Beads DB backup**: `~/.beads/beads.db` and `.beads/beads.db` in repos
2. **Workspace backup**: `~/clawd/personas/codee/`
3. **Frequency**: Daily minimum

Options:
- Time Machine (if enabled)
- rclone to cloud storage
- restic for deduped backups
- Simple rsync to external drive

## Recovery Checklist

If everything breaks:

1. [ ] Clone codee-claude from GitHub
2. [ ] Install beads CLI
3. [ ] Run `bd init --prefix codee`
4. [ ] Install beads-ui
5. [ ] Clone llapp from GitHub
6. [ ] Restore beads.db from backup (if available)
7. [ ] Restore memory files from backup (if available)

## Version Info

As of 2026-02-03:
- beads CLI: v0.49.3
- beads-ui: latest from npm
- Node.js: v25.5.0
