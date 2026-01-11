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
   - `copilot-instructions.md` (or the repo’s existing Copilot instructions file)
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
These prompts should:
- Prefer repo-specific commands (Makefile targets, npm scripts, etc.).
- Reference exact paths and filenames.
- Include Docker guidance only if present.
- Provide minimal, actionable steps.

### 3) Instructions files
Create or update the Copilot instructions file and `AGENTS.md`:
- Prefer `.github/copilot-instructions.md` unless the repo already uses a different
  instructions filename (e.g., `CopilotInstructions.md`).
- If VS Code supports it, run **“Copilot: Generate Instructions”** from the Command Palette
  to seed the file, then refine it for accuracy.
- Keep instructions short, concrete, and repo-specific (commands, paths, naming).
- Include testing expectations, setup requirements, and preferred commands.
- Avoid long prose; use bullets and examples.

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
- [ ] `AGENTS.md` created/updated.
