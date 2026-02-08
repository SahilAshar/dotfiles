This is a dotfiles automation repository for bootstrapping development environments.

## Tech Stack
- **Shell**: Bash scripts (install.sh)
- **Package Manager**: apt-get (Linux), brew-compatible (macOS)
- **Frameworks**: Oh My Zsh, Powerlevel10k theme

## Commands
- Install: `./install.sh`
- Install prompts only: `scripts/install-prompts.sh`
- Test in fresh environment: Codespaces or Docker

## Project Structure
- `install.sh` - Main bootstrapper, handles packages and symlinks
- `scripts/` - Helper scripts (prompt installation)
- `zsh/` - Shell configuration files
- `github/.github/prompts/` - Canonical Copilot prompt templates
- `.github/prompts/` - Repo-specific prompt examples

## Guidelines
- **Idempotency**: All scripts must be safely re-runnable
- **Cross-platform**: Support both Linux (apt) and macOS (no apt)
- **No user interaction**: Scripts must run unattended for Codespaces
- **Backups**: Always `.bak` existing files before overwriting