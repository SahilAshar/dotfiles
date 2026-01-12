---
name: plan
description: Create a repo-specific plan
argument-hint: "goal, context, requirements, constraints"
---

# Plan Prompt Template

## Goal
Develop a concrete plan for modifying the dotfiles bootstrapper while keeping installer flows, shell symlinks, and Copilot prompt generation aligned. [README.md](README.md) [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Inputs
- Repo context: Automation is centralized in install.sh, scripts/install-prompts.sh, apt-packages.txt, and the zsh configs the installer links into $HOME. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh) [apt-packages.txt](apt-packages.txt) [zsh/.zshrc](zsh/.zshrc)
- Requirements: Plans must cover edits to shell assets, prompt templates under github/.github/prompts, and the rerun workflow via ./install.sh. [README.md](README.md) [github/.github/prompts/generate.prompt.md](github/.github/prompts/generate.prompt.md)
- Constraints: Installers assume macOS-safe prompt destinations, optional apt-get availability, and idempotent reruns that back up existing dotfiles before relinking. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Steps
1. Inspect install.sh, scripts/install-prompts.sh, and related docs to understand how apt installs, zsh symlinks, and prompt publishing currently behave. [install.sh](install.sh) [docs/prompts.md](docs/prompts.md)
2. Map the blast radius for the requested change, noting which configs, prompt templates, or helper scripts require edits. [github/.github/prompts](github/.github/prompts) [zsh](zsh)
3. Propose an ordered execution plan that sequences edits, validation steps (./install.sh or scripts/install-prompts.sh), and documentation updates. [install.sh](install.sh) [README.md](README.md)
4. Call out risks such as overwriting local dotfiles, missing package managers, or stale prompts, and include mitigations like backups or dry runs. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Output Format
- Summary: Tie the proposed work back to installer automation and prompt syncing so owners understand scope and sequencing. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
- Tasks:
  - Detail file-level edits across install.sh, scripts/install-prompts.sh, and the relevant config or template files. [install.sh](install.sh) [github/.github/prompts](github/.github/prompts)
  - Include verification and follow-up items such as rerunning ./install.sh and reinstalling prompts for future VS Code sessions. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
- Risks/Notes: Document environment caveats (apt-get availability, macOS prompt paths, symlink backups) so reviewers can plan mitigations. [install.sh](install.sh) [README.md](README.md)
- Citations: Reference every file or doc mentioned in the plan output for traceability. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh) [README.md](README.md) [docs/prompts.md](docs/prompts.md) [apt-packages.txt](apt-packages.txt) [zsh/.zshrc](zsh/.zshrc)
