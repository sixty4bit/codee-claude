# vibe2win v2 — Beads-First Feature Development

## Core Principle

**Write everything to a file (or bead) so any session can resume where you left off.**

Each phase creates the next phase's epic and tasks. Commands handle the work and create beads for the following phase. At 55% context, create a handoff document.

---

## Overview

```
CLARIFY → ENVIRONMENT → RESEARCH → PLAN → IMPLEMENT
```

Each phase:
1. Reads the epic/tasks created by the previous phase
2. Executes using the appropriate command
3. Creates the next phase's epic/tasks
4. Writes a summary .md for humans
5. Hands off to user for approval

---

## Phase 1: CLARIFY

**Trigger:** User says `vibe2win: <description>`

**Actions:**
1. Ask clarifying questions about requirements
2. Identify edge cases and constraints
3. Confirm project context (ask if ambiguous)
4. Define `{{BRANCH_NAME}}` — kebab-case feature name

**Outputs:**
- `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md`

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
```

**Create RESEARCH Phase:**
```bash
# Create RESEARCH epic
bd create "[RESEARCH] {{BRANCH_NAME}}" --prefix {{PROJECT_PREFIX}} -t epic

# Create single task: run research_codebase
bd create "Run research_codebase with clarify doc" --prefix {{PROJECT_PREFIX}} --parent {{RESEARCH_EPIC_ID}}
```

**Handoff:** Wait for user approval of clarify doc before proceeding.

---

## Phase 2: ENVIRONMENT

**Actions (no beads needed — just do it):**
1. Create worktree and branch:
   ```bash
   git worktree add ~/wt/{{PROJECT_NAME}}/{{BRANCH_NAME}}-wt -b feature/{{BRANCH_NAME}}
   ```
2. Verify worktree exists
3. Create draft PR and push to GitHub:
   ```bash
   cd ~/wt/{{PROJECT_NAME}}/{{BRANCH_NAME}}-wt
   git commit --allow-empty -m "Start feature/{{BRANCH_NAME}}"
   git push -u origin feature/{{BRANCH_NAME}}
   gh pr create --draft --title "{{BRANCH_NAME}}" --body "WIP"
   ```

**Outputs:**
- Worktree at `~/wt/{{PROJECT_NAME}}/{{BRANCH_NAME}}-wt`
- Draft PR on GitHub

Proceed immediately to RESEARCH phase.

---

## Phase 3: RESEARCH

**Starts with:** RESEARCH epic/task created by CLARIFY phase

**Actions:**
1. Read the RESEARCH epic and its task
2. Run `research_codebase` command with:
   - Path to clarify doc: `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md`
   - RESEARCH epic ID
3. The command handles:
   - Investigating the codebase
   - Writing research findings
   - Creating the research doc
   - Creating PLAN phase epic/tasks

**Outputs (created by research_codebase command):**
- `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`
- `[PLAN] {{BRANCH_NAME}}` epic with tasks

**Handoff:** Commit changes, push branch, send user link to research doc. Wait for approval or changes.

---

## Phase 4: PLAN

**Starts with:** PLAN epic/tasks created by RESEARCH phase

**Actions:**
1. Read the PLAN epic and its tasks
2. Run `create_plan` command with:
   - PLAN epic ID
   - Path to research doc
3. The command handles:
   - Creating tasks for itself to complete (using beads)
   - Identifying which agents should be used for implementation
   - Creating tasks for user to answer if there are questions (these must all be closed before moving forward)
   - Cross-referencing against CLARIFY doc (via sub-agent) to ensure all requirements addressed
   - Creating missing requirement tasks for user verification if needed
   - Creating IMPLEMENT phase epic/tasks:
     - One top-level `[IMPLEMENT] {{BRANCH_NAME}}` epic
     - Child epics/tasks as needed for the implementation
   - Writing the plan doc

**Outputs (created by create_plan command):**
- `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md`
- `[IMPLEMENT] {{BRANCH_NAME}}` epic with child epics/tasks

**Handoff:** Commit changes, push branch, send user link to plan doc. Wait for approval or changes.

---

## Phase 5: IMPLEMENT

**Starts with:** IMPLEMENT epic/tasks created by PLAN phase

**Actions:**
1. Read the IMPLEMENT epic and its tasks
2. Run `implement_plan` command with:
   - IMPLEMENT epic ID
3. The command uses **TDD** (tests before code):
   ```bash
   bd ready --prefix {{PROJECT_PREFIX}}  # Show tasks with no blockers
   ```
4. For each ready task:
   - Spawn sub-agent with task details + plan context
   - Sub-agent writes tests first
   - Sub-agent implements code to pass tests
   - Sub-agent commits
   - Sub-agent closes task
   - Check for newly-unblocked tasks
   - Repeat until all tasks done

**Outputs:**
- `thoughts/shared/implement/YYYY-MM-DD-{{BRANCH_NAME}}.md`
- Code implemented with tests
- All beads closed
- PR ready for final review

---

## Context Management

**At 55% context:**
1. Run `create_handoff` command to create handoff doc
2. Handoff saved to: `thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS-{{BRANCH_NAME}}.md`
3. In new session, run `resume_handoff` with handoff path
4. Continue from where you left off

---

## Commands (Need Updates)

| Command | Current State | Needed Updates |
|---------|---------------|----------------|
| `research_codebase.md` | Exists | Update to use beads, create PLAN epic/tasks |
| `create_plan.md` | Exists | Update to use beads, create own tasks, create IMPLEMENT epic/tasks, cross-reference CLARIFY |
| `implement_plan.md` | Exists | Update to use TDD, read IMPLEMENT epic |
| `create_handoff.md` | Exists (as hl_create_handoff.md) | Rename back or create new |
| `resume_handoff.md` | Exists (as hl_resume_handoff.md) | Rename back or create new |

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

1. **Check for handoffs:**
   ```bash
   ls thoughts/shared/handoffs/*-{{BRANCH_NAME}}.md
   ```
   If exists, run `resume_handoff` with most recent.

2. **Check for open epics:**
   ```bash
   bd list --prefix {{PROJECT_PREFIX}} --status open --type epic
   ```

3. **Find current phase:** Most recent open phase epic

4. **Check task status:**
   ```bash
   bd list --parent {{EPIC_ID}} --status open
   ```

5. **Resume:** Work remaining open tasks

---

## File Output Paths

| Phase | Path |
|-------|------|
| Clarify | `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Research | `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Plan | `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Implement | `thoughts/shared/implement/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Handoffs | `thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS-{{BRANCH_NAME}}.md` |

---

## Notes

- **Beads are source of truth** — .md files are human-readable summaries
- **Each phase creates the next phase's beads** — Chain of responsibility
- **Commands do the heavy lifting** — research_codebase, create_plan, implement_plan
- **TDD in IMPLEMENT** — Tests before code, always
- **55% context threshold** — Create handoff before context overflow
- **User approval gates** — CLARIFY, RESEARCH, PLAN require approval before proceeding
