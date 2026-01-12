---
name: generate
description: Generate repo-specific prompt templates for this repo
---

# Prompt Generator Instructions

Create four sub-agent outputs by filling in the existing template files below. Do **not** create new files or reformat the templates; only replace the placeholder slots inside each file.

## Assignment
- Sub-agent A: `.github/prompts/plan.prompt.md`
- Sub-agent B: `.github/prompts/implement.prompt.md`
- Sub-agent C: `.github/prompts/test.prompt.md`
- Sub-agent D: `.github/prompts/deploy.prompt.md`

## Requirements
- Each sub-agent must fill in the template placeholders with repository-specific details.
- Each sub-agent must cite **specific files and/or commands found in the repo** (e.g., `install.sh`, `apt-packages.txt`, `rg 'pattern' file`, `ls path`).
- Use **exact** commands or file paths from the repository; avoid generic placeholders.
- Keep the existing section headings: Goal, Inputs, Steps, Output Format.
- Do not add new sections or remove any template fields.

## Output
Return the four filled templates (one per sub-agent) with placeholders replaced by concrete repo-specific data and citations.

## Post-generation
Instruct the user to rerun `./install.sh` from the dotfiles repo so the updated prompts sync for future sessions (the script calls `scripts/install-prompts.sh` internally).
