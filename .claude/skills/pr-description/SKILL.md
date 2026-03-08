---
name: pr-description
description: 'Generate structured PR descriptions from git diffs. Use when the user asks to write a PR description, is about to open a PR, or wants help summarizing changes for review.'
---

# PR Description Writer

Generate copy-paste-ready pull request descriptions by analyzing git diffs and commit history.

## When to Use

- User asks to write a PR description
- User is about to open a PR
- User wants help summarizing changes for code review

## Process

### 1. Gather Context

```bash
# Get the diff against the base branch
git diff main...HEAD

# Get commit history on this branch
git log main..HEAD --oneline

# Identify files changed
git diff main...HEAD --stat
```

If the base branch isn't `main`, ask the user or infer from context.

### 2. Analyze the Changes

- **What changed**: Files modified, added, deleted
- **Why it changed**: Infer intent from commit messages, code patterns, and context
- **How it changed**: Key implementation details reviewers need to understand
- **What's risky**: Areas that need careful review

### 3. Generate the Description

Use this structure:

```markdown
## Summary

<1-3 sentences: what this PR does and why>

## Changes

- <Grouped by logical unit, not by file>
- <Each bullet describes a meaningful change, not just "updated foo.ts">
- <Call out architectural decisions or trade-offs>

## Testing

- <How was this tested?>
- <What should reviewers verify?>
- <Any manual testing steps needed?>

## Review Notes

- <Areas that need careful review>
- <Known limitations or follow-up work>
- <Breaking changes, if any>
```

## Guidelines

**DO**:
- Group changes by logical concern, not by file
- Explain *why*, not just *what* — the diff already shows what
- Flag breaking changes prominently
- Note what tests were added or updated
- Keep it scannable — reviewers are busy

**DON'T**:
- List every file changed (that's what the diff is for)
- Write a novel — aim for 30 seconds to read
- Include implementation details the code already shows
- Omit context that only exists in your head

## Adapting to Repo Conventions

Before generating, check for:
- Existing PR templates (`.github/PULL_REQUEST_TEMPLATE.md`)
- PR description conventions in recent merged PRs
- Required sections (e.g., Jira ticket links, test evidence)

Match the repo's existing style rather than imposing this template rigidly.

## Title Conventions

- Keep under 70 characters
- Use imperative mood: "Add feature" not "Added feature"
- Prefix with type if the repo uses conventional commits: `feat:`, `fix:`, `refactor:`
- Be specific: "Add retry logic to API client" not "Update API client"
