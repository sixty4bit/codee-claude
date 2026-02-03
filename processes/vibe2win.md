# vibe2win v2 — Multi-Turn Feature Development Process

This is Codee's orchestrated workflow for implementing features across projects.

## Overview

```
CLARIFY → ENVIRONMENT → IDENTIFY → RESEARCH → PLAN → GAP CHECK → FINAL REVIEW → TASKS → IMPLEMENT
```

Each phase has explicit outputs and requires human approval before proceeding.

---

## Artifact Paths

All artifacts follow the `thoughts/shared/` convention:

| Type | Path Pattern |
|------|--------------|
| Research | `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Plans | `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md` |
| Handoffs | `thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS-{{BRANCH_NAME}}.md` |

---

## Phase 1: CLARIFY

**Trigger:** User says `vibe2win: <description>`

**Actions:**
1. Ask clarifying questions about requirements
2. Identify edge cases and constraints
3. Confirm project context (ask if ambiguous)

**Outputs:**
- `{{BRANCH_NAME}}` — kebab-case feature name (e.g., `delete-plannings`)
- One paragraph summary of the feature

**Handoff:** Wait for user approval before proceeding.

---

## Phase 2: CODING ENVIRONMENT

**Actions:**
1. Create worktree and branch:
   ```bash
   git worktree add ~/wt/{{PROJECT_NAME}}/{{BRANCH_NAME}}-wt -b feature/{{BRANCH_NAME}}
   ```
2. Create epic bead:
   ```bash
   bd create "[EPIC] {{FEATURE_SUMMARY}}" --prefix {{PROJECT_PREFIX}} -p 1 -t epic
   ```

**Outputs:**
- Worktree at `~/wt/{{PROJECT_NAME}}/{{BRANCH_NAME}}-wt`
- Epic bead created (e.g., `llapp-a1b2`)

---

## Phase 3: IDENTIFY

**Actions:**
1. Determine which sub-agents/sessions will be needed
2. Consider: research, planning, implementation, testing
3. Note any special requirements (ultrathink for complex logic, etc.)

**Outputs:**
- List of agents/sessions to spawn

---

## Phase 4: RESEARCH

**Actions:**
1. Spawn new session with `research_codebase` command
2. Pass: user description + clarified summary
3. Sub-agent researches codebase, writes findings
4. Commit output to `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`
5. Push branch, create draft PR

**Outputs:**
- Research doc committed
- Draft PR created
- Send user GitHub link to research doc

**Handoff:** User reviews research, provides feedback or approves.

---

## Phase 5: PLAN

**Actions:**
1. Spawn new session with `create_plan` command
2. Pass: path to research doc
3. Sub-agent creates implementation plan
4. Commit output to `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md`
5. Push branch

**Outputs:**
- Plan doc committed
- Plan includes: approach, files to modify, open questions

---

## Phase 6: GAP CHECK

**Actions:**
1. Spawn new session (keep plan session reference)
2. Compare: original request + summary vs plan
3. Identify any missing features or requirements
4. If gaps found: add to "Open Questions" in plan
5. Commit and push

**Outputs:**
- Updated plan with any new questions
- Send user GitHub link to plan

**Handoff:** User answers open questions.

---

## Phase 7: FINAL REVIEW (Loop)

**Actions:**
1. Take user's answers to open questions
2. Update plan in the plan session
3. Commit and push
4. If new questions arise, repeat
5. Continue until plan is complete (no open questions)

**Outputs:**
- Finalized plan doc
- User confirms: "Plan approved"

---

## Phase 8: TASK GENERATION

**Actions:**
1. Parse plan into discrete tasks
2. Create child beads under the epic:
   ```bash
   bd create "{{TASK_TITLE}}" --prefix {{PROJECT_PREFIX}} --parent {{EPIC_ID}}
   ```
3. Set up dependencies between beads

**Outputs:**
- Beads created for each task
- Dependencies configured
- `bd list --prefix {{PROJECT_PREFIX}}` shows the work

---

## Phase 9: IMPLEMENT

**Actions:**
1. Work through `bd ready` (tasks with no blockers)
2. For each ready bead:
   - Spawn sub-agent with `implement_plan` command
   - Pass: plan path + specific task
   - Sub-agent implements, writes tests, commits
3. Close beads as work completes
4. Push commits to branch

**Outputs:**
- Code implemented
- Tests passing
- All beads closed
- PR ready for final review

---

## Handoff Mechanism

Long-running implementations often require context handoffs when:
- Context exceeds 50%
- Session needs to end but work is incomplete
- Switching between major phases

### Creating a Handoff

Use `/create_handoff` command to create a handoff document at:
```
thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS-{{BRANCH_NAME}}.md
```

The handoff captures:
- Current task status
- Recent changes
- Key learnings
- Artifacts produced
- Next steps

### Resuming from Handoff

Use `/resume_handoff` command with either:
- Full path: `/resume_handoff thoughts/shared/handoffs/2026-02-03_14-30-22-feature-name.md`
- Branch name: `/resume_handoff know-show-format-v2` (finds most recent handoff for that branch)

The resume process:
1. Reads handoff completely
2. Reads referenced research/plan docs
3. Validates current state vs handoff state
4. Proposes next actions
5. Gets confirmation before proceeding

---

## Session Resume (Without Handoff)

If a session ends mid-process without a handoff:
1. Check for in-progress epics: `bd list --status open --type epic`
2. Look for recent research/plan docs in `thoughts/shared/`
3. Ask user: "We have an in-progress feature for {{SUMMARY}}. Continue?"

---

## Commands Referenced

These commands should exist in the project's `.claude/commands/`:

| Command | Purpose |
|---------|---------|
| `research_codebase.md` | Investigate codebase for feature implementation |
| `create_plan.md` | Generate implementation plan from research |
| `implement_plan.md` | Execute a specific task from the plan |
| `create_handoff.md` | Create handoff doc when context > 50% or switching |
| `resume_handoff.md` | Resume work from a handoff document |

---

## Notes

- All artifacts live in `thoughts/shared/` with dated filenames
- Beads are prefixed by project (e.g., `llapp-`, `sweeps-`)
- Epic beads track the overall feature; child beads track individual tasks
- Human approval required at: CLARIFY, RESEARCH, PLAN, FINAL REVIEW
- `thoughts/` directories can be cleaned up over time
- Create handoffs proactively to avoid losing context
