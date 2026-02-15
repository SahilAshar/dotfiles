---
name: style-lint
description: 'Run a style-focused lint pass using repository conventions (clarity, naming, function boundaries, scope discipline, and safe refactor patterns). Use when asked for readability/style cleanup that may not be captured by static linters.'
---

# Style Lint Skill

This skill performs a **style-guideline lint pass** based on repository conventions, not just tool output.

Use this when you want code to be:
- surgical and minimal,
- clear to read,
- separated by concern,
- consistent with repo patterns,
- safe and idempotent for install/runtime scripts.

## When to Use

Use this skill when:
- A request says “clean this up,” “make it clearer,” or “align with repo style”
- Code works but is harder to understand than necessary
- A PR needs a readability/style pass before merge
- Static lint passes, but style quality is still inconsistent

## Style Lint Rubric

Evaluate changes against this checklist.

### 1) Scope Discipline
- Implement only what the request requires
- Avoid unrelated cleanup and broad rewrites
- Keep diffs small and reviewable

### 2) Separation of Concerns
- Prefer small, single-purpose functions
- Extract shared behavior into a general helper when duplication exists
- Keep context-specific wrappers thin and explicit

### 3) Naming Clarity
- Use names that describe intent and role, not implementation trivia
- Prefer explicit names over abbreviations
- Avoid one-letter names unless strongly conventional

### 4) Control Flow Readability
- Keep conditionals straightforward
- Avoid deep nesting when early returns can simplify flow
- Keep error paths actionable and close to failure checks

### 5) Behavioral Safety
- Preserve existing behavior unless explicitly requested to change it
- Maintain idempotency for installer/bootstrap logic
- Keep backup/fail-fast protections intact

### 6) Test Alignment
- Update tests when behavior or contracts change
- Ensure tests match current function names and wiring
- Validate changed paths with focused checks first

## Workflow

1. Identify the style contract
   - Read root AGENTS guidance and local conventions.
2. Scan for style smells
   - Duplication, unclear naming, mixed responsibilities, noisy diffs.
3. Propose minimal structural change
   - Prefer helper + thin wrapper if it improves clarity.
4. Apply surgical edits
   - No unrelated formatting churn.
5. Verify
   - Run relevant tests/lint and confirm no behavior regressions.
6. Report
   - Summarize what was improved and why, in style terms.

## Style Smells and Preferred Fixes

- Repeated file-linking logic in multiple places
  - Fix: extract a generic linker helper; keep home-specific wrapper.
- Function doing setup + validation + orchestration all together
  - Fix: split into composable helpers with clear boundaries.
- Generic variable names (`data`, `value`, `obj`) in critical paths
  - Fix: rename to domain-specific intent names.
- Static checks green but PR is hard to review
  - Fix: reduce diff scope, isolate behavior changes, simplify control flow.

## Guardrails

- Do not introduce new abstractions unless they reduce real complexity.
- Do not change public behavior just for stylistic preference.
- Do not add inline comments unless requested; prefer self-explanatory code.
- Do not weaken safety checks for convenience.

## Handoff Format

Use this handoff structure:

```markdown
## Style Lint Results

### Improvements Made
- <area>: <what changed>

### Style Rules Applied
- <scope discipline / separation / naming / etc>

### Behavioral Safety
- <why behavior is preserved>

### Validation
- <tests/lint run and outcome>

### Remaining Suggestions
- <optional, non-blocking>
```
