---
name: deploy
description: Create a deployment checklist and summary
argument-hint: "goal, target, services, credentials, verification"
---

# Deploy Prompt Template

## Goal
Produce a deployment checklist for rolling updated dotfiles, shell plugins, and Copilot prompts onto a local workstation. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Inputs
- Deployment target: A developer machine managed by running ./install.sh followed by scripts/install-prompts.sh (or the prompt step embedded at the end of install.sh). [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
- Services/components: Apt package bootstrap, Oh My Zsh, Powerlevel10k, zsh-autosuggestions, zsh config symlinks, and prompt templates from github/.github/prompts. [install.sh](install.sh) [github/.github/prompts](github/.github/prompts)
- Required credentials/vars: git and curl for cloning, optional apt-get availability, and environment overrides such as DOTFILES_DIR, COPILOT_PROMPTS_DIR, or CODE_VARIANT. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Steps
1. Verify prerequisites: confirm network access, git/curl presence, apt-get availability (or note macOS skips), and the destination prompt folder (~/Library/Application Support/Code/User/prompts by default). [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
2. Execute ./install.sh from the repo root to install packages, clone zsh plugins, and link configs; allow the script to cascade into scripts/install-prompts.sh. [install.sh](install.sh)
3. Validate the install by checking $HOME symlinks (.zshrc, .p10k.zsh), ensuring prompt files exist at the VS Code path, and confirming Powerlevel10k/zsh-autosuggestions directories were created. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
4. Define rollback/remediation steps: restore *.bak files, remove unwanted symlinks, or re-run ./install.sh after adjusting env vars (e.g., COPILOT_PROMPTS_DIR). [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Output Format
- Summary: Highlight deployment actions, emphasizing installer runs, prompt sync status, and any env overrides. [install.sh](install.sh)
- Commands Run:
  - Document ./install.sh (and any env vars like DOTFILES_DIR or CODE_VARIANT) plus follow-on scripts/install-prompts.sh invocations. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
- Verification:
  - Capture checks for symlinked configs, plugin directories, and prompt files within the VS Code profile. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
- Citations: Link to every script or doc referenced while preparing the deployment summary. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh) [github/.github/prompts](github/.github/prompts)
