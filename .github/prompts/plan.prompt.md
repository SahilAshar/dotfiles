---
name: plan
description: Create a repo-specific plan
argument-hint: "goal, context, requirements, constraints"
---

# Plan Prompt Template

## Goal
Develop a concrete plan for changes in this dotfiles bootstrap repo, accounting for the installer workflow and prompt regeneration hooks. [install.sh](install.sh#L7-L148) [README.md](README.md#L5-L30)

## Inputs
- Repo context: The repository bootstraps zsh tooling, apt packages, and Copilot prompts via automation in install.sh, scripts/install-prompts.sh, and apt-packages.txt. [install.sh](install.sh#L7-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L1-L85) [apt-packages.txt](apt-packages.txt#L1-L4)
- Requirements: The plan must cover updates to symlinked shell configs and ensure prompts are reinstalled after modifications. [install.sh](install.sh#L104-L148)
- Constraints: Installers are safe to rerun but rely on macOS prompt paths and available commands such as scripts/install-prompts.sh. [README.md](README.md#L17-L30) [scripts/install-prompts.sh](scripts/install-prompts.sh#L56-L85)

## Steps
1. Review the relevant scripts and docs to identify affected components and dependencies before proposing work. [install.sh](install.sh#L7-L148) [docs/prompts.md](docs/prompts.md#L11-L46)
2. Document how potential changes impact apt installs, zsh symlinks, and prompt deployment paths. [install.sh](install.sh#L104-L148) [apt-packages.txt](apt-packages.txt#L1-L4)
3. Outline ordered tasks that cover editing target files, refreshing prompts, and rerunning the installer as needed. [install.sh](install.sh#L140-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)
4. Flag risks such as overwriting dotfiles or missing package managers and recommend mitigations. [install.sh](install.sh#L16-L53)

## Output Format
- Summary: Provide a concise narrative that ties planned work to the installer and prompt tooling. [install.sh](install.sh#L7-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)
- Tasks:
  - Map required edits across install.sh and related shell assets before coding. [install.sh](install.sh#L104-L148)
  - Plan prompt updates and schedule a scripts/install-prompts.sh run to keep Copilot templates in sync. [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)
- Risks/Notes: Include caveats about rerunning scripts/install-prompts.sh on macOS prompt paths and backing up existing dotfiles. [install.sh](install.sh#L121-L148) [README.md](README.md#L17-L30)
- Citations: Reference all sources cited in the plan output. [install.sh](install.sh#L7-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L1-L85) [README.md](README.md#L5-L30) [docs/prompts.md](docs/prompts.md#L11-L46) [apt-packages.txt](apt-packages.txt#L1-L4)
