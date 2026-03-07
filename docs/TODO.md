# Dotfiles Improvement TODO

Priority-ordered checklist for evolving this dotfiles repository.

## High Priority (Do First)

### P0: Critical Cleanup
- [ ] Clean up any `.bak` files from testing

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
- [ ] Test fresh Codespace creation (manual)
- [ ] Test local macOS install (manual)
- [ ] Test with missing dependencies (no curl, no git) — partial coverage
- [ ] Add `macos-latest` runner job to CI
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

- [ ] **Enterprise dotfiles shim repo** (work GitHub)
  - [ ] Create shim repo in enterprise GitHub org
  - [ ] Shim `install.sh` clones this personal dotfiles repo (enterprise → personal is allowed)
  - [ ] Shim layers work-specific configuration on top:
    - [ ] Work-specific Copilot agents and skills
    - [ ] Work-specific prompts and MCP server configs
    - [ ] Internal Codespace base image CI (separate workflow)
    - [ ] Enterprise git config overrides (email, signing, proxy)
    - [ ] Work-specific VS Code extensions and settings
  - [ ] Shim runs its own install script after personal dotfiles install
  - [ ] Document the personal ↔ enterprise boundary in both READMEs
  - [ ] Test with fresh enterprise Codespace
  - [ ] _Note: Implementation happens on work machine with internal docs/MCPs_

- [ ] **Dotfiles CI/CD — macOS runner**
  - [ ] Add `macos-latest` job to CI workflow
  - [ ] Validate install.sh graceful skip of apt-get
  - [ ] Validate symlink creation on macOS

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
- [ ] Consider: Should Copilot agents/skills be deployed globally (`~/.copilot/`) in future?

## Notes
- This TODO is a living document - update as priorities shift
- Mark items complete with `[x]` and date: `- [x] Task description (2026-01-15)`
- Move completed items to a separate `DONE.md` file periodically
- Review and re-prioritize monthly