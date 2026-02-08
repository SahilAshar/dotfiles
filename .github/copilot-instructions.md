# Dotfiles Repository - Copilot Instructions

This is a **personal dotfiles automation repository** optimized for **GitHub Codespaces** (primary) with minimal macOS support (secondary).

## Primary Goal

**Bootstrap cloud development environments (Codespaces) instantly** with:
- Shell configuration (zsh + Oh My Zsh + Powerlevel10k)
- Agentic workflow support (Copilot agents, skills, prompts)
- Git and VS Code configurations
- Zero manual intervention required

## Architecture Philosophy

**Simplicity over flexibility**: Bare git repo approach. Bash-only scripts. Same configuration across all environments (OS-agnostic where possible). No dotfiles managers. No complexity.

**Codespaces-first design**: Everything assumes `/workspaces/.codespaces/.persistedshare/dotfiles` as the clone location. Automatic execution via `install.sh`. Idempotent reruns.

**Agentic workflow strategy**:
- **Universal agents** (`.github/agents/`): Portable across all workspaces (e.g., `readability-reviewer.md`)
- **Universal skills** (`.github/skills/`): Reusable capabilities (e.g., `readability/`)
- **Custom instructions** (`.github/copilot-instructions.md`): Always-on repo guidance
- **Workspace-specific agents**: Generated per-repo via automation (future goal)

## Tech Stack & Commands

**Shell**: `bash` scripts, `zsh` as target shell  
**Package Manager**: `apt-get` (Linux/Codespaces), graceful skip on macOS  
**Frameworks**: Oh My Zsh, Powerlevel10k theme, zsh-autosuggestions

**Primary command**: `./install.sh` (Codespaces auto-runs this)  
**Internal helpers**: `scripts/install-prompts.sh` (invoked by install.sh)

## Project Structure
```
.github/
  agents/              # Universal agents (portable across workspaces)
  skills/              # Universal skills (Copilot + Claude compatible)
  copilot-instructions.md  # This file (always-on guidance)
git/
  .gitconfig          # Git configuration template
scripts/
  install-prompts.sh  # Internal helper for prompt deployment
vscode/
  settings.json       # VS Code user settings (future)
zsh/
  .zshrc             # Zsh configuration
  .p10k.zsh          # Powerlevel10k theme config
apt-packages.txt     # Linux packages to install
install.sh           # PRIMARY ENTRY POINT (Codespaces runs this)
README.md            # Repository philosophy and usage
```

**REMOVED** (cleanup completed):
- `github/.github/prompts/` - Redundant canonical templates
- `.github/prompts/` - Example outputs (not needed in dotfiles repo)
- `docs/prompts.md` - Outdated documentation

## Critical Constraints

**Idempotency**: All scripts must be safely re-runnable. Use checks before installs. Create `.bak` backups before overwriting.

**No user interaction**: Scripts run unattended in Codespaces. No password prompts. Use `sudo` only when `EUID != 0` and `sudo` exists.

**Cross-platform compatibility** (minimal):
- Detect OS via `uname -s` for macOS vs Linux
- Skip apt-get if unavailable (macOS default)
- Use `$HOME` not hardcoded paths
- Detect Codespaces via `$CODESPACES` environment variable

**Package management**:
- `apt-get`: Only install if missing (check with `dpkg -s`)
- `curl` + `git`: Required dependencies
- No homebrew, no cargo, no npm globals (keep scope tight)

## Coding Standards

**Bash scripts**:
- Always start with `#!/usr/bin/env bash`
- Always include `set -euo pipefail` (fail fast, no unset vars, pipe failures)
- Use functions for logical groupings
- Add comments explaining *why*, not *what*
- Use `local` for function variables

**File operations**:
- Check existence before operations (`[ -f ]`, `[ -d ]`)
- Create parent directories before symlinking (`mkdir -p`)
- Backup before replacing (`mv existing existing.bak`)
- Use absolute paths or `$SCRIPT_DIR` relative paths

**Error handling**:
- Exit with error codes on failures
- Echo error messages to stderr (`>&2`)
- Provide actionable error messages

## Agent & Skill Guidelines

**When creating agents** (`.github/agents/*.md`):
- `infer: false` for manual selection (explicit activation)
- `tools: ['read', 'search', 'agent']` for review-only agents
- Include `agent` tool if agent might invoke skills
- Focus on *workflow orchestration*, not specific tasks

**When creating skills** (`.github/skills/*/SKILL.md`):
- Rich `description` with trigger keywords
- Concrete examples with before/after code
- Action-oriented instructions ("do X when Y")
- Include reference files in skill directory when helpful

**When writing instructions** (this file):
- High-level principles and architecture
- Project-wide standards and conventions
- Commands and file paths
- What NOT to do (constraints)

## Current Priorities

1. **Codespaces optimization**: Instant bootstrap experience
2. **Agent/skill ecosystem**: Build universal capabilities (readability review, dotfiles maintenance)
3. **Git/VS Code config**: Establish baseline configurations
4. **Documentation cleanup**: Remove outdated/redundant docs

## Future Considerations (Lower Priority)

- Workspace-specific agent generation workflow
- Additional configuration files (vim, tmux)
- Personal vs work dotfiles separation strategy
- Dotfiles maintenance agents