# Dotfiles Improvement TODO

Priority-ordered checklist for evolving this dotfiles repository.

## Tomorrow: Work Setup (2026-02-09)

### Universal Skills (Personal Dotfiles)
- [ ] **PR generation skill** (`.github/skills/pr-generation/SKILL.md`)
  - [ ] Create PR from current branch state
  - [ ] Auto-generate title and description from commits/diffs
  - [ ] Include testing evidence and deployment notes
  - [ ] Run `linting` skill first and include lint/fix summary in PR body
  - [ ] Run `style-lint` skill and include style/readability notes in PR body
  - [ ] Template structure for consistency

- [ ] **TDD bug fixing skill** (`.github/skills/tdd-bug-fix/SKILL.md`)
  - [ ] Write failing test that reproduces bug
  - [ ] Implement minimal fix
  - [ ] Verify test passes
  - [ ] Include regression test patterns

- [ ] **Git worktree skill** (`.github/skills/git-worktree/SKILL.md`)
  - [ ] Set up parallel worktrees for concurrent work
  - [ ] Best practices for worktree organization
  - [ ] Clean up stale worktrees
  - [ ] Integration with PR workflows

- [ ] **Context management skill** (`.github/skills/context-management/SKILL.md`)
  - [ ] Strategies for keeping agent context relevant
  - [ ] When to summarize vs when to preserve detail
  - [ ] Managing large codebases efficiently
  - [ ] Token budget awareness

### Enterprise Shim Repo Setup (Work)
- [ ] **Create enterprise dotfiles shim repo structure**
  - [ ] `install.sh` that clones personal dotfiles first
  - [ ] Run personal `install.sh`, then layer enterprise config
  - [ ] Document in shim README: personal → enterprise boundary

- [ ] **Enterprise-specific skills** (in shim repo)
  - [ ] Internal documentation integration skill (uses work MCP servers)
  - [ ] Internal GitHub access patterns skill
  - [ ] Enterprise Codespaces setup best practices skill
  - [ ] Makefile-aware workflows skill (for cookiecutter repos)

- [ ] **Enterprise CI setup** (in shim repo)
  - [ ] `.github/workflows/ci.yml` using internal Codespaces images
  - [ ] Same structure as personal dotfiles (lint + test + integration)
  - [ ] Test against internal base image, not public universal image

- [ ] **MCP server configurations** (in shim repo)
  - [ ] Document which MCP servers are available
  - [ ] Create example agent that uses work MCP servers
  - [ ] Test MCP server connectivity in CI

### Validation
- [ ] Clone personal dotfiles to work machine
- [ ] Verify all universal skills load correctly
- [ ] Set up enterprise shim repo
- [ ] Test full install flow (personal + enterprise layering)
- [ ] Create one workspace-specific agent manually to validate approach

## High Priority (Do First)

### P0: Critical Cleanup
- [x] **Remove redundant directories**
  - [x] Delete `github/.github/prompts/` (canonical templates - no longer needed)
  - [x] Delete `.github/prompts/` (example outputs - cluttering repo)
  - [x] Delete `docs/prompts.md` (outdated prompt documentation)
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
- [x] **Update README.md** with new philosophy

- [x] **Create testing checklist**
  - [x] Create `tests/test-install.sh` with 22 tests covering install.sh
  - [ ] Test fresh Codespace creation (manual)
  - [ ] Test local macOS install (manual)
  - [x] Test re-running install.sh (idempotency) — covered by test suite
  - [ ] Test with missing dependencies (no curl, no git) — partial coverage

- [x] **Dotfiles CI/CD** (GitHub Actions) — merged in PR #9
  - [x] Create `.github/workflows/ci.yml` with lint + test + integration jobs
  - [x] All jobs on `mcr.microsoft.com/devcontainers/universal` (Codespaces base image)
  - [x] ShellCheck linting on all `.sh` files
  - [x] Run `tests/test-install.sh` unit tests (23 tests)
  - [x] Full `install.sh` integration test in container
  - [x] Trigger on push to `main` and PRs
  - [x] Fix ShellCheck warnings in existing scripts
  - [x] PR review feedback: safer `.bak` handling, decoupled test fixtures, doc alignment
  - [ ] TODO: Add `macos-latest` runner job (do NOT implement yet)

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

- [x] **Simplify install-prompts.sh**
  - [x] Rewrote to discover agents/skills in `.github/` instead of referencing deleted prompts
  - [ ] Consider: Should agents/skills be deployed globally (`~/.copilot/`) in future?
  - [ ] If so, implement symlink/copy from `.github/agents/` and `.github/skills/` to `~/.copilot/`

## Notes
- This TODO is a living document - update as priorities shift
- Mark items complete with `[x]` and date: `- [x] Task description (2026-01-15)`
- Move completed items to a separate `DONE.md` file periodically
- Review and re-prioritize monthly
