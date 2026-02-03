---
description: Create implementation plan using beads and set up IMPLEMENT phase
model: opus
---

# Create Plan

You are tasked with creating a detailed implementation plan. You will use beads to track your own work, create tasks for user questions, cross-reference requirements, and set up the IMPLEMENT phase.

## Inputs

This command expects:
1. **PLAN epic ID**: The epic created by RESEARCH phase (e.g., `llapp-b2c3`)
2. **Research doc path**: `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`
3. **Clarify doc path**: `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md`
4. **Project prefix**: For beads (e.g., `llapp`)

## Process

### Step 1: Read Context

1. Read the PLAN epic and its tasks: `bd show {{PLAN_EPIC_ID}}` and `bd list --parent {{PLAN_EPIC_ID}}`
2. Read the research doc FULLY
3. Read the clarify doc FULLY
4. Extract:
   - Requirements from clarify
   - Findings from research
   - Branch name

### Step 2: Work PLAN Tasks

The PLAN epic should have tasks created by RESEARCH phase. Work each task:

#### Task: Define Implementation Approach

1. Based on research findings, determine the best approach
2. Consider:
   - Which patterns to follow
   - Order of changes
   - Risk areas
3. Update bead with approach: `bd update {{TASK_ID}} --note "Approach: ..."`
4. Close bead: `bd close {{TASK_ID}}`

#### Task: Identify Agents for Implementation

1. Determine which sub-agents are needed:
   - Model changes → model-agent
   - Controller changes → controller-agent
   - View changes → view-agent
   - Tests → test-agent
   - Migrations → migration-agent
2. Document agent assignments
3. Update and close bead

#### Task: Cross-Reference Requirements

**CRITICAL**: Spawn a sub-agent to verify all requirements from CLARIFY doc are addressed.

Sub-agent instructions:
```
Read the clarify doc at {{CLARIFY_PATH}}.
Read the research doc at {{RESEARCH_PATH}}.

For EACH requirement in the clarify doc:
1. Verify it is addressed in the research findings
2. If NOT addressed, note it as a gap

Return:
- List of requirements and their coverage status
- List of any gaps found
```

If gaps found:
```bash
# Create user tasks for each gap
bd create "[USER] Verify requirement not needed: {{GAP_DESCRIPTION}}" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
```

**User tasks must be closed before proceeding.**

Present gaps to user:
```
Found requirements that may not be addressed:

- [ ] {{GAP_1}} — Need your input
- [ ] {{GAP_2}} — Need your input

Please confirm these are intentionally out of scope, or let me know if they should be included.
```

Wait for user to respond. Close user tasks as they confirm.

#### Task: Create Implementation Tasks

After user tasks are resolved, create the IMPLEMENT epic and tasks:

```bash
# Create top-level IMPLEMENT epic
bd create "[IMPLEMENT] {{BRANCH_NAME}}" --prefix {{PREFIX}} -t epic

# Create child epics/tasks based on the plan
# Example structure:
bd create "[IMPLEMENT] Database changes" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}} -t epic
bd create "Create migration for X" --prefix {{PREFIX}} --parent {{DB_EPIC_ID}}
bd create "Update model Y" --prefix {{PREFIX}} --parent {{DB_EPIC_ID}}

bd create "[IMPLEMENT] Business logic" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}} -t epic
bd create "Add service Z" --prefix {{PREFIX}} --parent {{LOGIC_EPIC_ID}}

bd create "[IMPLEMENT] Tests" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}} -t epic
bd create "Write unit tests for X" --prefix {{PREFIX}} --parent {{TEST_EPIC_ID}}
bd create "Write integration tests for Y" --prefix {{PREFIX}} --parent {{TEST_EPIC_ID}}
```

Set up dependencies:
```bash
# Example: tests depend on implementation
bd block {{TEST_TASK_ID}} --on {{IMPL_TASK_ID}}
```

### Step 3: Handle Open Questions

If you have questions about implementation details:

```bash
# Create user task for each question
bd create "[USER] Question: {{QUESTION}}" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
```

Present questions:
```
I have questions that need answers before finalizing the plan:

1. {{QUESTION_1}}
2. {{QUESTION_2}}

Please provide answers so I can complete the plan.
```

**Wait for answers. Do NOT proceed until all user tasks are closed.**

### Step 4: Write Plan Document

Write to: `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md`

```markdown
---
date: [ISO timestamp]
git_commit: [commit hash]
branch: feature/{{BRANCH_NAME}}
repository: [repo name]
topic: "{{BRANCH_NAME}} Implementation Plan"
status: complete
---

# Implementation Plan: {{BRANCH_NAME}}

## Overview
[Brief description from clarify doc]

## Current State
[Summary from research doc]

## Implementation Approach
[From "Define Implementation Approach" task]

## Agents Assigned
[From "Identify Agents" task]
- model-agent: [tasks]
- controller-agent: [tasks]
- test-agent: [tasks]

## What We're NOT Doing
[Out of scope items, including confirmed gaps]

## Implementation Phases

### Phase 1: [Name]
**Epic**: {{CHILD_EPIC_ID}}

Tasks:
- {{TASK_1}}: [description]
- {{TASK_2}}: [description]

Success Criteria:
- [ ] [Automated check]
- [ ] [Manual verification]

### Phase 2: [Name]
...

## Testing Strategy

### Unit Tests
- [What to test]

### Integration Tests
- [End-to-end scenarios]

### Manual Testing
- [Steps for human verification]

## Beads

### PLAN Phase
- Epic: {{PLAN_EPIC_ID}}
- Tasks: {{PLAN_TASK_IDS}}

### IMPLEMENT Phase
- Epic: {{IMPLEMENT_EPIC_ID}}
- Child Epics: {{CHILD_EPIC_IDS}}
- Tasks: {{ALL_IMPLEMENT_TASK_IDS}}

## References
- Clarify: thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md
- Research: thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md
```

### Step 5: Close PLAN Epic

```bash
bd close {{PLAN_EPIC_ID}}
```

### Step 6: Handoff

1. Commit changes: `git add -A && git commit -m "Plan: {{BRANCH_NAME}}"`
2. Push branch: `git push`
3. Present to user:

```
Plan complete!

📄 Plan doc: thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md

Implementation structure:
- [IMPLEMENT] {{BRANCH_NAME}} ({{IMPLEMENT_EPIC_ID}})
  - [IMPLEMENT] Database changes ({{tasks}})
  - [IMPLEMENT] Business logic ({{tasks}})
  - [IMPLEMENT] Tests ({{tasks}})

Total tasks: {{COUNT}}
Ready tasks: {{READY_COUNT}} (no blockers)

Please review the plan and let me know:
- Any adjustments needed?
- Ready to proceed to IMPLEMENT phase?
```

Wait for user approval before proceeding.

## Context Management

**At 55% context**: Run `create_handoff` command, then `resume_handoff` in new session.

## Important Notes

- **Use beads for everything** — Your own tasks, user questions, implementation tasks
- **User tasks block progress** — Must be closed before proceeding
- **Cross-reference is mandatory** — Verify all requirements addressed
- **One top-level IMPLEMENT epic** — Can have many child epics/tasks
- **Set up dependencies** — Block tasks that depend on others
- **No open questions in final plan** — All must be resolved
