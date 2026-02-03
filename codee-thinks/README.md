# Codee Thinks

Daily process retrospectives from analyzing Discord conversations.

## How It Works

Every day at **4:00 AM PST**, Codee:
1. Reads the previous 24 hours of Discord chat history
2. Analyzes for friction, repeated tasks, failed approaches, and successful patterns
3. Drafts actionable improvements (Claude Code commands, skills, or apps)
4. Writes findings to `YYYY-MM-DD.md`

## File Format

Each daily file contains:
- **Problem**: What friction or inefficiency was observed
- **Proposed Solution**: What should be built
- **Implementation**: Specific file paths, code snippets, command structures

Everything is designed to be immediately actionable—say "build that" and a sub-agent can execute.

## Preferences

1. **Claude Code commands** (`.claude/commands/`) — preferred
2. **OpenClaw skills** — for reusable automation
3. **New applications** — only for complex problems

---

*Cron job ID: `66c43c81-4e13-4ea9-9b01-f6daf7a1939b`*
