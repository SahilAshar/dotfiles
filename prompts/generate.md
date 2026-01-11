# Generate Repo Prompts

You are in a new repository. Your goal is to generate repo-specific prompts and instructions
that make this project easy to understand, test, and deploy.

## Objectives

1. Study the repository deeply (structure, tooling, workflows).
2. Produce repo-tailored prompt files:
   - `prompts/plan.md`
   - `prompts/implement.md`
   - `prompts/test.md`
   - `prompts/deploy.md`
3. Generate or update:
   - `.github/copilot-instructions.md` (or the repo’s existing Copilot instructions file)
   - `.github/instructions/*.instructions.md` when you need scoped, file-type-specific rules
   - `AGENTS.md`

## Method

Use sub-agents to parallelize discovery. Assign clear scopes:
- **Build/Tooling**: detect build system, Makefile targets, package manager, CI.
- **Runtime**: how to run locally (Docker, compose, devcontainers, scripts).
- **Testing**: where tests live, how to run them, fixtures, coverage.
- **Deploy**: deployment configs, environments, scripts, infra folders.

Each sub-agent should report concrete commands and file paths.

## Output Requirements

### 1) Repo summary
Write a concise summary of how the repo is structured and how it runs.

### 2) Prompt files
Create the four prompt files under `prompts/` with instructions tailored to this repo.
Optionally mirror them into `.github/prompts/` if the repo prefers workspace prompt files.
These prompts should:
- Clearly state what the prompt should accomplish and the output format.
- Prefer repo-specific commands (Makefile targets, npm scripts, etc.).
- Reference exact paths and filenames.
- Include Docker guidance only if present.
- Provide minimal, actionable steps.
- Reference Copilot instructions via links instead of duplicating them.

### 3) Instructions files
Create or update the Copilot instructions file and `AGENTS.md`:
- Prefer `.github/copilot-instructions.md` unless the repo already uses a different
  instructions filename (e.g., `CopilotInstructions.md`).
- Seed instructions via VS Code Chat: **Configure Chat** (gear icon) ➜
  **Generate Chat Instructions**, then refine for accuracy.
- Keep instructions short and self-contained (one idea per bullet).
- Use `*.instructions.md` with `applyTo` globs for language/task-specific rules.
- Store project instructions in-repo and reference them from prompt files.

## Prompt Templates

Use the following template for each generated prompt file to ensure consistency:

```
# <Prompt Name>

## Goal
One sentence describing the outcome.

## Inputs
- Required inputs (files, commands, context).
- Optional inputs (env vars, configs).

## Steps
1. Discovery (files/commands to inspect).
2. Action (edits/commands).
3. Validation (tests/checks).

## Output Format
- Bullet list summary.
- Tests run with exact commands and results.
```

### Required outlines

Generate prompts that follow these outlines:

**plan.md**
- Goal: produce a short, ordered plan tailored to this repo.
- Steps: discovery ➜ implementation steps ➜ validation targets.
- Output: numbered plan + explicit command list.

**implement.md**
- Goal: implement a specific feature/change.
- Steps: identify files ➜ minimal edits ➜ run relevant checks.
- Output: summary + tests run + follow-ups.

**test.md**
- Goal: identify and run the best test path for this repo.
- Steps: locate test tooling ➜ run recommended command(s) ➜ interpret results.
- Output: commands to run + success criteria + troubleshooting notes.

**deploy.md**
- Goal: describe how to deploy or run in the target environment(s).
- Steps: locate deploy configs ➜ run deployment/build commands ➜ verify.
- Output: exact commands + environment variables + rollback/teardown notes.

## Guardrails

- Do not assume Docker or Makefile usage unless the repo confirms it.
- Prefer existing repo conventions over generic advice.
- If a workflow is unclear, propose a default and mark it as an assumption.

## Completion Checklist

- [ ] `prompts/plan.md` created with repo-specific planning guidance.
- [ ] `prompts/implement.md` created with repo-specific implementation guidance.
- [ ] `prompts/test.md` created with repo-specific testing guidance.
- [ ] `prompts/deploy.md` created with repo-specific deployment guidance.
- [ ] Copilot instructions file created/updated.
- [ ] Prompt files follow the template and required outlines.
- [ ] `AGENTS.md` created/updated.
