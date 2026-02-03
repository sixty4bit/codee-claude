---
description: Create handoff document for transferring work to another session
---

# Create Handoff

You are tasked with writing a handoff document to hand off your work to another agent in a new session. You will create a handoff document that is thorough, but also **concise**. The goal is to compact and summarize your context without losing any of the key details of what you're working on.

## Process

### 1. Filepath & Metadata

Create your file under `thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS-{{BRANCH_NAME}}.md`, where:
- YYYY-MM-DD is today's date
- HH-MM-SS is the hours, minutes and seconds based on the current time, in 24-hour format
- {{BRANCH_NAME}} is the feature branch name in kebab-case

Example: `thoughts/shared/handoffs/2026-02-03_14-30-22-know-show-format-v2.md`

### 2. Handoff Writing

Use the following template structure:

```markdown
---
date: [Current date and time with timezone in ISO format]
git_commit: [Current commit hash]
branch: [Current branch name]
repository: [Repository name]
topic: "[Feature/Task Name] Implementation"
tags: [implementation, relevant-component-names]
status: in_progress
last_updated: [Current date in YYYY-MM-DD format]
type: handoff
---

# Handoff: {{BRANCH_NAME}}

## Task(s)
{Description of the task(s) you were working on, along with the status of each (completed, work in progress, planned/discussed). If working on an implementation plan, call out which phase you're on. Reference the plan and/or research documents provided at the beginning of the session.}

## Critical References
{List any critical specification documents, architectural decisions, or design docs that must be followed. Include only 2-3 most important file paths. Leave blank if none.}

## Recent Changes
{Describe recent changes made to the codebase in file:line syntax}

## Learnings
{Describe important things you learned - patterns, root causes of bugs, or other important information someone picking up your work should know. Include explicit file paths.}

## Artifacts
{Exhaustive list of artifacts you produced or updated as filepaths and/or file:line references - paths to research docs, plans, etc that should be read to resume work.}

## Action Items & Next Steps
{List of action items and next steps for the next agent to accomplish based on your tasks and their statuses}

## Other Notes
{Other notes, references, or useful information - where relevant sections of the codebase are, where relevant documents are, or other important things you learned that don't fall into the above categories}
```

### 3. Commit and Respond

Commit the handoff document to the branch.

Once completed, respond to the user:

```
Handoff created! You can resume from this handoff in a new session with:

/resume_handoff thoughts/shared/handoffs/[filename].md
```

## Additional Notes & Instructions

- **More information, not less.** This template defines the minimum. Always include more information if necessary.
- **Be thorough and precise.** Include both top-level objectives and lower-level details as necessary.
- **Avoid excessive code snippets.** While brief snippets for key changes are fine, avoid large code blocks or diffs. Prefer using `file:line` references that an agent can follow later.
