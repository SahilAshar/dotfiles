# Dotfiles Repository - Copilot Instructions

This is a **personal dotfiles automation repository** optimized for **GitHub Codespaces** (primary) with minimal macOS support (secondary).

## Primary Goal

**Bootstrap cloud development environments (Codespaces) instantly** with:
- Shell configuration (zsh + Oh My Zsh + Powerlevel10k)
- Agentic workflow support (Copilot agents, skills, prompts)
- Git and VS Code configurations
- Zero manual intervention required

## Why This Exists

Modern development increasingly happens *with* AI agents in ephemeral cloud environments. The bottleneck is no longer compute — it's **context**. This repo exists to eliminate setup friction and deliver rich, tailored context instantly when spinning up new workspaces.

**The workflow this enables**:
1. Clone new workspace (personal project, work repo, open source contribution)
2. Codespaces auto-installs this dotfiles repo (~30 seconds)
3. Universal agents and skills are immediately available
4. Workspace-specific agents can be generated from templates (future)
5. Begin productive work — plan, implement, test, debug, deploy — with AI agents that understand both your workflow and the project

**The broader ecosystem**: Personal dotfiles provide the universal baseline. Work environments layer a "shim" repo on top that adds enterprise context (internal documentation, MCP servers, Codespaces image compatibility, repo-specific agents). Small tools and cookiecutter repos benefit from instant agent onboarding — spin up, understand the Makefile targets, fix bugs, ship features.

**The vision**: Extensible AI-augmented development anywhere, on any machine, ready to contribute fast but tailored to your workflows. Universal capabilities (readability review, git workflows, TDD patterns) live here. Workspace-specific knowledge (testing frameworks, deployment pipelines, team conventions) gets generated per-repo.

## Architecture Philosophy

**Simplicity over flexibility**: Bare git repo approach. Bash-only scripts. Same configuration across all environments (OS-agnostic where possible). No dotfiles managers. No complexity.

**Codespaces-first design**: Everything assumes `/workspaces/.codespaces/.persistedshare/dotfiles` as the clone location. Automatic execution via `install.sh`. Idempotent reruns.

**`install.sh` execution flow**: Calls discrete functions in order: `install_apt_packages` → `install_ohmyzsh` → `install_powerlevel10k` → `install_zsh_autosuggestions` → `link_file` (symlinks) → `deploy_copilot_prompts`. Each function is independently idempotent — checks if work is already done before acting.

**Symlink strategy**: Config files live in this repo and are symlinked into `$HOME` via the `link_file` helper. It backs up existing files to `.bak`, skips if symlink already points correctly, and fails if a `.bak` already exists (requires manual resolution).

**Agentic workflow strategy**:
- **Universal agents** (`.github/agents/`): Portable across all workspaces (e.g., `readability-reviewer.md`)
- **Universal skills** (`.github/skills/`): Reusable capabilities (e.g., `readability/`)
- **Custom instructions** (`.github/copilot-instructions.md`): Always-on repo guidance
- **Workspace-specific agents**: Generated per-repo via automation (future goal)

## Commands

```bash
# Run the full installer (Codespaces auto-runs this)
./install.sh

# Unit tests (31 tests, bash-based, no framework)
bash tests/test-install.sh

# Lint all shell scripts
shellcheck install.sh scripts/*.sh tests/*.sh

# Integration test in Docker (mimics Codespaces base image)
docker run -it --rm -v "$(pwd):/dotfiles" mcr.microsoft.com/devcontainers/universal:latest bash -c "cd /dotfiles && ./install.sh"
```

No way to run a single test — `tests/test-install.sh` is one script with inline test functions grouped by section. To focus on a specific area, comment out other sections temporarily.

## Tech Stack

**Shell**: `bash` scripts, `zsh` as target shell  
**Package Manager**: `apt-get` (Linux/Codespaces), graceful skip on macOS  
**Frameworks**: Oh My Zsh, Powerlevel10k theme, zsh-autosuggestions

## Project Structure
```
.github/
  agents/              # Universal agents (portable across workspaces)
  skills/              # Universal skills (Copilot + Claude compatible)
  workflows/ci.yml     # CI pipeline (lint + test + integration)
  copilot-instructions.md  # This file (always-on guidance)
docs/
  TODO.md              # Prioritized improvement backlog
git/
  .gitconfig          # Git configuration template
scripts/
  install-prompts.sh  # No-op placeholder; discovers agents/skills in .github/
tests/
  test-install.sh     # 31 unit tests (static analysis + sandboxed behavioral tests)
zsh/
  .zshrc             # Zsh configuration
  .p10k.zsh          # Powerlevel10k theme config
apt-packages.txt     # Linux packages to install (one per line)
install.sh           # PRIMARY ENTRY POINT (Codespaces runs this)
```

## CI Pipeline

GitHub Actions (`.github/workflows/ci.yml`) runs on every push to `main` and every PR. Three stages: **ShellCheck lint** → **Unit tests** (`test-install.sh`) → **Integration test** (full `install.sh` end-to-end + idempotency rerun). All jobs use `mcr.microsoft.com/devcontainers/universal` container for Codespaces parity.

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

See `docs/TODO.md` for the full backlog. Top items:
1. **Codespaces optimization**: Instant bootstrap experience
2. **Agent/skill ecosystem**: Build universal capabilities (readability review, dotfiles maintenance)
3. **Git/VS Code config**: Establish baseline configurations