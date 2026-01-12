---
name: implement
description: Implement a requested change with file-level details
argument-hint: "goal, targets, behavior, criteria, steps, tests"
---

# Implement Prompt Template

## Goal
Implement the requested change across the dotfiles automation without regressing installer idempotency, shell symlinks, or Copilot prompt sync. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Inputs
- Target files/modules: Expect to edit install.sh, scripts/install-prompts.sh, apt-packages.txt, and any configs or templates mentioned in the request. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh) [apt-packages.txt](apt-packages.txt) [github/.github/prompts](github/.github/prompts)
- Existing behavior: ./install.sh installs apt dependencies when available, links zsh configs, fetches Powerlevel10k + zsh-autosuggestions, and finishes by running scripts/install-prompts.sh. [install.sh](install.sh) [zsh/.zshrc](zsh/.zshrc)
- Acceptance criteria: The change must remain rerunnable, keep prompt templates current, and document any new flags or files referenced by the installer. [README.md](README.md) [docs/prompts.md](docs/prompts.md)

## Steps
1. Inspect the affected files to confirm current behavior, default variables (DOTFILES_DIR, COPILOT_PROMPTS_DIR), and guardrails like backups. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
2. Apply minimal, well-commented edits that preserve safety checks (e.g., apt-get detection, symlink backups, mkdir -p for prompt destinations). [install.sh](install.sh)
3. Update supporting assets—prompt templates, docs, or shell configs—so guidance matches the new behavior. [docs/prompts.md](docs/prompts.md) [github/.github/prompts](github/.github/prompts)
4. Validate by running ./install.sh (or targeted helpers) locally, capturing output that proves prompts were redeployed and symlinks refreshed. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Output Format
- Summary: Explain the functional change, touched files, and observable differences in installer or prompt flows. [install.sh](install.sh)
- Changes:
  - Describe code edits across install.sh, scripts/install-prompts.sh, and related configs/templates. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
  - Note doc or prompt template updates that keep instructions aligned with the new workflow. [docs/prompts.md](docs/prompts.md) [github/.github/prompts](github/.github/prompts)
- Tests/Checks:
  - Document ./install.sh or scripts/install-prompts.sh runs (with env overrides if used) plus any verification commands. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
- Citations: Link to every file or command referenced in the implementation summary for traceability. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh) [docs/prompts.md](docs/prompts.md) [apt-packages.txt](apt-packages.txt) [zsh/.zshrc](zsh/.zshrc)
