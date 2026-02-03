# vibe2win v2 — Beads-First Feature Development

## Core Principle

**Write everything to a file (or bead) so any session can resume where you left off.**

Beads are the primary state tracking mechanism. Each phase has its own epic with tasks underneath. Sub-agents work the tasks. When all tasks complete, write a summary .md (for humans), then create the next phase's epic and tasks.

---

## Overview

```
CLARIFY → ENVIRONMENT → RESEARCH → PLAN → GAP CHECK → IMPLEMENT
```

Each phase:
1. Has its own epic bead
2. Has tasks under that epic
3. Tasks are worked by sub-agents
4. All tasks must complete before moving to next phase
5. Phase summary written to .md at completion

---

## Phase Structure

### Epic Naming Convention

```
[PHASE] {{BRANCH_NAME}}
```

Examples:
- `[CLARIFY] delete-plannings`
- `[RESEARCH] delete-plannings`
- `[PLAN] delete-plannings`
- `[IMPLEMENT] delete-plannings`

### Task Flow

1. Create phase epic
2. Create tasks under epic for all work in this phase
3. Spawn sub-agents to work tasks (or work them directly if simple)
4. Wait for all tasks to complete
5. Write phase summary .md
6. Create next phase epic + tasks
7. Proceed to next phase

---

## Phase 1: CLARIFY

**Trigger:** User says `vibe2win: <description>`

**Create Epic:**
```bash
bd create "[CLARIFY] {{BRANCH_NAME}}" --prefix {{PROJECT_PREFIX}} -t epic
```

**Create Tasks:**
- `Understand requirements` — Parse user's request
- `Identify edge cases` — What could go wrong?
- `Clarify ambiguities` — Questions for user
- `Define scope` — What's in/out

**Work Tasks:** Ask user clarifying questions, document answers in task notes.

**Phase Output:** `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md`
```markdown
# Clarify: {{BRANCH_NAME}}

## Summary
One paragraph description of the feature.

## Requirements
- Requirement 1
- Requirement 2

## Edge Cases
- Edge case 1
- Edge case 2

## Scope
**In scope:** ...
**Out of scope:** ...

## Beads
- Epic: {{EPIC_ID}}
- Tasks: {{TASK_IDS}}

## Next Phase
Created [ENVIRONMENT] epic: {{NEXT_EPIC_ID}}
```

**Handoff:** Wait for user approval before proceeding.

---

## Phase 2: ENVIRONMENT

**Create Epic:**
```bash
bd create "[ENVIRONMENT] {{BRANCH_NAME}}" --prefix {{PROJECT_PREFIX}} -t epic
```

**Create Tasks:**
- `Create worktree` — Set up isolated working directory
- `Create feature branch` — Branch from main
- `Verify setup` — Confirm environment works

**Work Tasks:**
```bash
git worktree add ~/wt/{{PROJECT_NAME}}/{{BRANCH_NAME}}-wt -b feature/{{BRANCH_NAME}}
```

**Phase Output:** `thoughts/shared/environment/YYYY-MM-DD-{{BRANCH_NAME}}.md`
```markdown
# Environment: {{BRANCH_NAME}}

## Setup
- Worktree: ~/wt/{{PROJECT_NAME}}/{{BRANCH_NAME}}-wt
- Branch: feature/{{BRANCH_NAME}}

## Beads
- Epic: {{EPIC_ID}}
- Tasks: {{TASK_IDS}}

## Next Phase
Created [RESEARCH] epic: {{NEXT_EPIC_ID}}
Tasks created:
- {{TASK_1}}: Research area 1
- {{TASK_2}}: Research area 2
```

---

## Phase 3: RESEARCH

**Create Epic:**
```bash
bd create "[RESEARCH] {{BRANCH_NAME}}" --prefix {{PROJECT_PREFIX}} -t epic
```

**Create Tasks:** Based on what needs to be understood:
- `Research existing implementation` — How does current code work?
- `Research similar patterns` — How have we solved this before?
- `Research dependencies` — What else touches this code?
- `Research tests` — What test coverage exists?

**Work Tasks:** Spawn sub-agents for each research task. Each agent:
1. Investigates their area
2. Updates task with findings
3. Closes task when done

**Phase Output:** `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`
```markdown
# Research: {{BRANCH_NAME}}

## Findings

### Existing Implementation
(From bead {{TASK_1}})
...findings...

### Similar Patterns
(From bead {{TASK_2}})
...findings...

### Dependencies
(From bead {{TASK_3}})
...findings...

## Key Files
- `path/to/file1.rb` — Description
- `path/to/file2.rb` — Description

## Beads
- Epic: {{EPIC_ID}}
- Tasks: {{TASK_IDS}}

## Next Phase
Created [PLAN] epic: {{NEXT_EPIC_ID}}
Tasks created:
- {{TASK_1}}: Plan component 1
- {{TASK_2}}: Plan component 2
```

**Handoff:** Push branch, create draft PR, send user link to research doc.

---

## Phase 4: PLAN

**Create Epic:**
```bash
bd create "[PLAN] {{BRANCH_NAME}}" --prefix {{PROJECT_PREFIX}} -t epic
```

**Create Tasks:** Based on research findings:
- `Plan architecture` — High-level approach
- `Plan implementation steps` — Ordered task list
- `Plan tests` — What tests to write
- `Identify open questions` — What's unclear?

**Work Tasks:** Spawn sub-agents or work directly.

**Phase Output:** `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md`
```markdown
# Plan: {{BRANCH_NAME}}

## Approach
High-level description of the solution.

## Implementation Steps
1. Step 1
2. Step 2
3. Step 3

## Files to Modify
- `path/to/file1.rb` — Changes needed
- `path/to/file2.rb` — Changes needed

## Tests to Write
- Test 1
- Test 2

## Open Questions
- [ ] Question 1
- [ ] Question 2

## Beads
- Epic: {{EPIC_ID}}
- Tasks: {{TASK_IDS}}

## Next Phase
Created [GAP_CHECK] epic: {{NEXT_EPIC_ID}}
```

---

## Phase 5: GAP CHECK

**Create Epic:**
```bash
bd create "[GAP_CHECK] {{BRANCH_NAME}}" --prefix {{PROJECT_PREFIX}} -t epic
```

**Create Tasks:**
- `Compare plan to requirements` — Does plan cover everything?
- `Review open questions` — Get answers from user
- `Validate approach` — Is this the right solution?

**Work Tasks:** Compare original requirements (from CLARIFY) to plan. Identify gaps.

**Loop:** If open questions exist:
1. Ask user
2. Update plan with answers
3. Re-check for gaps
4. Repeat until plan is complete

**Phase Output:** Update `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md` with:
- Answered questions
- Any plan modifications
- Gap check sign-off

**Handoff:** User confirms "Plan approved"

---

## Phase 6: IMPLEMENT

**Create Epic:**
```bash
bd create "[IMPLEMENT] {{BRANCH_NAME}}" --prefix {{PROJECT_PREFIX}} -t epic
```

**Create Tasks:** From the plan's implementation steps:
- Each step becomes a task
- Set dependencies between tasks (blocking relationships)
- Estimate complexity

**Work Tasks:**
```bash
bd ready --prefix {{PROJECT_PREFIX}}  # Show tasks with no blockers
```

For each ready task:
1. Spawn sub-agent with task details + plan context
2. Sub-agent implements, writes tests, commits
3. Sub-agent closes task
4. Check for newly-unblocked tasks
5. Repeat until all tasks done

**Phase Output:** `thoughts/shared/implement/YYYY-MM-DD-{{BRANCH_NAME}}.md`
```markdown
# Implementation: {{BRANCH_NAME}}

## Completed Tasks
- {{TASK_1}}: Description — commit abc123
- {{TASK_2}}: Description — commit def456

## Changes Made
- `path/to/file1.rb` — What changed
- `path/to/file2.rb` — What changed

## Tests Added
- `test/path/to/test1.rb` — What it tests
- `test/path/to/test2.rb` — What it tests

## Beads
- Epic: {{EPIC_ID}}
- Tasks: {{TASK_IDS}}

## PR Ready
Branch: feature/{{BRANCH_NAME}}
All tests passing: ✓
```

---

## Bead Commands Reference

```bash
# Create epic
bd create "[PHASE] feature-name" --prefix llapp -t epic

# Create task under epic
bd create "Task description" --prefix llapp --parent {{EPIC_ID}}

# Add blocking dependency
bd block {{TASK_ID}} --on {{BLOCKER_ID}}

# List tasks for project
bd list --prefix llapp

# Show ready tasks (no blockers)
bd ready --prefix llapp

# Update task with notes
bd update {{TASK_ID}} --note "Findings..."

# Close task
bd close {{TASK_ID}}

# View task details
bd show {{TASK_ID}}
```

---

## Session Resume

When starting a new session:

1. **Check for open epics:**
   ```bash
   bd list --prefix {{PROJECT_PREFIX}} --status open --type epic
   ```

2. **Find current phase:** Look for the most recent open phase epic

3. **Check task status:**
   ```bash
   bd list --parent {{EPIC_ID}} --status open
   ```

4. **Resume:** Work remaining open tasks, then proceed with phase completion

---

## File Output Paths

| Phase | Path |
|-------|------|
| Clarify | `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Environment | `thoughts/shared/environment/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Research | `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Plan | `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Implement | `thoughts/shared/implement/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Handoffs | `thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS-{{BRANCH_NAME}}.md` |

---

## Legacy Commands

HumanLayer-style handoff commands (renamed with `hl_` prefix):
- `hl_create_handoff.md` — Create context handoff document
- `hl_resume_handoff.md` — Resume from handoff document

Use these if beads aren't available or for quick context transfers.

---

## Notes

- **Beads are source of truth** — .md files are human-readable summaries
- **Every task has an owner** — Either you or a sub-agent
- **Phase epics track progress** — Easy to see where you are
- **Tasks contain findings** — Use `bd update` to store research/learnings
- **Dependencies prevent mistakes** — Block tasks that depend on others
- **Files for archaeology** — Future humans can understand what/why
