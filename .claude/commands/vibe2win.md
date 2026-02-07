# vibe2win.md — Vibe Instructions → Winning Code

*Turn fuzzy ideas into structured specs that produce excellent code.*

---

> ⚠️ **BEADS LOCATION REMINDER**
> 
> All beads are tracked in the **central repo**, not in llapp:
> ```
> /Users/sia/clawd/personas/codee/codee-claude/.beads/
> ```
> Always `cd` to codee-claude before running `bd` commands.

---

## Purpose

When Carl gives a "vibe instruction" (informal, high-level request), use this process to translate it into a structured technical plan before writing any code.

**Don't:** Jump straight to coding from vibes.
**Do:** Clarify → Research → Plan → Implement.

---

## The Full Process (4 Phases)

### Phase 1: CLARIFY

**Goal:** Extract the core intent and document requirements.

1. **Create branch + draft PR immediately:**
   ```bash
   git checkout -b feature/{{BRANCH_NAME}}
   git push -u origin feature/{{BRANCH_NAME}}
   gh pr create --draft --title "{{FEATURE_NAME}}"
   ```

2. **Ask clarifying questions:**
   - What problem are we solving?
   - Who benefits and how?
   - What's the expected user flow?
   - What does "done" look like?

3. **Create CLARIFY epic in beads:**
   ```bash
   cd /Users/sia/clawd/personas/codee/codee-claude
   bd create "[CLARIFY] {{FEATURE_NAME}}" --prefix llapp -t epic
   ```

4. **Write clarify doc:** `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md`
   - Summary of requirements
   - User answers to questions
   - Acceptance criteria
   - Out of scope items

5. **Close CLARIFY epic when done.**

---

### Phase 2: RESEARCH

**Goal:** Understand the codebase and document findings.

**Run the `research_codebase` command:**
```
/research_codebase {{CLARIFY_EPIC_ID}} thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md llapp
```

This command will:
- Create a RESEARCH epic in beads
- Spawn sub-agents to investigate the codebase
- Document current state, patterns, and constraints
- Write research doc: `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`
- Create PLAN phase beads when complete

**Wait for RESEARCH phase to complete before proceeding.**

---

### Phase 3: PLAN

**Goal:** Create detailed implementation plan with success criteria.

**Run the `create_plan` command:**
```
/create_plan {{RESEARCH_EPIC_ID}} thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md llapp
```

This command will:
- Create a PLAN epic in beads
- Cross-reference requirements from CLARIFY
- Develop plan structure interactively
- Write plan doc: `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md`
- Create IMPLEMENT epic with child tasks
- Set up task dependencies

**Wait for PLAN phase to complete before proceeding.**

---

### Phase 4: IMPLEMENT

**Goal:** Execute the plan with TDD.

**Run the `implement_plan` command:**
```
/implement_plan {{IMPLEMENT_EPIC_ID}} thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md llapp
```

This command will:
- Work through IMPLEMENT tasks in dependency order
- Write tests FIRST (TDD)
- Pause for manual verification after each phase
- Update beads as tasks complete
- Push commits and update PR

---

## Quick Reference

| Phase | Epic Type | Command | Output |
|-------|-----------|---------|--------|
| CLARIFY | `[CLARIFY]` | (manual) | `clarify/YYYY-MM-DD-{{BRANCH}}.md` |
| RESEARCH | `[RESEARCH]` | `/research_codebase` | `research/YYYY-MM-DD-{{BRANCH}}.md` |
| PLAN | `[PLAN]` | `/create_plan` | `plans/YYYY-MM-DD-{{BRANCH}}.md` |
| IMPLEMENT | `[IMPLEMENT]` | `/implement_plan` | Working code + tests |

---

## Beads Directory

All beads tracked in central repo:
```
/Users/sia/clawd/personas/codee/codee-claude/.beads/
```

Common commands:
```bash
cd /Users/sia/clawd/personas/codee/codee-claude
bd list                           # List open issues
bd list --parent {{EPIC_ID}}      # List tasks under epic
bd show {{ID}}                    # Show issue details
bd close {{ID}}                   # Close issue
bd create "[USER] Question" ...   # Create blocking question
```

---

## Coding Agent References

| Type | Agent | Key Patterns |
|------|-------|--------------|
| New CRUD feature | `coding/crud-agent.md` | Resources, not custom actions |
| Database changes | `coding/migration-agent.md` | Safe migrations, rollback plan |
| Model logic | `coding/model-agent.md` | Rich models, concerns |
| JavaScript/UI | `coding/stimulus-agent.md` | Small, focused controllers |
| Real-time updates | `coding/turbo-agent.md` | Frames and Streams |
| Background work | `coding/jobs-agent.md` | Delayed jobs |
| Tests | `coding/test-agent.md` | TDD: red → green → refactor |

---

## Critical Rules

1. **Never skip phases** — Each phase builds on the previous
2. **Beads track everything** — Every step is a task
3. **[USER] beads block progress** — Must close before proceeding  
4. **TDD is mandatory** — Tests before code
5. **Manual verification required** — Pause after each implementation phase

---

*Good structure beats fast code. Take 5 minutes to plan, save 5 hours of rework.*
