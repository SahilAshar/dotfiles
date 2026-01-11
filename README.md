# Dotfiles

Bootstrap and configure local dev settings with a repeatable installer.

## Quick start

Run the bootstrap installer from the repo root:

```bash
./install.sh
```

The script is safe to re-run and will skip already installed components.

## Prompts for Copilot Chat

This repo ships reusable Copilot Chat prompt templates and an installer.

Install prompts into your VS Code profile (symlink by default):

```bash
scripts/install-prompts.sh
```

Generate repo-specific prompts using `.github/prompts/generate.prompt.md`, then re-run the
installer so the new prompts appear in the `/prompt` list:

```bash
scripts/install-prompts.sh
```

See `docs/prompts.md` for full details and options.
