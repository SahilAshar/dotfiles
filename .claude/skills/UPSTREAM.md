# Upstream Skill Sources

Tracks where skills came from and how to update them.

## mattpocock/skills

**Repo**: https://github.com/mattpocock/skills
**Structure**: `skills/{engineering,productivity,misc,personal,in-progress,deprecated}/`

### Skills we pull from this repo

| Local skill | Upstream path | Notes |
|---|---|---|
| `debug` | `skills/engineering/diagnosing-bugs/` | Renamed to `debug` locally. Full replacement — upstream is the source of truth. |
| `grill-me` | `skills/productivity/grill-me/` | Upstream is now a thin stub delegating to `/grilling`. We keep a **self-contained** version with the grilling logic inlined, since we don't carry the `/grilling` skill. |
| `grill-with-docs` | `skills/engineering/grill-with-docs/` | Same situation — upstream delegates to `/grilling` + `/domain-modeling`. We keep self-contained with full domain awareness + ADR/CONTEXT.md logic inlined. |
| `handoff` | `skills/productivity/handoff/` | Close to upstream. |
| `improve-codebase-architecture` | `skills/engineering/improve-codebase-architecture/` | Upstream references `/codebase-design` for vocabulary. We keep the **inline glossary** (from LANGUAGE.md) since we don't carry that skill. HTML report format pulled from upstream. |
| `tdd` | `skills/engineering/tdd/` | Close to upstream. We keep local `deep-modules.md` and `interface-design.md` (upstream replaced these with `/codebase-design` references). |
| `teach` | `skills/productivity/teach/` | Full copy from upstream. |

### Skills we DON'T pull (upstream-only)

These exist in the repo but we don't use them — either they're Matt-specific, delegation stubs, or we have our own versions:

- `ask-matt` — Matt-specific router
- `codebase-design` — Deep module vocabulary. Our `improve-codebase-architecture` inlines the relevant parts.
- `domain-modeling` — ADR/CONTEXT.md management. Our `grill-with-docs` inlines this.
- `grilling` — Core interview loop. Inlined into `grill-me` and `grill-with-docs`.
- `implement` — Implementation skill
- `prototype` — Throwaway prototype builder
- `resolving-merge-conflicts` — Merge conflict skill
- `setup-matt-pocock-skills` — Setup wizard for his full skill suite
- `to-issues` — Break plans into GitHub issues
- `to-prd` — Convert discussions into PRDs
- `triage` — Issue state machine (Matt-specific labels/workflow)
- `writing-great-skills` — Skill composition reference
- `decision-mapping`, `review`, `writing-beats`, `writing-fragments`, `writing-shape` — In-progress skills

### How to update

1. Browse the repo tree:
   ```bash
   gh api 'repos/mattpocock/skills/git/trees/main?recursive=1' --jq '.tree[].path' | grep '\.md$'
   ```

2. For each skill in the table above, fetch and compare:
   ```bash
   gh api "repos/mattpocock/skills/contents/<upstream-path>/SKILL.md" --jq '.content' | base64 -d
   ```

3. **Watch for delegation stubs.** Matt refactors skills into thin wrappers that call other skills (e.g. `grill-me` → "Run a `/grilling` session"). If upstream becomes a stub for a skill we don't carry, keep our self-contained version and merge any new content from the delegated skill instead.

4. **Check supporting files** too (format docs, reference files) — those tend to get updated independently of SKILL.md.

5. After updating, bump the date below.

### Update log

| Date | What changed |
|---|---|
| 2026-06-18 | Initial sync. Replaced `debug` with upstream `diagnosing-bugs` (6-phase discipline). Added HTML report to `improve-codebase-architecture`. Updated `handoff` (redaction, disable-model-invocation). Updated `grill-me` (wait-for-feedback). Updated `tdd` (CONTEXT.md awareness). Added `teach` skill (new). |

---

## hardikpandya/stop-slop

**Repo**: https://github.com/hardikpandya/stop-slop
**Pinned at**: `8da1f03` (2026-03-18)

| Local skill | Notes |
|---|---|
| `stop-slop` | Full copy. Source comment in SKILL.md header tracks the pinned commit. |

### How to update

Check the repo for changes since the pinned commit:
```bash
gh api 'repos/hardikpandya/stop-slop/commits?since=2026-03-18' --jq '.[].sha'
```

---

## Local-only skills

These are ours — not pulled from any upstream:

- `design-review`
- `pr-description`
- `readability`
- `refactor`
- `research-to-one-pager`
- `review-bottom-up`
- `review-top-down`
- `serve-insights`
- `session-log`
- `sync-dotfiles`
- `test-strategy`
