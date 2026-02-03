---
description: Create implementation plan using beads for task tracking
model: opus
---

# Create Plan

You are tasked with creating detailed implementation plans using beads to track your progress, create tasks for user questions, and set up the IMPLEMENT phase.

## Inputs

This command expects:
1. **PLAN epic ID**: Epic from RESEARCH phase (e.g., `llapp-b2c3`)
2. **Research doc path**: `thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md`
3. **Clarify doc path**: `thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md`
4. **Project prefix**: For beads (e.g., `llapp`, `codee`)

If no epic provided, create one:
```bash
bd create "[PLAN] {{TOPIC}}" --prefix {{PREFIX}} -t epic
```

## Process Overview

Each step becomes a bead task. User questions become `[USER]` tasks that must be closed before proceeding.

## Step 1: Create Plan Task Beads

Create beads for each planning step:

```bash
bd create "Step 1: Read context files" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 2: Initial analysis" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 3: Research & discovery" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 4: Cross-reference requirements" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 5: Plan structure development" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 6: Detailed plan writing" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 7: Create IMPLEMENT beads" --prefix {{PREFIX}} --parent {{EPIC_ID}}
bd create "Step 8: Handoff to user" --prefix {{PREFIX}} --parent {{EPIC_ID}}
```

## Step 2: Read Context Files (Task 1)

**Update bead**: `bd update {{TASK_1_ID}} --note "Reading files..."`

1. Read the PLAN epic and its tasks: `bd show {{PLAN_EPIC_ID}}`
2. Read research doc FULLY (no limit/offset)
3. Read clarify doc FULLY
4. Read any other mentioned files FULLY

**CRITICAL**: Read files yourself before spawning sub-tasks

**Close bead**: `bd close {{TASK_1_ID}}`

## Step 3: Initial Analysis (Task 2)

**Update bead**: `bd update {{TASK_2_ID}} --note "Analyzing..."`

Spawn research sub-agents to gather context:

- **codebase-locator**: Find all files related to the task
- **codebase-analyzer**: Understand current implementation
- **thoughts-locator**: Find existing documents about this area

After sub-agents complete:
1. Read ALL files they identified as relevant
2. Cross-reference requirements with actual code
3. Note assumptions needing verification
4. Determine true scope based on codebase reality

Present informed understanding:
```
Based on my research, I understand we need to [summary].

I've found:
- [Current implementation detail with file:line]
- [Relevant pattern or constraint]
- [Potential complexity identified]

Questions my research couldn't answer:
- [Specific question requiring human judgment]
```

**Close bead**: `bd close {{TASK_2_ID}}`

## Step 4: Research & Discovery (Task 3)

**Update bead**: `bd update {{TASK_3_ID}} --note "Deeper research..."`

If user corrects misunderstandings:
- DO NOT just accept - verify with new research
- Read specific files/directories they mention
- Only proceed once verified

Spawn parallel sub-agents:
- **codebase-locator**: Find more specific files
- **codebase-analyzer**: Understand implementation details
- **codebase-pattern-finder**: Find similar features to model after

**WAIT for ALL sub-agents** before proceeding.

Present findings and design options:
```
Based on research:

**Current State:**
- [Key discovery about existing code]
- [Pattern or convention to follow]

**Design Options:**
1. [Option A] - [pros/cons]
2. [Option B] - [pros/cons]

Which approach aligns best?
```

If questions arise, create `[USER]` beads:
```bash
bd create "[USER] Question: {{QUESTION}}" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
```

**USER beads MUST be closed before proceeding.**

**Close bead**: `bd close {{TASK_3_ID}}`

## Step 5: Cross-Reference Requirements (Task 4)

**Update bead**: `bd update {{TASK_4_ID}} --note "Cross-referencing..."`

**CRITICAL**: Spawn a sub-agent to verify all requirements from CLARIFY doc are addressed.

Sub-agent instructions:
```
Read the clarify doc at {{CLARIFY_PATH}}.
Read the research doc at {{RESEARCH_PATH}}.

For EACH requirement in the clarify doc:
1. Verify it is addressed in the research/plan
2. If NOT addressed, note it as a gap

Return:
- List of requirements and coverage status
- List of any gaps found
```

If gaps found, create user tasks:
```bash
bd create "[USER] Verify not needed: {{GAP}}" --prefix {{PREFIX}} --parent {{PLAN_EPIC_ID}}
```

Present gaps:
```
Found requirements that may not be addressed:

- [ ] {{GAP_1}} — Need your input
- [ ] {{GAP_2}} — Need your input

Please confirm these are intentionally out of scope.
```

**Wait for user. Close [USER] beads as confirmed.**

**Close bead**: `bd close {{TASK_4_ID}}`

## Step 6: Plan Structure Development (Task 5)

**Update bead**: `bd update {{TASK_5_ID}} --note "Developing structure..."`

Create initial plan outline:
```
Here's my proposed plan structure:

## Overview
[1-2 sentence summary]

## Implementation Phases:
1. [Phase name] - [what it accomplishes]
2. [Phase name] - [what it accomplishes]
3. [Phase name] - [what it accomplishes]

Does this phasing make sense?
```

Get feedback on structure before writing details.

**Close bead**: `bd close {{TASK_5_ID}}`

## Step 7: Detailed Plan Writing (Task 6)

**Update bead**: `bd update {{TASK_6_ID}} --note "Writing plan..."`

Write to: `thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md`

```markdown
---
date: [ISO timestamp]
git_commit: [hash]
branch: feature/{{BRANCH_NAME}}
repository: [repo name]
topic: "{{BRANCH_NAME}} Implementation Plan"
status: complete
beads_plan_epic: {{PLAN_EPIC_ID}}
beads_implement_epic: {{IMPLEMENT_EPIC_ID}}
---

# Implementation Plan: {{BRANCH_NAME}}

## Overview
[Brief description]

## Current State Analysis
[From research doc]

## Desired End State
[Specification and verification method]

### Key Discoveries:
- [Finding with file:line]
- [Pattern to follow]
- [Constraint to work within]

## What We're NOT Doing
[Out of scope items]

## Implementation Approach
[High-level strategy]

## Agents Assigned
- model-agent: [tasks]
- controller-agent: [tasks]
- test-agent: [tasks]

## Phase 1: [Name]

### Overview
[What this accomplishes]

### Changes Required:
**File**: `path/to/file.ext`
**Changes**: [Summary]

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `bundle exec rails test`
- [ ] Linting passes: `bundle exec rubocop`

#### Manual Verification:
- [ ] Feature works in UI
- [ ] Edge cases handled

**Pause for manual verification after this phase.**

---

## Phase 2: [Name]
[Similar structure...]

---

## Testing Strategy

### Unit Tests:
- [What to test]

### Integration Tests:
- [Scenarios]

### Manual Testing:
1. [Step to verify]
2. [Edge case to test]

## References
- Clarify: thoughts/shared/clarify/YYYY-MM-DD-{{BRANCH_NAME}}.md
- Research: thoughts/shared/research/YYYY-MM-DD-{{BRANCH_NAME}}.md

## Beads
- PLAN Epic: {{PLAN_EPIC_ID}}
- IMPLEMENT Epic: {{IMPLEMENT_EPIC_ID}}
- Implementation tasks: [list]
```

**Close bead**: `bd close {{TASK_6_ID}}`

## Step 8: Create IMPLEMENT Beads (Task 7)

**Update bead**: `bd update {{TASK_7_ID}} --note "Creating IMPLEMENT phase..."`

Create top-level IMPLEMENT epic:
```bash
bd create "[IMPLEMENT] {{BRANCH_NAME}}" --prefix {{PREFIX}} -t epic
```

Create child epics/tasks based on plan phases:
```bash
# Example structure
bd create "[IMPLEMENT] Database changes" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}} -t epic
bd create "Create migration" --prefix {{PREFIX}} --parent {{DB_EPIC_ID}}
bd create "Update model" --prefix {{PREFIX}} --parent {{DB_EPIC_ID}}

bd create "[IMPLEMENT] Business logic" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}} -t epic
bd create "Add service" --prefix {{PREFIX}} --parent {{LOGIC_EPIC_ID}}

bd create "[IMPLEMENT] Tests" --prefix {{PREFIX}} --parent {{IMPLEMENT_EPIC_ID}} -t epic
bd create "Write unit tests" --prefix {{PREFIX}} --parent {{TEST_EPIC_ID}}
```

Set up dependencies:
```bash
# Tests depend on implementation
bd block {{TEST_TASK_ID}} --on {{IMPL_TASK_ID}}
```

**Close bead**: `bd close {{TASK_7_ID}}`

## Step 9: Handoff to User (Task 8)

**Update bead**: `bd update {{TASK_8_ID}} --note "Preparing handoff..."`

1. Commit changes:
   ```bash
   git add -A
   git commit -m "Plan: {{BRANCH_NAME}}"
   ```

2. Push branch:
   ```bash
   git push
   ```

3. Present to user:
   ```
   Plan complete!

   📄 Plan doc: thoughts/shared/plans/YYYY-MM-DD-{{BRANCH_NAME}}.md

   Implementation structure:
   - [IMPLEMENT] {{BRANCH_NAME}} ({{IMPLEMENT_EPIC_ID}})
     - [IMPLEMENT] Database changes (X tasks)
     - [IMPLEMENT] Business logic (X tasks)
     - [IMPLEMENT] Tests (X tasks)

   Total tasks: {{COUNT}}
   Ready tasks: {{READY_COUNT}} (no blockers)

   Beads completed:
   - PLAN Epic: {{PLAN_EPIC_ID}} (8/8 tasks closed)

   Please review the plan and let me know:
   - Any adjustments needed?
   - Ready to proceed to IMPLEMENT phase?
   ```

**Close bead**: `bd close {{TASK_8_ID}}`

4. Close PLAN epic: `bd close {{PLAN_EPIC_ID}}`

5. Wait for user approval.

## Guidelines

### Be Skeptical
- Question vague requirements
- Identify potential issues early
- Don't assume - verify with code

### Be Interactive
- Don't write full plan in one shot
- Get buy-in at each step
- Allow course corrections

### Be Thorough
- Read all context files COMPLETELY
- Research actual code patterns
- Include specific file paths and line numbers
- Write measurable success criteria

### No Open Questions
- If questions arise, create `[USER]` beads
- Research or ask immediately
- Do NOT write plan with unresolved questions
- Every decision must be made before finalizing

## Context Management

**At 55% context**:
1. Run `create_handoff` command
2. Note current task bead ID
3. In new session, run `resume_handoff`
4. Check `bd list --parent {{EPIC_ID}} --status open`

## Important Notes

- **Beads track everything** - Each step is a task
- **[USER] beads block progress** - Must close before proceeding
- **Cross-reference is mandatory** - Verify all requirements
- **One top-level IMPLEMENT epic** - Can have child epics/tasks
- **Set up dependencies** - Block tasks that depend on others
