# Dotfiles Improvement TODO

Priority-ordered checklist for evolving this dotfiles repository.

## High Priority (Do First)

### P0: Critical Cleanup
- [ ] **Remove redundant directories**
  - [ ] Delete `github/.github/prompts/` (canonical templates - no longer needed)
  - [ ] Delete `.github/prompts/` (example outputs - cluttering repo)
  - [ ] Delete `docs/prompts.md` (outdated prompt documentation)
  - [ ] Clean up any `.bak` files from testing

- [ ] **Git configuration**
  - [ ] Create `git/.gitconfig` template with sensible defaults
  - [ ] Add symlinking logic in `install.sh` for `.gitconfig`
  - [ ] Document git config customization in README

- [ ] **VS Code configuration**
  - [ ] Create `vscode/settings.json` with baseline settings
  - [ ] Create `vscode/keybindings.json` if needed
  - [ ] Add VS Code config deployment to `install.sh`
  - [ ] Test in fresh Codespace

### P1: Agent/Skill Ecosystem Foundation
- [ ] **Create dotfiles maintenance agent** (`.github/agents/dotfiles-maintainer.md`)
  - [ ] Agent that helps update/maintain this dotfiles repo itself
  - [ ] Can review install.sh changes for safety
  - [ ] Can suggest improvements to shell configs
  - [ ] Uses `readability` skill for script review

- [ ] **Create shell-scripting skill** (`.github/skills/shell-scripting/SKILL.md`)
  - [ ] Best practices for bash scripts
  - [ ] Common patterns (checking commands, backups, idempotency)
  - [ ] Error handling templates
  - [ ] Include example scripts

- [ ] **Flesh out workspace-specific agent generation strategy**
  - [ ] Research: Best approach for generating per-repo agents
  - [ ] Decide: Modify `/generate` prompt system or create new agent?
  - [ ] Design: Input (repo context) → Output (custom agent.md)
  - [ ] Prototype: Test in one workspace
  - [ ] Document: Add workflow to README

### P2: Documentation & Testing
- [ ] **Update README.md** with new philosophy (see part D below)
  
- [ ] **Create testing checklist**
  - [ ] Test fresh Codespace creation
  - [ ] Test local macOS install
  - [ ] Test re-running install.sh (idempotency)
  - [ ] Test with missing dependencies (no curl, no git)
  
- [ ] **Add troubleshooting guide**
  - [ ] Common errors and solutions
  - [ ] How to check logs in Codespaces
  - [ ] How to manually fix failed installs

## Medium Priority (Do Next)

### P3: Configuration Enhancements
- [ ] **Expand git configuration**
  - [ ] Add git aliases
  - [ ] Add commit message templates
  - [ ] Add merge/diff tools configuration
  
- [ ] **Enhance zsh configuration**
  - [ ] Add useful aliases
  - [ ] Add custom functions
  - [ ] Add environment variable templates
  - [ ] Document customization approach

- [ ] **VS Code extensions**
  - [ ] Create recommended extensions list
  - [ ] Auto-install critical extensions in Codespaces?
  - [ ] Document manual vs automatic approach

### P4: Agent/Skill Expansion
- [ ] **Create additional universal skills**
  - [ ] `git-workflow` - Git best practices and patterns
  - [ ] `markdown-editing` - Markdown formatting standards
  - [ ] `documentation` - How to document code/repos
  
- [ ] **Create specialized agents for common tasks**
  - [ ] `config-reviewer` - Reviews dotfiles changes
  - [ ] `environment-debugger` - Helps debug shell/env issues

### P5: Developer Experience
- [ ] **Add installation progress indicators**
  - [ ] Better visual feedback during install
  - [ ] Estimated time remaining?
  - [ ] Spinners for long-running operations
  
- [ ] **Create quick-start script**
  - [ ] `bootstrap.sh` that curl-pipes for one-command install
  - [ ] Similar to felipecrs/dotfiles approach
  - [ ] Add to README

- [ ] **Logging improvements**
  - [ ] Write detailed logs to `~/.dotfiles.log`
  - [ ] Capture errors separately
  - [ ] Add debug mode (`DOTFILES_DEBUG=1`)

## Low Priority (Future Nice-to-Haves)

### P6: Advanced Features
- [ ] **Conditional configuration**
  - [ ] Detect repo type (Python, Node, Go, etc.)
  - [ ] Load language-specific configs
  - [ ] Optional: MCP integration

- [ ] **Cross-environment sync**
  - [ ] Personal Codespaces vs work Codespaces
  - [ ] Strategy for environment-specific overrides
  - [ ] Document the pattern (don't implement in this repo)

- [ ] **Dotfiles CI/CD**
  - [ ] GitHub Actions to validate install.sh
  - [ ] Shellcheck linting
  - [ ] Test in Docker container
  - [ ] Auto-generate skill from code changes?

### P7: Community & Sharing
- [ ] **Make repo a template**
  - [ ] Create GitHub template repo
  - [ ] Add template-specific README
  - [ ] Include customization guide

- [ ] **Contribution guidelines**
  - [ ] How others can suggest improvements
  - [ ] What kinds of contributions are welcome
  - [ ] How to test changes

- [ ] **Example configurations**
  - [ ] Create `examples/` directory
  - [ ] Add language-specific examples
  - [ ] Add workflow-specific examples

## Research & Exploration Tasks

### R1: Agent/Skill Architecture
- [ ] **Study best practices for agent/skill hierarchies**
  - [ ] Read GitHub Copilot agent documentation thoroughly
  - [ ] Study awesome-copilot examples
  - [ ] Study anthropics/skills examples
  - [ ] Document findings in new `docs/agent-architecture.md`

- [ ] **Prototype workspace-specific agent generation**
  - [ ] Create proof-of-concept agent that generates other agents
  - [ ] Test with 2-3 different repo types
  - [ ] Document what works and what doesn't
  - [ ] Decide: Is this better than prompts for per-repo customization?

### R2: Codespaces Optimization
- [ ] **Research Codespaces best practices**
  - [ ] Official GitHub docs on dotfiles
  - [ ] Community examples (awesome-dotfiles)
  - [ ] Performance optimization techniques
  - [ ] Secret management strategies

- [ ] **Investigate devcontainer.json integration**
  - [ ] Can dotfiles + devcontainer.json work together?
  - [ ] Should some config move to devcontainer?
  - [ ] Document the boundary between them

### R3: Alternative Approaches
- [ ] **Evaluate dotfiles managers**
  - [ ] Try chezmoi, stow, yadm
  - [ ] Document pros/cons vs bare repo
  - [ ] Decide: Is added complexity worth it?
  - [ ] Keep current approach unless compelling reason to change

## Deprecation / Removal Candidates

### D1: Remove Unused Features
- [ ] **Audit current files**
  - [ ] Identify unused configurations
  - [ ] Remove or document "why kept but not used"
  
- [ ] **Simplify install-prompts.sh**
  - [ ] Current script only handles /generate
  - [ ] Either expand to handle agents/skills or rename to reflect scope
  - [ ] Consider: Should agents/skills be symlinked or copied?

## Notes
- This TODO is a living document - update as priorities shift
- Mark items complete with `[x]` and date: `- [x] Task description (2026-01-15)`
- Move completed items to a separate `DONE.md` file periodically
- Review and re-prioritize monthly