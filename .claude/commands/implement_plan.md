---
description: Implement plan using TDD with beads task tracking
model: opus
---

# Implement Plan

You are tasked with implementing an approved plan using Test-Driven Development (TDD). You will work through beads tasks, spawning sub-agents for each, writing tests before code.

## Inputs

This command expects:
1. **IMPLEMENT epic ID**: The epic created by PLAN phase (e.g., `llapp-c3d4`)
2. **Plan doc path**: `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md`
3. **Project prefix**: For beads (e.g., `llapp`)

## Core Principle: TDD

**Tests are written BEFORE code. Always.**

For every implementation task:
1. Write failing test that defines expected behavior
2. Run test, confirm it fails
3. Write minimal code to make test pass
4. Run test, confirm it passes
5. Refactor if needed
6. Commit

## Process

### Step 1: Read Context

1. Read the IMPLEMENT epic: `bd show {{IMPLEMENT_EPIC_ID}}`
2. List all tasks: `bd list --parent {{IMPLEMENT_EPIC_ID}} --recursive`
3. Read the plan doc FULLY
4. Understand:
   - Implementation phases
   - Task dependencies
   - Success criteria
   - Agent assignments

### Step 2: Find Ready Tasks

```bash
bd ready --prefix {{PREFIX}}
```

This shows tasks with no blockers (dependencies satisfied).

### Step 3: Work Each Ready Task

For each ready task:

#### 3a. Read Task Details

```bash
bd show {{TASK_ID}}
```

Understand:
- What needs to be implemented
- Which files to modify
- Success criteria from plan

#### 3b. Spawn Sub-Agent

Spawn a sub-agent with:

```
## Task
{{TASK_TITLE}}

## Context
Plan: {{PLAN_PATH}}
Task ID: {{TASK_ID}}
Branch: feature/{{BRANCH_NAME}}

## Working Directory
{{WORKTREE_PATH}}

## Instructions

You MUST use TDD (Test-Driven Development):

1. **Write Test First**
   - Create/update test file
   - Write test that defines expected behavior
   - Test MUST fail initially (red)

2. **Run Test**
   ```bash
   # Rails example
   bundle exec rails test test/path/to/test.rb
   ```
   - Confirm test fails with expected error
   - If test passes, your test is wrong

3. **Write Implementation**
   - Write minimal code to make test pass
   - No more than needed

4. **Run Test Again**
   - Confirm test passes (green)
   - If still failing, fix implementation

5. **Refactor (if needed)**
   - Clean up code
   - Run tests again to confirm still passing

6. **Commit**
   ```bash
   git add -A
   git commit -m "{{TASK_TITLE}}"
   ```

7. **Close Bead**
   ```bash
   bd update {{TASK_ID}} --note "Implemented with TDD. Commit: $(git rev-parse --short HEAD)"
   bd close {{TASK_ID}}
   ```

## Success Criteria
[From plan for this task]

## Files to Modify
[From plan]

## DO NOT
- Write code before tests
- Skip the failing test step
- Commit without tests passing
```

#### 3c. Wait for Sub-Agent

Wait for sub-agent to complete. Verify:
- Task bead is closed
- Commit was made
- Tests are passing

#### 3d. Check for Newly-Unblocked Tasks

```bash
bd ready --prefix {{PREFIX}}
```

Tasks that were blocked on the completed task are now ready.

### Step 4: Repeat Until Done

Continue working ready tasks until all tasks are closed:

```bash
bd list --parent {{IMPLEMENT_EPIC_ID}} --status open --recursive
```

When this returns empty, implementation is complete.

### Step 5: Final Verification

Run full test suite:
```bash
# Rails
bundle exec rails test

# Run linter
bundle exec rubocop
```

All must pass.

### Step 6: Write Implementation Summary

Write to: `thoughts/shared/implement/YYYY-MM-DD-{{BRANCH_NAME}}.md`

```markdown
---
date: [ISO timestamp]
git_commit: [current commit hash]
branch: feature/{{BRANCH_NAME}}
repository: [repo name]
topic: "{{BRANCH_NAME}} Implementation"
status: complete
---

# Implementation: {{BRANCH_NAME}}

## Summary
[Brief description of what was implemented]

## Completed Tasks

### Phase 1: [Name]
- {{TASK_1}}: [description] — commit {{HASH}}
- {{TASK_2}}: [description] — commit {{HASH}}

### Phase 2: [Name]
...

## Changes Made
- `path/to/file1.rb` — [what changed]
- `path/to/file2.rb` — [what changed]

## Tests Added
- `test/path/to/test1.rb` — [what it tests]
- `test/path/to/test2.rb` — [what it tests]

## Verification
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Linter passes
- [ ] Manual testing checklist (for user)

## Beads
- IMPLEMENT Epic: {{IMPLEMENT_EPIC_ID}}
- Total tasks completed: {{COUNT}}
- All tasks: {{TASK_IDS_WITH_COMMITS}}

## PR Ready
Branch: feature/{{BRANCH_NAME}}
Tests passing: ✓
```

### Step 7: Close IMPLEMENT Epic

```bash
bd close {{IMPLEMENT_EPIC_ID}}
```

### Step 8: Handoff

1. Commit summary: `git add -A && git commit -m "Implementation complete: {{BRANCH_NAME}}"`
2. Push branch: `git push`
3. Update PR description
4. Present to user:

```
Implementation complete! 🎉

📄 Summary: thoughts/shared/implement/YYYY-MM-DD-{{BRANCH_NAME}}.md

Completed:
- {{TASK_COUNT}} tasks implemented
- {{TEST_COUNT}} tests added
- All tests passing ✓
- Linter passing ✓

Manual verification needed:
- [ ] [Manual test 1 from plan]
- [ ] [Manual test 2 from plan]

PR ready for review: {{PR_URL}}
```

## Context Management

**At 55% context**: 
1. Note which tasks are complete and which are remaining
2. Run `create_handoff` command
3. In new session, run `resume_handoff`
4. Check `bd ready` to continue

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
2. Verify blocker is actually closed
3. If dependency issue, fix with `bd unblock`

### Sub-Agent Fails
1. Check sub-agent output
2. If code issue, spawn new sub-agent with more context
3. If fundamental problem, escalate to user

## Important Notes

- **TDD is mandatory** — Tests before code, always
- **One task at a time** — Complete before starting next
- **Commit per task** — Atomic, reviewable commits
- **Close beads** — Keeps state accurate
- **Check ready tasks** — Dependencies auto-unblock
- **Full test suite at end** — Catch any regressions
