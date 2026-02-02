# vibe2win.md — Vibe Instructions → Winning Code

*Turn fuzzy ideas into structured specs that produce excellent code.*

## Purpose

When Carl gives a "vibe instruction" (informal, high-level request), use this process to translate it into a structured technical plan before writing any code.

**Don't:** Jump straight to coding from vibes.
**Do:** Clarify → Structure → Reference agents → Execute.

---

## The Translation Process

### 1. CLARIFY — Extract the Core Intent

Ask yourself (or Carl, if unclear):
- **What problem are we solving?**
- **Who benefits and how?**
- **What's the expected user flow?**
- **What does "done" look like?**

Write a one-sentence summary of the feature.

### 2. IDENTIFY — What Kind of Work Is This?

| Type | Agent to Reference | Key Patterns |
|------|-------------------|--------------|
| New CRUD feature | `coding/crud-agent.md` | Resources, not custom actions |
| Database changes | `coding/migration-agent.md` | Safe migrations, rollback plan |
| Model logic | `coding/model-agent.md` | Rich models, concerns |
| JavaScript/UI | `coding/stimulus-agent.md` | Small, focused controllers |
| Real-time updates | `coding/turbo-agent.md` | Frames and Streams |
| Background work | `coding/jobs-agent.md` | Delayed jobs |
| Performance | `coding/caching-agent.md` | Cache strategies |
| Fixing code | `coding/refactoring-agent.md` | Extract, rename, simplify |
| Tests | `coding/test-agent.md` | TDD: red → green → refactor |

### 3. STRUCTURE — Write the Technical Spec

Create a structured plan with these sections:

```markdown
## Feature: [Name]

### Summary
One sentence describing what we're building.

### User Story
As a [user type], I want [action] so that [benefit].

### Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

### Technical Approach
- **Models:** What models/concerns are involved?
- **Controllers:** What resources (CRUD)?
- **Views:** What templates/partials?
- **Routes:** What URL structure?
- **Tests:** What test cases?

### Agent References
- Primary: [which coding agent]
- Also read: [supporting agents]

### Questions for Carl
- List anything unclear before starting
```

### 4. VALIDATE — Sanity Check

Before coding, confirm:
- [ ] Follows CRUD-everything pattern (no custom actions)?
- [ ] Models have intention-revealing methods?
- [ ] Tests written FIRST (TDD)?
- [ ] No unnecessary services/patterns?
- [ ] Matches existing codebase style?

### 5. EXECUTE — Use Sub-Agents

For implementation:
1. **Spawn a sub-agent** for the actual coding work
2. **Include the structured spec** in the task
3. **Reference the relevant agent files** in instructions
4. **Require tests pass** before PR

---

## Example Translation

### Vibe Input
> "I want users to be able to favorite sweeps"

### Structured Output

```markdown
## Feature: Sweep Favorites

### Summary
Users can favorite sweeps to save them for quick access.

### User Story
As a user, I want to favorite sweeps so that I can quickly find ones I'm interested in.

### Acceptance Criteria
- [ ] User can favorite a sweep from the sweep card
- [ ] User can unfavorite a sweep
- [ ] User can view all their favorites
- [ ] Favorites persist across sessions

### Technical Approach
- **Models:** `Favorite` (user_id, sweep_id), `User` has_many :favorites, `Sweep` has_many :favorites
- **Controllers:** `FavoritesController` (create, destroy, index)
- **Views:** Heart icon on sweep cards, favorites index page
- **Routes:** `/favorites`, `/sweeps/:id/favorites`
- **Tests:** Model tests for associations, controller tests for CRUD, system test for flow

### Agent References
- Primary: crud-agent.md
- Also read: test-agent.md, model-agent.md

### Questions for Carl
- Should favorites be private or visible to others?
- Any limit on number of favorites?
```

---

## Quick Checklist

When you receive a vibe instruction:

1. [ ] Summarize the intent in one sentence
2. [ ] Identify which coding agents apply
3. [ ] Write structured spec with acceptance criteria
4. [ ] List any questions before starting
5. [ ] Spawn sub-agent with spec + agent references
6. [ ] Require passing tests before PR

---

*Good structure beats fast code. Take 5 minutes to plan, save 5 hours of rework.*
