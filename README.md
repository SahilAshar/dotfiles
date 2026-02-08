# Dotfiles

> **Personal dotfiles for instant, consistent development environments**  
> Optimized for GitHub Codespaces. Compatible with macOS.

## Philosophy

**Zero-friction cloud development**: This repository exists to eliminate environment setup time. When I create a new Codespace, everything should "just work" — shell, tools, agents, and configuration — without any manual intervention.

**Simplicity is a feature**: No dotfiles managers. No complex abstractions. Just bash scripts, symlinks, and git. If it requires documentation to understand, it's too complex.

**AI-native workflows**: Development increasingly happens *with* AI agents, not just *for* code. This repo treats agentic workflows (Copilot agents, skills, custom instructions) as first-class citizens alongside traditional shell config.

**Portable universals**: Agents and skills defined here should work across *all* my workspaces. Workspace-specific customization happens elsewhere (generated per-repo or in enterprise dotfiles).

## What This Repo Does

When you create a Codespace with this dotfiles repo configured:

1. **Installs packages** - `zsh`, `ripgrep`, and other essentials (Linux only)
2. **Configures shell** - Sets up zsh with Oh My Zsh, Powerlevel10k theme, and autosuggestions
3. **Links configurations** - Symlinks `.zshrc`, `.p10k.zsh`, `.gitconfig`, VS Code settings
4. **Deploys agentic workflows** - Installs universal Copilot agents and skills

**Total time**: ~30 seconds on a fresh Codespace.  
**Manual steps required**: Zero.

## Quick Start

### For Codespaces (Recommended)

1. **Enable dotfiles in GitHub**:
   - Go to [GitHub Settings → Codespaces](https://github.com/settings/codespaces)
   - Check "Automatically install dotfiles"
   - Select this repository
   
2. **Create any Codespace** - Your dotfiles install automatically

3. **That's it** - New terminals open in zsh with your full configuration

### For Local Mac (Optional)
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
exec zsh
```

The installer is fully idempotent - safe to run multiple times.

## Repository Structure
```
.github/
  agents/              # Universal Copilot agents (work across all repos)
    readability-reviewer.md
  skills/              # Universal Copilot skills (capabilities for agents)
    readability/
      SKILL.md
  copilot-instructions.md  # Always-on guidance (applies to all tasks)
git/
  .gitconfig          # Git configuration template
scripts/
  install-prompts.sh  # Internal helper for deploying agents/skills
vscode/
  settings.json       # VS Code user settings
zsh/
  .zshrc             # Zsh configuration
  .p10k.zsh          # Powerlevel10k theme configuration
apt-packages.txt     # Linux packages to install
install.sh           # PRIMARY ENTRY POINT (auto-run by Codespaces)
README.md            # You are here
TODO.md              # Prioritized improvement checklist
```

## Agentic Workflow Strategy

This repo implements a three-layer approach to AI-assisted development:

### Layer 1: Custom Instructions (Always-On Guidance)
**File**: `.github/copilot-instructions.md`  
**Purpose**: Project-wide standards that apply to *every* Copilot interaction  
**Scope**: Coding style, architecture notes, build commands, constraints  
**Behavior**: Passive but persistent - automatically loaded

### Layer 2: Skills (Conditional Capabilities)
**Location**: `.github/skills/*/SKILL.md`  
**Purpose**: Reusable, specialized capabilities Copilot loads on-demand  
**Examples**: `readability` (code review heuristics), `shell-scripting` (bash best practices)  
**Behavior**: Copilot decides when to load based on task relevance  
**Portability**: Works across Copilot CLI, coding agent, and VS Code

### Layer 3: Agents (Workflow Orchestrators)
**Location**: `.github/agents/*.md`  
**Purpose**: Named personas that consistently orchestrate tools and skills  
**Examples**: `readability-reviewer` (pre-PR code review), `dotfiles-maintainer` (maintains this repo)  
**Behavior**: Explicitly selected by user (`@readability-reviewer`)  
**When to use**: Repeatable workflows that combine multiple skills/tools

**Key principle**: Custom instructions set the baseline. Skills add capabilities. Agents orchestrate workflows. Use the lightest-weight solution for each need.

## Design Decisions

### Why Codespaces-First?

I develop primarily in cloud environments. Optimizing for Codespaces gives me:
- **Instant setup** - New projects start productive immediately
- **Consistency** - Same environment everywhere, no "works on my machine"
- **Portability** - Work from any device with a browser
- **Disposability** - Tear down and rebuild without fear

Local macOS support exists for occasional offline work, but is not the priority.

### Why Bash-Only Scripts?

Dotfiles managers (chezmoi, stow, yadm) add abstraction that doesn't justify the complexity for my use case. Bash + symlinks + git is:
- **Transparent** - Easy to read, understand, and debug
- **Portable** - Works everywhere without dependencies
- **Simple** - Does exactly what I need, nothing more

If I need templating or secret management later, I'll add it. Until then: YAGNI.

### Why Universal vs Workspace-Specific Agents?

**Universal agents/skills** (in this repo):
- Work across *all* my repositories
- Embody general-purpose capabilities (code review, shell scripting)
- Deployed once, available everywhere

**Workspace-specific agents** (generated per-repo):
- Know about project structure, testing frameworks, deployment patterns
- Generated automatically for each workspace
- Living in workspace `.github/agents/`, not dotfiles repo

This separation keeps dotfiles focused on portable capabilities while allowing per-project specialization.

## How It Works

### On Codespace Creation

1. Codespaces clones this repo to `/workspaces/.codespaces/.persistedshare/dotfiles`
2. Automatically runs `./install.sh`
3. Script installs packages, configures shell, symlinks config files
4. Universal agents/skills deploy to `~/.copilot/` (global scope)

### On Local Mac

1. Manually clone and run `./install.sh`
2. Script detects macOS, skips apt packages gracefully
3. Same shell configuration and agent deployment as Codespaces

### Configuration Management

All configuration lives in this repo, symlinked into `$HOME`:
- `~/.zshrc` → `dotfiles/zsh/.zshrc`
- `~/.p10k.zsh` → `dotfiles/zsh/.p10k.zsh`
- `~/.gitconfig` → `dotfiles/git/.gitconfig`

**Why symlinks?** Changes to dotfiles repo immediately reflect in active environment. No sync needed. One source of truth.

## Customization

### Adding Packages

Edit `apt-packages.txt`, add package names (one per line), rerun `./install.sh`.

### Modifying Shell Config

Edit `zsh/.zshrc` or `zsh/.p10k.zsh`, then reload: `source ~/.zshrc`

### Creating New Agents

1. Create `.github/agents/my-agent.md`
2. Add YAML frontmatter with `name`, `description`, `tools`, `infer`
3. Write agent instructions in markdown body
4. Rerun `./install.sh` to deploy

See [`.github/agents/readability-reviewer.md`](.github/agents/readability-reviewer.md) for example.

### Creating New Skills

1. Create `.github/skills/my-skill/SKILL.md`
2. Add YAML frontmatter with `name`, `description`
3. Write skill instructions, examples, best practices
4. Optionally add scripts/references in skill directory
5. Rerun `./install.sh` to deploy

See [`.github/skills/readability/SKILL.md`](.github/skills/readability/SKILL.md) for example.

## Development Workflow

1. **Make changes** - Edit files in this repo
2. **Test locally** (if possible) - Run `./install.sh` and verify
3. **Commit and push** - Changes go live
4. **Test in fresh Codespace** - Create new Codespace, verify everything works
5. **Iterate** - Fix issues, repeat

For major changes, test in Docker container before pushing:
```bash
docker run -it --rm -v "$(pwd):/dotfiles" ubuntu:24.04 /bin/bash
cd /dotfiles && ./install.sh
```

## Troubleshooting

### Install fails on fresh Codespace

1. Check creation logs: Codespace → "View creation log"
2. Look for errors in install.sh execution
3. SSH into Codespace: `gh codespace ssh`
4. Manually run: `cd /workspaces/.codespaces/.persistedshare/dotfiles && ./install.sh`

### Agents/skills not appearing in Copilot

1. Check `~/.copilot/agents/` and `~/.copilot/skills/` exist
2. Reload VS Code window: `Cmd+Shift+P` → "Reload Window"
3. Check Copilot status: `@workspace /help`
4. Wait 5-10 minutes for indexing

### Shell config changes not applying

1. Verify symlinks: `ls -la ~/.zshrc ~/.p10k.zsh`
2. Reload shell: `source ~/.zshrc` or `exec zsh`
3. Check for errors: `zsh -x -c 'source ~/.zshrc'`

## Contributing

This is a personal repository, but suggestions welcome:
- **Issues**: Report bugs or unexpected behavior
- **Discussions**: Share ideas for improvements
- **Pull requests**: Fix clear bugs (after opening issue first)

Not accepting: Features that add complexity, platform-specific hacks, or third-party dependencies without strong justification.

## License

MIT - Use however you want. Attribution appreciated but not required.

## Inspiration

Built on the shoulders of giants:
- [GitHub's dotfiles guide](https://dotfiles.github.io/)
- [felipecrs/dotfiles](https://github.com/felipecrs/dotfiles)
- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [GitHub awesome-copilot](https://github.com/github/awesome-copilot)
- [Anthropic skills](https://github.com/anthropics/skills)