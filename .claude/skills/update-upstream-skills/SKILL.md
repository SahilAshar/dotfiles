---
name: update-upstream-skills
description: Sync local skills with their upstream repos (mattpocock/skills, hardikpandya/stop-slop). Use when asked to "update skills", "sync upstream", "check for skill updates", or "update upstream skills".
disable-model-invocation: true
---

# Update Upstream Skills

Sync locally-maintained skills with their upstream repositories. All provenance, merge notes, and update history live in [UPSTREAM.md](./UPSTREAM.md).

Read [UPSTREAM.md](./UPSTREAM.md) first — it is the source of truth for which skills we track, where they come from, and what local adaptations we maintain.

## Process

### 1. Fetch the upstream repo tree

```bash
gh api 'repos/mattpocock/skills/git/trees/main?recursive=1' --jq '.tree[].path' | grep '\.md$'
```

Scan for new skills that don't appear in UPSTREAM.md — either in the tracked table or the "don't pull" list. Flag any new ones to the user.

### 2. For each tracked skill, fetch and diff

For every row in the "Skills we pull from this repo" table in UPSTREAM.md:

```bash
gh api "repos/mattpocock/skills/contents/<upstream-path>/SKILL.md" --jq '.content' | base64 -d
```

Compare against the local version at `~/.claude/skills/<local-name>/SKILL.md` (or `~/dotfiles/.claude/skills/<local-name>/SKILL.md` depending on context).

Also fetch and compare any supporting files (format docs, reference files) in the same upstream directory.

Categorize each skill into one of:
- **No changes** — upstream matches local
- **Direct update** — upstream improved, no local adaptations at risk (e.g. `debug`, `handoff`, `teach`)
- **Selective merge** — upstream changed but we maintain local adaptations that must be preserved (e.g. inline glossary in `improve-codebase-architecture`, self-contained grilling logic in `grill-me`/`grill-with-docs`)
- **Delegation stub warning** — upstream replaced content with a thin wrapper delegating to another skill we don't carry

### 3. Check for delegation stubs

This is the most important gotcha. Matt refactors skills into thin wrappers:
- `grill-me` → "Run a `/grilling` session."
- `grill-with-docs` → "Run a `/grilling` session, using the `/domain-modeling` skill."
- `improve-codebase-architecture` → references `/codebase-design` for vocabulary

When this happens:
1. Do NOT replace our version with the stub
2. Fetch the skill(s) being delegated to
3. Merge any new content from those delegated skills into our self-contained version

### 4. Check hardikpandya/stop-slop

```bash
gh api 'repos/hardikpandya/stop-slop/commits?since=<last-update-date>' --jq '.[].sha'
```

If there are new commits, fetch the updated files and compare. The pinned commit is recorded in the SKILL.md header comment and in UPSTREAM.md.

### 5. Present changes to user

Show a summary table:

| Skill | Status | What changed |
|---|---|---|
| `debug` | Direct update | New phase added for X |
| `grill-me` | No changes | — |
| ... | ... | ... |

For each skill with changes, show the relevant diff or describe the changes. Ask the user which updates to apply.

### 6. Apply updates

Apply approved changes. For selective merges, be careful to preserve:
- Local skill names (e.g. `debug` not `diagnosing-bugs`)
- Inline glossaries/vocabularies we maintain because we don't carry the referenced skill
- Self-contained grilling/interview logic
- Local supporting file references (e.g. `deep-modules.md`, `interface-design.md`, `LANGUAGE.md`)
- Any `description` field customizations in frontmatter

### 7. Update UPSTREAM.md

After all changes are applied:
1. Add a row to the update log with today's date and a summary of what changed
2. Update the pinned commit/date for stop-slop if it changed
3. Update any notes in the skills table if the merge strategy changed
4. Add any newly discovered upstream skills to the "don't pull" list with a reason, or to the tracked table if we're adopting them
