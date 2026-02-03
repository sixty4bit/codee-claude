---
description: Implement plan using TDD with beads task tracking
model: opus
---

# Implement Plan

You are tasked with implementing an approved plan using Test-Driven Development (TDD). Each task is tracked as a bead. Tests are written BEFORE code.

## Inputs

This command expects:
1. **IMPLEMENT epic ID**: Epic from PLAN phase (e.g., `llapp-c3d4`)
2. **Plan doc path**: `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md`
3. **Project prefix**: For beads (e.g., `llapp`, `codee`)

## Core Principle: TDD

**Tests are written BEFORE code. Always.**

For every implementation task:
1. Write failing test that defines expected behavior
2. Run test, confirm it fails (RED)
3. Write minimal code to make test pass
4. Run test, confirm it passes (GREEN)
5. Refactor if needed
6. Commit

## Process Overview

The IMPLEMENT epic should already have child epics and tasks from the PLAN phase. Your job is to work through them using TDD.

## Step 1: Read Context

1. Read the IMPLEMENT epic:
   ```bash
   bd show {{IMPLEMENT_EPIC_ID}}
   ```

2. List all tasks recursively:
   ```bash
   bd list --parent {{IMPLEMENT_EPIC_ID}} --recursive
   ```

3. Read the plan doc FULLY (no limit/offset)

4. Understand:
   - Implementation phases
   - Task dependencies
   - Success criteria
   - Agent assignments

## Step 2: Create Progress Tracking Beads

Create meta-tasks to track overall progress:

```bash
bd create "Step 1: Setup and context" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}}
bd create "Step 2: TDD implementation loop" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}}
bd create "Step 3: Final verification" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}}
bd create "Step 4: Write summary" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}}
bd create "Step 5: Handoff" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}}
```

## Step 3: Find Ready Tasks

```bash
bd ready --prefix {{PREFIX}}
```

This shows tasks with no blockers (dependencies satisfied).

If `bd ready` doesn't work with prefix, use:
```bash
bd list --parent {{IMPLEMENT_EPIC_ID}} --status open | head -20
```

## Step 4: TDD Implementation Loop (Main Work)

**Update bead**: `bd update {{STEP_2_ID}} --note "Starting TDD loop..."`

For each ready implementation task:

### 4a. Read Task Details

```bash
bd show {{TASK_ID}}
```

Understand:
- What needs to be implemented
- Which files to modify
- Success criteria from plan

### 4b. Spawn TDD Sub-Agent

Spawn a sub-agent for each task:

```
## Task
{{TASK_TITLE}} (Bead: {{TASK_ID}})

## Context
- Plan: {{PLAN_PATH}}
- Working directory: {{WORKTREE_PATH}}
- Branch: feature/{{BRANCH_NAME}}

## TDD Instructions (MANDATORY)

You MUST follow TDD. Tests come FIRST.

### Phase 1: RED (Write Failing Test)

1. Identify what behavior to test
2. Create/update test file
3. Write test that asserts expected behavior
4. Run test:
   ```bash
   bundle exec rails test test/path/to/test.rb
   ```
5. **Confirm test FAILS** with expected error
6. If test passes, YOUR TEST IS WRONG - fix it

### Phase 2: GREEN (Make Test Pass)

1. Write MINIMAL code to make test pass
2. No more than needed
3. Run test again:
   ```bash
   bundle exec rails test test/path/to/test.rb
   ```
4. **Confirm test PASSES**
5. If still failing, fix implementation

### Phase 3: REFACTOR (Clean Up)

1. Improve code quality if needed
2. Run tests again to confirm still passing
3. Run linter:
   ```bash
   bundle exec rubocop --autocorrect
   ```

### Phase 4: COMMIT

```bash
git add -A
git commit -m "{{TASK_TITLE}}"
```

### Phase 5: CLOSE BEAD

```bash
bd update {{TASK_ID}} --note "TDD complete. Commit: $(git rev-parse --short HEAD)"
bd close {{TASK_ID}}
```

## Success Criteria
[From plan for this task]

## Files to Modify
[From plan]

## DO NOT
- Write code before tests
- Skip the RED phase
- Commit without tests passing
- Close bead without committing
```

### 4c. Wait for Sub-Agent

Wait for sub-agent to complete. Verify:
- Task bead is closed
- Commit was made
- Tests are passing

### 4d. Check for Newly-Ready Tasks

```bash
bd ready --prefix {{PREFIX}}
```

Tasks blocked on the completed task are now ready.

### 4e. Repeat

Continue until all implementation tasks are closed:

```bash
bd list --parent {{IMPLEMENT_EPIC_ID}} --status open --recursive
```

When empty (only meta-tasks remain), implementation is complete.

**Close bead**: `bd close {{STEP_2_ID}}`

## Step 5: Final Verification (Task 3)

**Update bead**: `bd update {{STEP_3_ID}} --note "Final verification..."`

Run full test suite:
```bash
bundle exec rails test
```

Run linter:
```bash
bundle exec rubocop
```

All must pass.

**Close bead**: `bd close {{STEP_3_ID}}`

## Step 6: Write Implementation Summary (Task 4)

**Update bead**: `bd update {{STEP_4_ID}} --note "Writing summary..."`

Write to: `thoughts/shared/implement/YYYY-MM-DD-{{BRANCH_NAME}}.md`

```markdown
---
date: [ISO timestamp]
git_commit: [current hash]
branch: feature/{{BRANCH_NAME}}
repository: [repo name]
topic: "{{BRANCH_NAME}} Implementation"
status: complete
beads_epic: {{IMPLEMENT_EPIC_ID}}
---

# Implementation: {{BRANCH_NAME}}

## Summary
[Brief description of what was implemented]

## TDD Approach
All code was implemented using Test-Driven Development:
- Tests written first (RED)
- Minimal code to pass (GREEN)
- Refactored as needed

## Completed Tasks

### Phase 1: [Name]
| Task | Bead | Commit |
|------|------|--------|
| {{TASK_1}} | {{BEAD_ID}} | {{HASH}} |
| {{TASK_2}} | {{BEAD_ID}} | {{HASH}} |

### Phase 2: [Name]
...

## Changes Made
- `path/to/file1.rb` — [what changed]
- `path/to/file2.rb` — [what changed]

## Tests Added
- `test/path/to/test1.rb` — [what it tests]
- `test/path/to/test2.rb` — [what it tests]

## Verification
- [x] All unit tests pass
- [x] Linter passes
- [ ] Manual testing (for user)

## Beads Summary
- IMPLEMENT Epic: {{IMPLEMENT_EPIC_ID}}
- Total tasks: {{COUNT}}
- All tasks closed: ✓

## PR Ready
- Branch: feature/{{BRANCH_NAME}}
- Tests: ✓
- Linter: ✓
```

**Close bead**: `bd close {{STEP_4_ID}}`

## Step 7: Handoff (Task 5)

**Update bead**: `bd update {{STEP_5_ID}} --note "Handoff..."`

1. Commit summary:
   ```bash
   git add -A
   git commit -m "Implementation complete: {{BRANCH_NAME}}"
   ```

2. Push:
   ```bash
   git push
   ```

3. Update PR if needed

4. Present to user:
   ```
   Implementation complete! 🎉

   📄 Summary: thoughts/shared/implement/YYYY-MM-DD-{{BRANCH_NAME}}.md

   Completed:
   - {{TASK_COUNT}} tasks implemented with TDD
   - {{TEST_COUNT}} tests added
   - All tests passing ✓
   - Linter passing ✓

   Manual verification needed:
   - [ ] [Manual test 1 from plan]
   - [ ] [Manual test 2 from plan]

   Beads:
   - IMPLEMENT Epic: {{IMPLEMENT_EPIC_ID}} — CLOSED
   - All child tasks: CLOSED

   PR ready for review.
   ```

**Close bead**: `bd close {{STEP_5_ID}}`

5. Close IMPLEMENT epic: `bd close {{IMPLEMENT_EPIC_ID}}`

## Error Handling

### Test Won't Pass
1. Check if test is correct
2. Check if implementation matches plan
3. If plan is wrong, create user task:
   ```bash
   bd create "[USER] Plan issue: {{DESCRIPTION}}" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}}
   ```
4. Wait for user input

### Blocked Task Won't Unblock
1. Check dependencies: `bd show {{TASK_ID}}`
2. Verify blocker is closed
3. If dependency issue, fix with `bd unblock`

### Sub-Agent Fails
1. Check sub-agent output
2. Spawn new sub-agent with more context
3. If fundamental problem, escalate to user

## Context Management

**At 55% context**:
1. Note which tasks are complete (check beads)
2. Run `create_handoff` command
3. In new session, run `resume_handoff`
4. Check `bd list --parent {{EPIC_ID}} --status open`
5. Run `bd ready` to continue

## Important Notes

- **TDD is mandatory** — Tests before code, always
- **RED-GREEN-REFACTOR** — Follow the cycle
- **One task at a time** — Complete before starting next
- **Commit per task** — Atomic, reviewable commits
- **Close beads** — Shows progress, enables resume
- **Check ready tasks** — Dependencies auto-unblock
- **Full test suite at end** — Catch any regressions
