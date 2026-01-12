---
name: test
description: Plan and report test execution for a change
argument-hint: "scope, commands, environment, results"
---

# Test Prompt Template

## Goal
Plan and document validation of dotfiles installer changes, ensuring prompt publishing, symlink updates, and package guardrails behave as expected. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Inputs
- Test scope: Cover any touched scripts (install.sh, scripts/install-prompts.sh), prompt templates, and zsh configs linked into $HOME. [install.sh](install.sh) [github/.github/prompts](github/.github/prompts) [zsh/.zshrc](zsh/.zshrc)
- Commands available: ./install.sh for end-to-end coverage, scripts/install-prompts.sh for direct prompt syncing, plus auxiliary checks such as cat apt-packages.txt or ls ~/Library/Application Support/Code/User/prompts. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh) [apt-packages.txt](apt-packages.txt)
- Environment notes: macOS defaults to Library/Application Support paths and often lacks apt-get, so tests should capture skipped package installs and any COPILOT_PROMPTS_DIR overrides. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Steps
1. Determine which installer stages need exercising (apt packages, symlink linking, prompt deployment) based on the change request. [install.sh](install.sh)
2. Run the necessary scripts with representative environment variables, capturing stdout/stderr for apt skips, git clones, and prompt symlinks. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
3. Summarize observed results: files linked under $HOME, prompt files created in the VS Code profile, and any generated backups (*.bak). [install.sh](install.sh)
4. Record failures or anomalies (e.g., missing curl, permission errors, incorrect prompt path) along with remediation steps. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)

## Output Format
- Summary: Explain which workflows were exercised and why those tests prove the change is safe. [install.sh](install.sh)
- Commands Run:
  - Include the exact ./install.sh invocation (and flags/env vars) plus supporting commands like ls or tail for verification. [install.sh](install.sh)
  - Capture standalone scripts/install-prompts.sh executions if prompts were the primary focus. [scripts/install-prompts.sh](scripts/install-prompts.sh)
- Results:
  - Report pass/fail outcomes, linking evidence for symlinks, prompt files, or package installations. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh)
- Citations: Link every referenced script, config, or doc cited in the test report. [install.sh](install.sh) [scripts/install-prompts.sh](scripts/install-prompts.sh) [apt-packages.txt](apt-packages.txt) [zsh/.zshrc](zsh/.zshrc)
