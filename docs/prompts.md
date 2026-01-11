# Copilot Chat Prompts

This repo ships reusable prompt files for a Docker + Makefile workflow.

## Files

- `prompts/plan.md` — planning steps.
- `prompts/implement.md` — implementation guidance.
- `prompts/test.md` — testing guidance.
- `prompts/docker-run.md` — Docker run instructions.

## Install

Run the installer from the repo root:

```bash
scripts/install-prompts.sh
```

By default, prompts are copied into your VS Code user prompts directory:

- macOS: `~/Library/Application Support/Code/User/prompts`
- Linux: `~/.config/Code/User/prompts`

### Options

Copy or symlink prompt files:

```bash
scripts/install-prompts.sh --symlink
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

Open Copilot Chat and use `/prompt` to select one of the installed prompt files.
