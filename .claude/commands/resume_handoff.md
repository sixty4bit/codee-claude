---
description: Resume work from handoff document with context analysis and validation
---

# Resume Work from a Handoff Document

You are tasked with resuming work from a handoff document through an interactive process. These handoffs contain critical context, learnings, and next steps from previous work sessions that need to be understood and continued.

## Initial Response

When this command is invoked:

1. **If a handoff document path was provided**:
   - Immediately read the handoff document FULLY
   - Immediately read any research or plan documents it links to under `thoughts/shared/plans/` or `thoughts/shared/research/`
   - Do NOT use a sub-agent to read these critical files
   - Begin the analysis process by ingesting relevant context, reading additional files mentioned
   - Propose a course of action to the user and confirm, or ask for clarification

2. **If a branch name was provided** (e.g., `know-show-format-v2`):
   - Look in `thoughts/shared/handoffs/` for files matching `*-{{BRANCH_NAME}}.md`
   - If multiple files exist, use the most recent one (based on date/time in filename)
   - If no files found, tell the user and ask for the path
   - Proceed as above with the found handoff

3. **If no parameters provided**, respond with:
   ```
   I'll help you resume work from a handoff document.
   
   Please provide either:
   - A path to the handoff file: `/resume_handoff thoughts/shared/handoffs/2026-02-03_14-30-22-feature-name.md`
   - A branch name: `/resume_handoff know-show-format-v2`
   ```

## Process Steps

### Step 1: Read and Analyze Handoff

1. **Read handoff document completely** (no limit/offset parameters)
2. **Extract all sections**: Tasks, Recent changes, Learnings, Artifacts, Action items, Notes
3. **Read critical files identified**: Files from "Learnings" section, files from "Recent changes", any new related files

### Step 2: Synthesize and Present Analysis

Present comprehensive analysis:

```
I've analyzed the handoff from [date]. Here's the current situation:

**Original Tasks:**
- [Task 1]: [Status from handoff] → [Current verification]
- [Task 2]: [Status from handoff] → [Current verification]

**Key Learnings Validated:**
- [Learning with file:line reference] - [Still valid/Changed]
- [Pattern discovered] - [Still applicable/Modified]

**Recent Changes Status:**
- [Change 1] - [Verified present/Missing/Modified]
- [Change 2] - [Verified present/Missing/Modified]

**Artifacts Reviewed:**
- [Document 1]: [Key takeaway]
- [Document 2]: [Key takeaway]

**Recommended Next Actions:**
Based on the handoff's action items and current state:
1. [Most logical next step]
2. [Second priority action]
3. [Additional tasks discovered]

**Potential Issues Identified:**
- [Any conflicts or regressions found]
- [Missing dependencies or broken code]

Shall I proceed with [recommended action 1], or would you like to adjust the approach?
```

Get confirmation before proceeding.

### Step 3: Begin Implementation

1. Start with the first approved task
2. Reference learnings from handoff throughout implementation
3. Apply patterns and approaches documented
4. Update progress as tasks are completed

## Guidelines

1. **Be Thorough in Analysis**: Read the entire handoff, verify mentioned changes still exist, check for regressions
2. **Be Interactive**: Present findings before starting work, get buy-in, allow course corrections
3. **Leverage Handoff Wisdom**: Pay special attention to "Learnings", apply documented patterns, avoid repeating mistakes
4. **Validate Before Acting**: Never assume handoff state matches current state, verify file references exist

## Common Scenarios

### Clean Continuation
- All changes from handoff are present
- No conflicts or regressions
- Clear next steps in action items
- Proceed with recommended actions

### Diverged Codebase
- Some changes missing or modified
- New related code added since handoff
- Need to reconcile differences
- Adapt plan based on current state

### Stale Handoff
- Significant time has passed
- Major refactoring has occurred
- Original approach may no longer apply
- Need to re-evaluate strategy
