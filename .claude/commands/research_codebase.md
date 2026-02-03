---
description: Research codebase using beads for task tracking
model: opus
---

# Research Codebase

You are tasked with conducting comprehensive research across the codebase by creating beads tasks, spawning parallel sub-agents, and synthesizing findings.

## CRITICAL: YOUR ONLY JOB IS TO DOCUMENT AND EXPLAIN THE CODEBASE AS IT EXISTS TODAY
- DO NOT suggest improvements or changes unless explicitly asked
- DO NOT perform root cause analysis unless explicitly asked
- DO NOT propose future enhancements unless explicitly asked
- DO NOT critique the implementation or identify problems
- DO NOT recommend refactoring, optimization, or architectural changes
- ONLY describe what exists, where it exists, how it works, and how components interact
- You are creating a technical map/documentation of the existing system

## Inputs

This command expects:
1. **Clarify doc path** (optional): `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md`
2. **RESEARCH epic ID** (optional): Epic from CLARIFY phase (e.g., `llapp-a1b2`)
3. **Project prefix**: For beads (e.g., `llapp`, `codee`)
4. **Research question**: What to investigate

If no epic provided, create one:
```bash
bd create "[RESEARCH] {{TOPIC}}" --prefix {{PREFIX}} -t epic
```

## Process Overview

Each numbered step becomes a bead task under the RESEARCH epic. This creates an audit trail and allows resuming if interrupted.

## Step 1: Create Research Task Beads

Create a bead for each research step:

```bash
# Create all 9 task beads under the RESEARCH epic
bd create "Step 1: Read mentioned files" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 2: Decompose research question" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 3: Spawn research sub-agents" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 4: Synthesize findings" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 5: Gather metadata" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 6: Generate research document" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 7: Add GitHub permalinks" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 8: Create PLAN phase beads" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 9: Handoff to user" --prefix {{PREFIX}} --parent {{EPIC_ID}}
```

## Step 2: Read Mentioned Files (Task 1)

**Update bead**: `bd update {{TASK_1_ID}} --note "Starting..."`

- If user mentions specific files (tickets, docs, JSON), read them FULLY first
- **IMPORTANT**: Use Read tool WITHOUT limit/offset to read entire files
- **CRITICAL**: Read files yourself before spawning sub-tasks
- This ensures full context before decomposing research

**Close bead**: `bd close {{TASK_1_ID}}`

## Step 3: Decompose Research Question (Task 2)

**Update bead**: `bd update {{TASK_2_ID}} --note "Analyzing query..."`

- Break down user's query into composable research areas
- Identify specific components, patterns, or concepts to investigate
- Consider which directories, files, or patterns are relevant
- Document the decomposition in bead notes

**Close bead**: `bd close {{TASK_2_ID}}`

## Step 4: Spawn Research Sub-Agents (Task 3)

**Update bead**: `bd update {{TASK_3_ID}} --note "Spawning sub-agents..."`

Create multiple sub-agents to research different aspects concurrently:

**For codebase research:**
- **codebase-locator** agent: Find WHERE files and components live
- **codebase-analyzer** agent: Understand HOW specific code works (without critiquing)
- **codebase-pattern-finder** agent: Find examples of existing patterns

**For thoughts directory:**
- **thoughts-locator** agent: Discover what documents exist about the topic
- **thoughts-analyzer** agent: Extract key insights from relevant documents

**For web research (only if user explicitly asks):**
- **web-search-researcher** agent: External documentation and resources
- Include LINKS in findings

**IMPORTANT**: All agents are documentarians, not critics.

The key:
- Start with locator agents to find what exists
- Use analyzer agents on promising findings
- Run multiple agents in parallel
- Each agent knows its job - just tell it what to find
- Remind agents they are documenting, not evaluating

**Close bead when all sub-agents dispatched**: `bd close {{TASK_3_ID}}`

## Step 5: Synthesize Findings (Task 4)

**Update bead**: `bd update {{TASK_4_ID}} --note "Waiting for sub-agents..."`

- **WAIT** for ALL sub-agent tasks to complete
- Compile all sub-agent results
- Prioritize live codebase findings as primary source
- Use thoughts/ findings as supplementary historical context
- Connect findings across components
- Include specific file paths and line numbers
- Highlight patterns, connections, and architectural decisions
- Answer user's specific questions with concrete evidence

**Update bead with findings summary**: `bd update {{TASK_4_ID}} --note "Key findings: ..."`
**Close bead**: `bd close {{TASK_4_ID}}`

## Step 6: Gather Metadata (Task 5)

**Update bead**: `bd update {{TASK_5_ID}} --note "Gathering metadata..."`

```bash
git rev-parse HEAD
git branch --show-current
basename $(git rev-parse --show-toplevel)
date +%Y-%m-%d
```

Filename: `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`

**Close bead**: `bd close {{TASK_5_ID}}`

## Step 7: Generate Research Document (Task 6)

**Update bead**: `bd update {{TASK_6_ID}} --note "Writing document..."`

Write to: `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`

```markdown
---
date: [ISO timestamp]
git_commit: [commit hash]
branch: [branch name]
repository: [repo name]
topic: "[Research Topic]"
tags: [research, codebase, relevant-tags]
status: complete
beads_epic: {{EPIC_ID}}
beads_tasks: [{{TASK_IDS}}]
---

# Research: [Topic]

**Date**: [timestamp]
**Git Commit**: [hash]
**Branch**: [branch]
**Beads Epic**: {{EPIC_ID}}

## Research Question
[Original user query]

## Summary
[High-level findings - what exists, not what should be]

## Detailed Findings

### [Component/Area 1]
- Description of what exists ([file.ext:line](link))
- How it connects to other components
- Current implementation details

### [Component/Area 2]
...

## Code References
- `path/to/file.py:123` - Description
- `another/file.ts:45-67` - Description

## Architecture Documentation
[Current patterns, conventions, designs found]

## Historical Context (from thoughts/)
[Relevant insights with references]

## Open Questions
[Areas needing further investigation]
```

**Close bead**: `bd close {{TASK_6_ID}}`

## Step 8: Add GitHub Permalinks (Task 7)

**Update bead**: `bd update {{TASK_7_ID}} --note "Adding permalinks..."`

- Check if on main branch or commit is pushed
- If yes, generate GitHub permalinks:
  ```bash
  gh repo view --json owner,name
  ```
- Create: `https://github.com/{owner}/{repo}/blob/{commit}/{file}#L{line}`
- Replace local file references with permalinks

**Close bead**: `bd close {{TASK_7_ID}}`

## Step 9: Create PLAN Phase Beads (Task 8)

**Update bead**: `bd update {{TASK_8_ID}} --note "Creating PLAN phase..."`

Create the PLAN epic and initial tasks for next phase:

```bash
# Create PLAN epic
bd create "[PLAN] {{BRANCH_NAME}}" --prefix {{PREFIX}} -t epic

# Create initial PLAN tasks
bd create "Define implementation approach" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
bd create "Identify agents for implementation" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
bd create "Cross-reference requirements" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
bd create "Create implementation tasks" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
```

**Update bead with PLAN epic ID**: `bd update {{TASK_8_ID}} --note "Created PLAN epic: {{PLAN_EPIC_ID}}"`
**Close bead**: `bd close {{TASK_8_ID}}`

## Step 10: Handoff to User (Task 9)

**Update bead**: `bd update {{TASK_9_ID}} --note "Preparing handoff..."`

1. Commit changes:
   ```bash
   git add -A
   git commit -m "Research: {{BRANCH_NAME}}"
   ```

2. Push branch:
   ```bash
   git push
   ```

3. Present to user:
   ```
   Research complete!

   📄 Research doc: thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md

   Key findings:
   - [Summary point 1]
   - [Summary point 2]
   - [Summary point 3]

   🎯 PLAN phase ready:
   - Epic: {{PLAN_EPIC_ID}}
   - Tasks: [list task titles]

   Beads completed:
   - Epic: {{RESEARCH_EPIC_ID}}
   - Tasks: 9/9 closed

   Please review the research doc and let me know:
   - Any corrections needed?
   - Ready to proceed to PLAN phase?
   ```

**Close bead**: `bd close {{TASK_9_ID}}`

4. Close RESEARCH epic: `bd close {{RESEARCH_EPIC_ID}}`

5. Wait for user approval before proceeding.

## Follow-up Questions

If user has follow-up questions:
1. Create new task: `bd create "Follow-up: {{QUESTION}}" --prefix {{PREFIX}} --parent {{RESEARCH_EPIC_ID}}`
2. Reopen epic if needed: `bd reopen {{RESEARCH_EPIC_ID}}`
3. Append to same research document
4. Update frontmatter with `last_updated` fields
5. Add section: `## Follow-up Research [timestamp]`
6. Close new task when done

## Context Management

**At 55% context**:
1. Run `create_handoff` command
2. Note current task bead ID
3. In new session, run `resume_handoff`
4. Check `bd list --parent {{EPIC_ID}} --status open` to find remaining tasks

## Important Notes

- **Beads track everything** - Each step is a task, creating audit trail
- **Close beads as you go** - Shows progress, enables resume
- **Document what IS, not SHOULD BE** - No recommendations
- **Read files FULLY** - Never use limit/offset before spawning
- **Wait for sub-agents** - Don't synthesize until all complete
- **Create next phase beads** - Chain of responsibility
