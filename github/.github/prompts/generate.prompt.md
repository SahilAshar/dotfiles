---
name: generate
description: Generate repo-specific prompt templates for this repo
---

# Prompt Generator Instructions

Running `/generate` orchestrates multiple subagents (discovery, template copying, content generation) to scaffold repo-specific prompts. Coordinate them to perform the workflow below.

## Workflow
1. **Locate workspace** — Discover or confirm the active repository path (use explicit args, env vars, or detect from open files). Ensure the repo is writable and contains/creates a `.github/prompts/` folder.
2. **Find dotfiles source** — Detect the dotfiles installation directory (default `$HOME/dotfiles`; also check `DOTFILES_DIR` or other exported hints). Verify that `github/.github/prompts/*.prompt.md` exists there.
3. **Copy canonical templates** — For each template (`plan`, `implement`, `test`, `deploy`), copy the canonical file from the dotfiles repo into the target repo's `.github/prompts/` before editing. Create the destination directory if missing.
4. **Fill templates** — Launch dedicated subagents for each prompt:
	- Sub-agent A edits `.github/prompts/plan.prompt.md`
	- Sub-agent B edits `.github/prompts/implement.prompt.md`
	- Sub-agent C edits `.github/prompts/test.prompt.md`
	- Sub-agent D edits `.github/prompts/deploy.prompt.md`

	Each subagent must gather repository context (file listings, commands, config files) and replace only the placeholder regions inside the template. Keep existing headings (`Goal`, `Inputs`, `Steps`, `Output Format`) and cite concrete files or commands from the repo.
5. **Validate & report** — Confirm all four files exist in the target repo with updated content and summarize what changed.

## Output
Return the four filled templates (one per subagent) with placeholders replaced by concrete repo-specific data and citations. Mention if additional helper subagents (e.g., file discovery, template copier) were used.

## Post-generation
Instruct the user to rerun `./install.sh` from the dotfiles repo so the updated prompts sync for future sessions (the script calls `scripts/install-prompts.sh` internally).
