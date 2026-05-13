---
name: sync-skill-stats
description: Fire-and-forget skill invocation logger. Captures every Skill tool call to a local JSONL via a PostToolUse hook, syncs the log to a private GitHub repo (SahilAshar/skill-stats), and provides ad-hoc query modes. Modes — setup (install hook), sync (push log), pull (fetch latest), stats (query).
allowed-tools: Bash, Read, Edit, Write, Grep, Glob, AskUserQuestion
disable-model-invocation: true
---

# Sync Skill Stats

Logs every Claude Code skill invocation to a local JSONL via a PostToolUse hook, then syncs to a private GitHub repo (`SahilAshar/skill-stats`) on demand. One JSONL line per skill call. Per-machine files in the repo so no cross-machine merge conflicts.

**Data flow:**

```
Skill tool call
  ↓ PostToolUse hook (log.sh)
~/.claude/skill-usage.jsonl                    (local, append-only)
  ↓ /sync-skill-stats sync
~/.cache/claude-skill-stats/                   (local clone of private repo)
  logs/YYYY-MM-<hostname>.jsonl                (per-machine, per-month)
  ↑ git push (PAT)
github.com/SahilAshar/skill-stats              (private)
```

Pick a mode from the user's invocation argument: `setup`, `sync`, `pull`, or `stats`. If no mode is given, ask which one.

---

## Mode: `setup`

Install the hook so logging starts. Runs once per machine. Safe to re-run — idempotent.

1. **Verify `jq` is installed.** Run `which jq`. If missing, tell the user (e.g., `brew install jq` on macOS, `apt-get install jq` on Linux) and stop.

2. **Resolve the absolute path to `log.sh` dynamically.** Do NOT hardcode `/Users/...` or any specific path — the dotfiles checkout location varies across machines (`~/dotfiles` on macOS, `/workspaces/dotfiles` in Codespaces, etc.).
   ```bash
   # Try, in order: DOTFILES_DIR env var, ~/dotfiles, /workspaces/dotfiles
   for candidate in "$DOTFILES_DIR" "$HOME/dotfiles" "/workspaces/dotfiles"; do
     [ -z "$candidate" ] && continue
     hook_candidate="$candidate/.claude/skills/sync-skill-stats/log.sh"
     if [ -f "$hook_candidate" ]; then
       HOOK_PATH=$(cd "$(dirname "$hook_candidate")" && pwd)/log.sh
       break
     fi
   done
   ```
   If none resolved, ask the user where their dotfiles checkout lives.

3. **Ensure log script is executable.** `chmod +x "$HOOK_PATH"`.

4. **Back up `~/.claude/settings.json` before editing.**
   ```bash
   if [ -f ~/.claude/settings.json ]; then
     cp ~/.claude/settings.json ~/.claude/settings.json.bak.$(date +%Y%m%d-%H%M%S)
   fi
   ```
   Tell the user where the backup landed.

5. **Install the PostToolUse hook in `~/.claude/settings.json`.**
   - Read the existing `~/.claude/settings.json` (create with `{}` if missing).
   - Look for an existing `PostToolUse` entry with `matcher: "Skill"`:
     - **None exists:** add a new entry pointing the command at `$HOOK_PATH`.
     - **Ours already (command path matches a `*/sync-skill-stats/log.sh`):** update the command path in place to `$HOOK_PATH` (handles a moved dotfiles checkout). Tell the user it was refreshed.
     - **Foreign hook on the `Skill` matcher (different command, not ours):** do NOT modify it. Show the user the conflict and stop — they need to merge manually.
   - Use jq for the edit, not hand-rolled JSON, to preserve the rest of `settings.json` cleanly.
   - The merged structure should look like:
     ```json
     {
       "hooks": {
         "PostToolUse": [
           {
             "matcher": "Skill",
             "hooks": [
               { "type": "command", "command": "<absolute path to log.sh>" }
             ]
           }
         ]
       }
     }
     ```
   - The command MUST be an absolute path (no `~`) — Claude Code does not always expand it.

6. **Clone the private repo locally.**
   ```bash
   mkdir -p ~/.cache
   if [ -d ~/.cache/claude-skill-stats/.git ]; then
     git -C ~/.cache/claude-skill-stats pull --rebase
   else
     git clone https://github.com/SahilAshar/skill-stats.git ~/.cache/claude-skill-stats
   fi
   ```

7. **Confirm.** Tell the user:
   - Hook installed at: `$HOOK_PATH`
   - settings.json backup: `<backup path>`
   - Local log: `~/.claude/skill-usage.jsonl`
   - Clone: `~/.cache/claude-skill-stats`
   - Next: invoke a few skills, then run `/sync-skill-stats sync` to push the first batch.

---

## Mode: `sync`

Push the local JSONL into the private repo.

1. **Check there's something to sync.** If `~/.claude/skill-usage.jsonl` is empty or missing, tell the user and stop.

2. **Determine target file.** Use month + short hostname:
   ```bash
   month=$(date +%Y-%m)
   host=$(hostname -s)
   target="logs/${month}-${host}.jsonl"
   ```

3. **Pull latest first** to minimize the chance of conflict on push:
   ```bash
   git -C ~/.cache/claude-skill-stats pull --rebase
   ```

4. **Append local log to the target file.**
   ```bash
   mkdir -p ~/.cache/claude-skill-stats/logs
   cat ~/.claude/skill-usage.jsonl >> ~/.cache/claude-skill-stats/$target
   ```

5. **Commit and push using PAT auth** (same pattern as `sync-dotfiles`).
   - Ask user for a fine-grained PAT scoped to `SahilAshar/skill-stats` with Contents (Read & Write). Direct to `https://github.com/settings/tokens?type=beta` if needed.
   - NEVER echo, log, or persist the PAT.
   - Commit author identity set inline (do NOT modify git config):
     ```bash
     git -C ~/.cache/claude-skill-stats -c user.name="Sahil Ashar" -c user.email="SahilAshar@users.noreply.github.com" add logs/
     git -C ~/.cache/claude-skill-stats -c user.name="Sahil Ashar" -c user.email="SahilAshar@users.noreply.github.com" commit -m "Sync $host skill stats $(date -u +%Y-%m-%dT%H:%MZ)"
     git -C ~/.cache/claude-skill-stats push https://<PAT>@github.com/SahilAshar/skill-stats.git HEAD:main
     ```

6. **On success, truncate the local log:**
   ```bash
   : > ~/.claude/skill-usage.jsonl
   ```
   This prevents double-counting on the next sync. If the push fails, leave the local log intact.

7. **Report:** lines synced, target file, commit SHA.

---

## Mode: `pull`

Fetch the latest stats from upstream without pushing.

```bash
git -C ~/.cache/claude-skill-stats pull --rebase
```

Report what's new (commit count, files changed).

---

## Mode: `stats`

Generate a usage digest. Default: last 30 days, top skills, per-machine and combined.

1. **Pull latest first** (`git -C ~/.cache/claude-skill-stats pull --rebase`).

2. **Source all logs** including the unsynced local one:
   ```bash
   sources=(~/.cache/claude-skill-stats/logs/*.jsonl ~/.claude/skill-usage.jsonl)
   ```

3. **Use `jq` for queries.** Examples:
   ```bash
   # Top skills, all-time
   cat "${sources[@]}" 2>/dev/null | jq -r '.skill' | sort | uniq -c | sort -rn

   # Top skills last 30 days
   since=$(date -u -v-30d +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -d '30 days ago' +%Y-%m-%dT%H:%M:%SZ)
   cat "${sources[@]}" 2>/dev/null | jq -r --arg since "$since" 'select(.ts >= $since) | .skill' | sort | uniq -c | sort -rn

   # By machine
   cat "${sources[@]}" 2>/dev/null | jq -r '"\(.host)\t\(.skill)"' | sort | uniq -c | sort -rn | head -30

   # By repo (cwd basename)
   cat "${sources[@]}" 2>/dev/null | jq -r '.cwd | split("/") | .[-1]' | sort | uniq -c | sort -rn | head -20
   ```

4. **Present results** as a clean markdown table. Ask the user if they want any specific slice (per-skill timeline, single-machine breakdown, etc.).

If the user passes a specific query intent in their invocation (e.g., "stats for last week" / "stats by repo"), tailor the jq filter to match.

---

## Important Safety Notes

- The hook must NEVER block or fail. The log.sh script wraps everything in `{ ... } 2>/dev/null || true` and always exits 0.
- NEVER persist the PAT to disk, git config, or environment files. In-memory only for the duration of the sync.
- NEVER modify `~/.cache/claude-skill-stats`'s git remote — push via the full PAT URL inline.
- If `sync` fails, leave the local JSONL intact so nothing is lost.
- The repo is private; still avoid logging full args/prompts. The hook captures skill name + cwd + host + session ID only.
