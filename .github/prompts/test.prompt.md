---
name: test
description: Plan and report test execution for a change
argument-hint: "scope, commands, environment, results"
---

# Test Prompt Template

## Goal
Plan and document validation of installer and prompt changes in this dotfiles repository. [install.sh](install.sh#L130-L149) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)

## Inputs
- Test scope: Cover install.sh flows, prompt installer behavior, and relevant shell config symlinks. [install.sh](install.sh#L104-L148) [zsh/.zshrc](zsh/.zshrc)
- Commands available: Use install.sh and scripts/install-prompts.sh to exercise automation paths; optionally inspect apt packages. [install.sh](install.sh#L130-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85) [apt-packages.txt](apt-packages.txt#L1-L4)
- Environment notes: macOS users rely on Library/Application Support prompt destinations and may lack apt-get locally. [scripts/install-prompts.sh](scripts/install-prompts.sh#L56-L63) [install.sh](install.sh#L22-L53)

## Steps
1. Identify which installer segments and configs require coverage based on the proposed change. [install.sh](install.sh#L16-L148)
2. Execute the necessary scripts or commands and capture outputs for verification. [install.sh](install.sh#L130-L148) [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)
3. Summarize observed results, noting symlink updates and prompt deployment status. [install.sh](install.sh#L140-L148)
4. Document any failures, including missing dependencies like apt-get, with suggested follow-ups. [install.sh](install.sh#L22-L53)

## Output Format
- Summary: Provide a concise overview of what was tested and why it matters for the change. [install.sh](install.sh#L130-L148)
- Commands Run:
  - Record the install.sh invocation and whether it completed successfully. [install.sh](install.sh#L130-L149)
  - Capture the scripts/install-prompts.sh run (with flags if used) and its output. [scripts/install-prompts.sh](scripts/install-prompts.sh#L68-L85)
- Results:
  - Detail pass/fail outcomes, including symlink or prompt installation status. [install.sh](install.sh#L140-L148)
- Citations: List every referenced script, config, or doc used in the test report. [install.sh](install.sh#L16-L149) [scripts/install-prompts.sh](scripts/install-prompts.sh#L1-L85) [apt-packages.txt](apt-packages.txt#L1-L4) [zsh/.zshrc](zsh/.zshrc)
