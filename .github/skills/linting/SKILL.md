---
name: linting
description: 'Scan a repository for lint issues, apply safe auto-fixes, and verify results. Use when cleaning up style and static-analysis errors before commits/PRs, or when asked to make lint-related fixes.'
---

# Linting Skill

This skill guides agents through a safe, repeatable lint workflow: detect issues, apply targeted fixes, and validate outcomes.

## When to Use This Skill

Use this skill when:
- A repo has lint warnings/errors that should be fixed
- You need a pre-PR hygiene pass
- A task asks to “clean up style” or “fix lint issues”
- CI is failing on lint/static checks

## Operating Principles

- Prefer repo-native commands first (`make lint`, `npm run lint`, `poetry run ruff`, etc.).
- Keep fixes scoped to lint concerns; avoid unrelated refactors.
- Apply auto-fixes when safe, then re-run lint to confirm.
- Preserve behavior; formatting/style should not change runtime logic.
- Report what changed and what remains.

## Workflow

### 1) Discover lint commands

Check in this order:
- `README.md`
- `Makefile`
- package/build config files (`package.json`, `pyproject.toml`, `setup.cfg`, etc.)
- CI workflows (`.github/workflows/*.yml`)

If multiple lint entrypoints exist, prefer the canonical project command (usually `make lint` or CI-equivalent).

### 2) Run lint in report mode

Run lint without fixing first to capture baseline errors.

Collect:
- Files affected
- Rule categories
- Count/severity (if provided)

### 3) Apply fixes safely

Use tool-specific fix flags when available:
- JavaScript/TypeScript: `eslint --fix`, `prettier --write`
- Python: `ruff check --fix`, `ruff format`, `black`, `isort`
- Shell: `shellcheck` (manual fixes), `shfmt -w`
- Go: `gofmt -w`, `go vet` (manual fixes)

Guidelines:
- Fix highest-signal/high-confidence issues first.
- Avoid broad rewrites if a few files are in scope.
- Do not suppress rules globally unless explicitly requested.

### 4) Re-run lint and related checks

After edits:
- Re-run lint until clean or until only non-actionable issues remain.
- Run nearby tests/build checks relevant to touched files when practical.

### 5) Summarize outcome

Provide:
- What was fixed
- What commands were run
- What, if anything, still fails and why
- Recommended follow-up actions

## Guardrails

- Do not introduce new dependencies unless required and explicitly aligned with repo conventions.
- Do not change lint configuration unless asked.
- Do not “fix” unrelated failing tests/build issues outside lint scope.
- If lint output is massive, batch by directory or rule family.

## Handoff Format

Use this format in final handoff:

```markdown
## Linting Results

### Commands Run
- <command 1>
- <command 2>

### Fixes Applied
- <file/area>: <summary>

### Validation
- Lint: <pass/fail>
- Tests/Build (if run): <pass/fail>

### Remaining Issues
- <none / concise list>
```
