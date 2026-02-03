# vibe2win v2 — Multi-Turn Feature Development Process

This is Codee's orchestrated workflow for implementing features across projects.

## Overview

```
CLARIFY → ENVIRONMENT → IDENTIFY → RESEARCH → PLAN → GAP CHECK → FINAL REVIEW → TASKS → IMPLEMENT
```

Each phase has explicit outputs and requires human approval before proceeding.

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
2. Create `.vibe/` directory in worktree for artifacts
3. Create epic bead:
   ```bash
   bd create "[EPIC] {{FEATURE_SUMMARY}}" --prefix {{PROJECT_PREFIX}} -p 1 -t epic
   ```
4. Save epic state to `.vibe/epic.yaml`

**Outputs:**
- Worktree at `~/wt/{{PROJECT_NAME}}/{{BRANCH_NAME}}-wt`
- Epic bead created (e.g., `llapp-a1b2`)
- `.vibe/epic.yaml` with bead ID and phase tracking

---

## Phase 3: IDENTIFY

**Actions:**
1. Determine which sub-agents/sessions will be needed
2. Consider: research, planning, implementation, testing
3. Note any special requirements (ultrathink for complex logic, etc.)

**Outputs:**
- List of agents/sessions to spawn
- Documented in `.vibe/agents.md`

---

## Phase 4: RESEARCH

**Actions:**
1. Spawn new session with `research_codebase` command
2. Pass: user description + clarified summary
3. Sub-agent researches codebase, writes findings
4. Commit output to `.vibe/research.md`
5. Push branch, create draft PR

**Outputs:**
- `.vibe/research.md` committed
- Draft PR created
- Send user GitHub link to research doc

**Handoff:** User reviews research, provides feedback or approves.

---

## Phase 5: PLAN

**Actions:**
1. Spawn new session with `create_plan` command
2. Pass: path to `.vibe/research.md`
3. Sub-agent creates implementation plan
4. Commit output to `.vibe/plan.md`
5. Push branch

**Outputs:**
- `.vibe/plan.md` committed
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
- Updated `.vibe/plan.md` with any new questions
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
- Finalized `.vibe/plan.md`
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
4. Update `.vibe/epic.yaml` with child bead IDs

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

## State Tracking

### Epic YAML (`.vibe/epic.yaml`)

```yaml
epic_id: llapp-a1b2
branch: feature/delete-plannings
project: llapp
phase: plan  # clarify|environment|identify|research|plan|gap_check|review|tasks|implement|complete
summary: "Allow users to delete planning meetings with confirmation"
created: 2026-02-03T08:45:00Z
children:
  - llapp-c3d4
  - llapp-e5f6
```

### Session Resume

If a session ends mid-process:
1. Check for in-progress epics: `bd list --status open --type epic`
2. Read `.vibe/epic.yaml` for current phase
3. Ask user: "We have an in-progress feature for {{SUMMARY}}, currently in {{PHASE}} phase. Continue?"

---

## Commands Referenced

These commands should exist in each project's `.claude/commands/`:

| Command | Purpose |
|---------|---------|
| `research_codebase.md` | Investigate codebase for feature implementation |
| `create_plan.md` | Generate implementation plan from research |
| `implement_plan.md` | Execute a specific task from the plan |

---

## Notes

- All artifacts live in the worktree's `.vibe/` directory
- Beads are prefixed by project (e.g., `llapp-`, `sweeps-`)
- Epic beads track the overall feature; child beads track individual tasks
- Human approval required at: CLARIFY, RESEARCH, PLAN, FINAL REVIEW
