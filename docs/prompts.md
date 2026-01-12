# Copilot Chat Prompts

This repo ships a reusable prompt generator to create repo-specific prompts. Canonical templates live in [github/.github/prompts](github/.github/prompts); any repo-specific copies should sit under that repo's [.github/prompts](.github/prompts) folder so Copilot Chat can consume them.

## Files

- [github/.github/prompts/generate.prompt.md](github/.github/prompts/generate.prompt.md) — generates repo-specific prompts and instructions for any repo you run it in.
- [.github/prompts](.github/prompts) — sample output produced by running the generator for this dotfiles repo; treat it as an example, not a source of truth for installers.

## Install

Run `./install.sh` from the repo root whenever you want to (re)install prompts. The bootstrapper invokes `scripts/install-prompts.sh` internally after syncing zsh files, so one entry point keeps Copilot prompts and shell config aligned. The helper logs `Deploying prompts from: ...` and always sources from [github/.github/prompts](github/.github/prompts).

The installer only publishes the `/generate` prompt into your VS Code user prompt space. When you edit templates inside this repo, rerun `./install.sh` so that `/generate` always reflects the latest canonical instructions. Set `COPILOT_PROMPTS_DIR` if you need to override the default VS Code profile path, and `CODE_VARIANT` when targeting a different VS Code flavor (for example, Insiders).

By default, the generator is symlinked into your VS Code user prompts directory:

- macOS: `~/Library/Application Support/Code/User/prompts`
- Linux: `~/.config/Code/User/prompts`

## Use in Copilot Chat

Open Copilot Chat and use `/generate` to select [github/.github/prompts/generate.prompt.md](github/.github/prompts/generate.prompt.md). The generator copies the canonical templates into the current repo's `.github/prompts/` directory (creating it if missing), gathers repository context, and fills the placeholders for `plan`, `implement`, `test`, and `deploy`. After `/generate` updates a repo, rerun `./install.sh` in dotfiles so the generator you publish for future sessions stays in sync with those changes.
