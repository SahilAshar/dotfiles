# Copilot Chat Prompts

This repo ships a reusable prompt generator to create repo-specific prompts.

## Files

- `prompts/generate.md` — generates repo-specific prompts and instructions.

## Install

Run the installer from the repo root:

```bash
scripts/install-prompts.sh
```

By default, prompts are symlinked into your VS Code user prompts directory:

- macOS: `~/Library/Application Support/Code/User/prompts`
- Linux: `~/.config/Code/User/prompts`

### Options

Symlink prompt files (default):

```bash
scripts/install-prompts.sh
```

Copy instead of symlinking:

```bash
scripts/install-prompts.sh --copy
```

Override the destination directory:

```bash
scripts/install-prompts.sh --dest "$HOME/.config/Code/User/prompts"
```

Use a different VS Code variant directory (for example, Insiders):

```bash
CODE_VARIANT="Code - Insiders" scripts/install-prompts.sh
```

## Use in Copilot Chat

Open Copilot Chat and use `/prompt` to select `generate.md`, then run it to create
repo-specific `plan`, `implement`, `test`, and `deploy` prompts for the project.
