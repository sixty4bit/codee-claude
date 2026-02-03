---
description: Research codebase and create PLAN phase beads
model: opus
---

# Research Codebase

You are tasked with researching the codebase to understand how to implement a feature. You will create a research document and set up the PLAN phase beads.

## Inputs

This command expects:
1. **Clarify doc path**: `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md`
2. **RESEARCH epic ID**: The epic created by CLARIFY phase (e.g., `llapp-a1b2`)
3. **Project prefix**: For beads (e.g., `llapp`)

## Process

### Step 1: Read Context

1. Read the clarify doc FULLY (no limit/offset)
2. Read the RESEARCH epic: `bd show {{RESEARCH_EPIC_ID}}`
3. Extract:
   - Feature summary
   - Requirements
   - Edge cases
   - Scope
   - Branch name

### Step 2: Create Research Tasks (Beads)

Create tasks under the RESEARCH epic for each area to investigate:

```bash
# Create research tasks
bd create "Understand existing implementation" --prefix {{PREFIX}} --parent {{RESEARCH_EPIC_ID}}
bd create "Find similar patterns in codebase" --prefix {{PREFIX}} --parent {{RESEARCH_EPIC_ID}}
bd create "Identify files to modify" --prefix {{PREFIX}} --parent {{RESEARCH_EPIC_ID}}
bd create "Check test coverage" --prefix {{PREFIX}} --parent {{RESEARCH_EPIC_ID}}
```

### Step 3: Execute Research

For each research task:

1. **Spawn sub-agent** to investigate that area
2. **Sub-agent researches** using read-only tools
3. **Sub-agent updates bead** with findings: `bd update {{TASK_ID}} --note "Findings..."`
4. **Sub-agent closes bead**: `bd close {{TASK_ID}}`

**CRITICAL**: You are documenting what EXISTS, not what SHOULD BE. No recommendations or critiques.

Research areas:
- **Existing implementation**: How does current code work?
- **Similar patterns**: How have we solved this before?
- **Files to modify**: What files will need changes?
- **Test coverage**: What tests exist?

### Step 4: Synthesize Findings

After all research tasks complete:

1. Gather findings from all beads: `bd show {{TASK_ID}}` for each
2. Identify:
   - Key files and their purposes
   - Patterns to follow
   - Integration points
   - Potential challenges

### Step 5: Create PLAN Epic and Tasks

```bash
# Create PLAN epic
bd create "[PLAN] {{BRANCH_NAME}}" --prefix {{PREFIX}} -t epic

# Create initial PLAN tasks based on research findings
bd create "Define implementation approach" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
bd create "Identify agents for implementation" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
bd create "Cross-reference requirements" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
bd create "Create implementation tasks" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
```

### Step 6: Write Research Document

Gather metadata:
```bash
git rev-parse HEAD
git branch --show-current
basename $(git rev-parse --show-toplevel)
date +%Y-%m-%d
```

Write to: `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`

```markdown
---
date: [ISO timestamp]
git_commit: [commit hash]
branch: feature/{{BRANCH_NAME}}
repository: [repo name]
topic: "{{BRANCH_NAME}} Research"
tags: [research, {{relevant tags}}]
status: complete
---

# Research: {{BRANCH_NAME}}

## Research Question
[From clarify doc - what are we building?]

## Summary
[High-level findings]

## Detailed Findings

### Existing Implementation
(From bead {{TASK_ID}})
[What exists now, file:line references]

### Similar Patterns
(From bead {{TASK_ID}})
[Patterns to follow, examples found]

### Files to Modify
(From bead {{TASK_ID}})
- `path/to/file.rb` — What changes needed
- `path/to/other.rb` — What changes needed

### Test Coverage
(From bead {{TASK_ID}})
[Existing tests, gaps identified]

## Key Discoveries
- [Important finding 1]
- [Important finding 2]

## Beads
- RESEARCH Epic: {{RESEARCH_EPIC_ID}}
- Research Tasks: {{TASK_IDS}}
- PLAN Epic: {{PLAN_EPIC_ID}} (created for next phase)
- PLAN Tasks: {{PLAN_TASK_IDS}}

## Next Phase
PLAN phase ready with epic {{PLAN_EPIC_ID}}
```

### Step 7: Close RESEARCH Epic

```bash
bd close {{RESEARCH_EPIC_ID}}
```

### Step 8: Handoff

1. Commit changes: `git add -A && git commit -m "Research: {{BRANCH_NAME}}"`
2. Push branch: `git push`
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

Please review the research doc and let me know:
- Any corrections needed?
- Ready to proceed to PLAN phase?
```

Wait for user approval before proceeding.

## Context Management

**At 55% context**: Run `create_handoff` command, then `resume_handoff` in new session.

## Important Notes

- **Document what IS, not what SHOULD BE** — No recommendations
- **Use beads for all tasks** — Creates audit trail
- **Close beads when done** — Keeps state clean
- **Create next phase beads** — Chain of responsibility
- **Commit frequently** — Preserve progress
