---
name: deploy
description: Create a deployment checklist and summary
argument-hint: "goal, target, services, credentials, verification"
---

# Deploy Prompt Template

## Goal
Create a deployment checklist for rolling updated dotfiles and Copilot prompts onto a developer machine. [install.sh](install.sh#L7-L149) [scripts/install-prompts.sh](scripts/install-prompts.sh#L1-L85)

## Inputs
- Deployment target: Local workstation managed through install.sh and scripts/install-prompts.sh. [install.sh](install.sh#L7-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L56-L85)
- Services/components: Zsh configuration symlinks, Powerlevel10k theme, zsh-autosuggestions, and Copilot prompt templates. [install.sh](install.sh#L85-L148)
- Required credentials/vars: Access to git, curl, apt-get (if available), and optional CODE_VARIANT or DEST overrides. [install.sh](install.sh#L22-L73) [scripts/install-prompts.sh](scripts/install-prompts.sh#L9-L63)

## Steps
1. Verify prerequisites such as package managers, network access, and destination prompt directories. [install.sh](install.sh#L16-L53) [scripts/install-prompts.sh](scripts/install-prompts.sh#L56-L67)
2. Run install.sh to apply dotfiles and then execute scripts/install-prompts.sh to refresh Copilot prompts. [install.sh](install.sh#L130-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)
3. Confirm health by checking symlinked zsh files, installed plugins, and prompt availability. [install.sh](install.sh#L104-L148)
4. Prepare rollback steps such as restoring .zshrc.bak or re-running installers with adjusted flags. [install.sh](install.sh#L119-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L6-L34)

## Output Format
- Summary: Outline the deployment actions, highlighting installer runs and prompt updates. [install.sh](install.sh#L130-L148)
- Commands Run:
  - Install dotfiles via install.sh from the repo root. [install.sh](install.sh#L130-L148)
  - Refresh Copilot prompts with scripts/install-prompts.sh (symlink or copy as needed). [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)
- Verification:
  - Note checks for zsh theme/plugins and confirm prompt files exist at the expected destination. [install.sh](install.sh#L85-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L56-L85)
- Citations: Provide the references used to build the deployment checklist. [install.sh](install.sh#L7-L149) [scripts/install-prompts.sh](scripts/install-prompts.sh#L1-L85)
