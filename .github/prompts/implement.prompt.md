---
name: implement
description: Implement a requested change with file-level details
argument-hint: "goal, targets, behavior, criteria, steps, tests"
---

# Implement Prompt Template

## Goal
Implement the requested change by editing the dotfiles automation while keeping installer and prompt workflows intact. [install.sh](install.sh#L7-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L1-L85)

## Inputs
- Target files/modules: Focus on install.sh, scripts/install-prompts.sh, and any linked shell configs the installer manages. [install.sh](install.sh#L104-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)
- Existing behavior: The installer symlinks zsh configs, installs apt packages, and refreshes Copilot prompts on completion. [install.sh](install.sh#L16-L148) [apt-packages.txt](apt-packages.txt#L1-L4)
- Acceptance criteria: Changes must preserve repeatable installs, update prompts where needed, and succeed when running scripts/install-prompts.sh afterward. [README.md](README.md#L5-L30) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)

## Steps
1. Inspect the current scripts and configs to confirm assumptions and locate precise edit points. [install.sh](install.sh#L7-L148) [zsh/.zshrc](zsh/.zshrc)
2. Apply scoped modifications with minimal disruption to existing install flows and symlink logic. [install.sh](install.sh#L104-L148)
3. Update related assets, such as prompt templates or documentation, to reflect the new behavior. [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85) [docs/prompts.md](docs/prompts.md#L11-L46)
4. Validate by running the relevant installers or checks and confirming outputs align with expectations. [install.sh](install.sh#L130-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)

## Output Format
- Summary: Note the implemented updates and how they affect installer and prompt behaviors. [install.sh](install.sh#L7-L148)
- Changes:
  - Describe edits to install.sh or companion scripts, highlighting logic updates. [install.sh](install.sh#L104-L148)
  - Capture documentation or prompt changes needed to keep guidance current. [docs/prompts.md](docs/prompts.md#L11-L46)
- Tests/Checks:
  - Run scripts/install-prompts.sh (or install.sh if broader) and report the outcome. [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85) [install.sh](install.sh#L146-L148)
- Citations: Include links to every file or command referenced in the implementation summary. [install.sh](install.sh#L7-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L1-L85) [docs/prompts.md](docs/prompts.md#L11-L46) [zsh/.zshrc](zsh/.zshrc) [apt-packages.txt](apt-packages.txt#L1-L4)
