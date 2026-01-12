# Dotfiles

Bootstrap and configure local dev settings with a repeatable installer.

## Quick start

Run the bootstrap installer from the repo root:

```bash
./install.sh
```

The script is safe to re-run, installs the `/generate` Copilot Chat prompt into your user prompt space, and should be rerun whenever you edit prompt templates so the generator stays current. Treat it as the primary entry point for everything in this repo.

> Note: `scripts/install-prompts.sh` is an internal helper invoked by `./install.sh`. Use the top-level installer for all normal workflows.

## What `install.sh` sets up

- **apt packages** — Reads [`apt-packages.txt`](apt-packages.txt) and installs only packages missing from `dpkg`. If the file is absent or `apt-get` does not exist (the default on macOS), the step logs a skip so mac users are unaffected.
- **Oh My Zsh + extras** — Runs the upstream installer via `curl` when `$HOME/.oh-my-zsh` is missing (requires `curl`). Installs the Powerlevel10k theme and `zsh-autosuggestions` plugin by cloning with `git`, so `git` must be available.
- **Shell config symlinks** — Uses `link_file` to point `$HOME/.zshrc` and `$HOME/.p10k.zsh` at the repo copies under `zsh/`. Existing files are moved to `.bak` before linking, letting you safely rerun `./install.sh` to refresh changes without losing prior configs.
- **Prompt templates** — Re-invokes [`scripts/install-prompts.sh`](scripts/install-prompts.sh) so the `/generate` prompt is published to your VS Code user prompt directory. The helper always syncs from the canonical templates in [github/.github/prompts](github/.github/prompts) and logs the source directory it used.

## Prompts for Copilot Chat

This repo ships reusable Copilot Chat prompt templates and an installer. Edit or regenerate the canonical templates under [github/.github/prompts](github/.github/prompts); the files under [.github/prompts](.github/prompts) are an example output produced by running the generator for this dotfiles repo.

Run `./install.sh` any time you change prompt templates. The installer republishes the `/generate` prompt by invoking the helper script for you and logs `Deploying prompts from: ...` so you can confirm which canonical directory it used.

Use the `/generate` prompt in Copilot Chat (pointing at [github/.github/prompts/generate.prompt.md](github/.github/prompts/generate.prompt.md)) from inside the repo you are customizing. It copies the canonical templates into that repo's `.github/prompts/` folder, fills them with repo-specific context, and leaves them ready for Copilot Chat. After `/generate` updates a repo, rerun `./install.sh` from the dotfiles root so future sessions keep publishing the latest generator. To send the generator somewhere other than the default VS Code profile, set `COPILOT_PROMPTS_DIR` (and `CODE_VARIANT` when needed) before running `./install.sh`.
