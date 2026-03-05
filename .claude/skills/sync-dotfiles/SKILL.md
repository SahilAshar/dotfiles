---
name: sync-dotfiles
description: Sync local dotfiles changes back to the personal GitHub repo (SahilAshar/dotfiles) after reviewing for enterprise leaks. Handles leak scanning, selective staging, PAT auth, and PR creation.
allowed-tools: Bash, Read, Grep, Glob, AskUserQuestion
---

# Sync Dotfiles to Personal GitHub

Sync changes from `~/dotfiles` back to the user's personal GitHub repo (`SahilAshar/dotfiles`) on `github.com`. This is designed for enterprise Codespace environments where `gh` is configured for the enterprise instance, not personal GitHub.

## Instructions

### Step 1: Assess Changes

Run `git status` and `git diff` in `~/dotfiles` to understand what has been modified, staged, or is untracked. Present a concise summary to the user.

If there are no changes, tell the user: "No changes detected in ~/dotfiles. Nothing to sync." Then stop.

### Step 2: Leak Review

This is the most critical step. Scan ALL diffs (`git diff`) and untracked file contents for enterprise-specific content that must NOT be pushed to a public/personal repo.

Search for:
- Enterprise/corporate domains (any domain that isn't a well-known public service)
- Internal hostnames, paths, or tooling references specific to the enterprise environment
- Corporate credentials, emails with enterprise domains, API tokens, secrets
- Internal URLs, IP addresses, or proxy configurations
- References to internal tools, services, or infrastructure not appropriate for a public repo

Present findings to the user in a clear table/list format showing:
- Which file contains the finding
- The specific line(s) flagged
- Why it was flagged

Then ask the user:
- Which changes to **include** in the sync
- Which changes to **exclude**
- Whether any flagged items are actually safe to include (false positives)

If no leaks are found, tell the user the changes look clean and confirm they want to proceed.

### Step 3: Selective Staging

Stage only the user-approved changes:
- For files that are entirely clean: use `git add <file>`
- For files with mixed clean/enterprise content: use `git add -p <file>` and guide the user through accepting/rejecting individual hunks
- For untracked files that are approved: use `git add <file>`

Verify the staging is correct with `git diff --cached --stat`.

### Step 4: Authenticate with Personal GitHub

The `gh` CLI in this environment is configured for the enterprise GitHub instance and cannot be used for `github.com`. Instead, use a Personal Access Token (PAT).

Ask the user for a **GitHub Personal Access Token** (fine-grained) with:
- **Repository access**: `SahilAshar/dotfiles`
- **Permissions**: Contents (Read and Write), Pull Requests (Read and Write)

If the user doesn't have one, direct them to: `https://github.com/settings/tokens?type=beta`

IMPORTANT: Never echo, log, or display the PAT after receiving it. Store it only in a shell variable for the duration of this workflow.

### Step 5: Branch, Commit, and Push

1. Create a descriptive branch from the current HEAD:
   ```
   git checkout -b sync/<short-description>-<YYYYMMDD>
   ```
   Use a short description derived from the changes (e.g., `sync/statusline-shell-tweaks-20260305`).

2. Commit staged changes with a clear message summarizing what changed. Use `-c` flags to set the author/committer identity inline (do NOT modify git config):
   ```
   git -c user.name="Sahil Ashar" -c user.email="SahilAshar@users.noreply.github.com" commit -m "<message>"
   ```

3. Push using the PAT embedded in the remote URL (this avoids modifying the user's git remote config permanently):
   ```
   git push https://<PAT>@github.com/SahilAshar/dotfiles.git HEAD:<branch-name>
   ```
   IMPORTANT: Do NOT modify the existing git remote. Use the full URL for the push only.

### Step 6: Open a Pull Request

Since `gh` may point to the enterprise instance, create the PR via the GitHub REST API directly:

```bash
curl -s -X POST \
  -H "Authorization: Bearer $PAT" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/SahilAshar/dotfiles/pulls \
  -d "{
    \"title\": \"<PR title>\",
    \"head\": \"<branch-name>\",
    \"base\": \"main\",
    \"body\": \"<PR description>\"
  }"
```

Extract and display the PR URL (`html_url`) from the response.

### Step 7: Cleanup

After the PR is created, offer the user two options:

1. **Clean up now**: Switch back to `main` and delete the local sync branch
   ```
   git checkout main
   git branch -D sync/<branch-name>
   ```
2. **Keep the branch**: Stay on the sync branch in case they want to make more changes

Also remind the user that the PAT was only used in-memory and was not persisted anywhere.

## Important Safety Notes

- NEVER commit or push without explicit user approval of the changes
- NEVER store the PAT to disk, git config, or environment files
- NEVER modify the existing git remote configuration
- ALWAYS present leak review findings before staging
- If in doubt about whether something is enterprise-specific, flag it and ask the user
