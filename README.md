# codee-claude

Codee's Claude Code configuration — a curated collection of agents and commands for AI-assisted development workflows.

## Overview

This repository contains `.claude/` configuration files that enhance Claude Code with specialized agents and workflow commands. Copy the `.claude/` directory to your project root to enable these capabilities.

## Agents

### Codebase Research Agents
From [humanlayer/humanlayer](https://github.com/humanlayer/humanlayer):

| Agent | Purpose |
|-------|---------|
| `codebase-analyzer` | Deep analysis of how specific code works |
| `codebase-locator` | Find where files and components live |
| `codebase-pattern-finder` | Discover existing patterns to follow |
| `web-search-researcher` | External documentation and resource lookup |

### 37signals Rails Agents
From [ThibautBaissac/rails_ai_agents](https://github.com/ThibautBaissac/rails_ai_agents):

| Agent | Purpose |
|-------|---------|
| `api-agent` | API endpoint design and implementation |
| `auth-agent` | Authentication patterns and security |
| `caching-agent` | Caching strategies and implementation |
| `concerns-agent` | Shared concerns and mixins |
| `crud-agent` | Standard CRUD operations |
| `events-agent` | Event-driven architecture patterns |
| `implement-agent` | General implementation guidance |
| `jobs-agent` | Background job patterns |
| `mailer-agent` | Email and notification patterns |
| `migration-agent` | Database migrations and schema changes |
| `model-agent` | ActiveRecord models and relationships |
| `multi-tenant-agent` | Multi-tenancy patterns |
| `refactoring-agent` | Code refactoring strategies |
| `review-agent` | Code review and quality checks |
| `state-records-agent` | State machine patterns |
| `stimulus-agent` | Stimulus.js controller patterns |
| `test-agent` | Testing strategies and patterns |
| `turbo-agent` | Turbo Streams and Frames patterns |

## Commands

| Command | Purpose |
|---------|---------|
| `/research_codebase` | Document and explain existing code without suggesting changes. Creates research documents in `thoughts/shared/research/` |
| `/create_plan` | Interactive planning workflow to create detailed implementation plans in `thoughts/shared/plans/` |
| `/implement_plan` | Execute implementation plans phase by phase with verification checkpoints |
| `/vibe2win` | Translate informal "vibe instructions" into structured technical specs before coding |

## Setup

1. Clone this repository or copy the `.claude/` directory to your project root:
   ```bash
   cp -r codee-claude/.claude /path/to/your/project/
   ```

2. Create a `thoughts/` directory structure in your project:
   ```bash
   mkdir -p thoughts/shared/research thoughts/shared/plans
   ```

3. Use the commands in Claude Code:
   ```
   /research_codebase
   /create_plan
   /implement_plan thoughts/shared/plans/2025-01-08-feature-name.md
   ```

## Philosophy

- **Research first**: Understand before changing
- **Plan before implementing**: Get alignment on approach
- **Phase-based implementation**: Incremental, verifiable progress
- **Human checkpoints**: Manual verification between phases

## Credits

- Base commands and research agents: [humanlayer/humanlayer](https://github.com/humanlayer/humanlayer)
- 37signals Rails agents: [ThibautBaissac/rails_ai_agents](https://github.com/ThibautBaissac/rails_ai_agents)

## License

MIT
