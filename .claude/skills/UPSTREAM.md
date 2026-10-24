# Upstream Skill Sources

Tracks where skills came from and how to update them.

## mattpocock/skills

**Repo**: https://github.com/mattpocock/skills
**Structure**: `skills/{engineering,productivity,misc,personal,in-progress,deprecated}/`

### Skills we pull from this repo

| Local skill | Upstream path | Notes |
|---|---|---|
| `debug` | `skills/engineering/diagnosing-bugs/` | Renamed to `debug` locally. Full replacement — upstream is the source of truth. |
| `grill-me` | `skills/productivity/grill-me/` | Upstream is now a thin stub delegating to `/grilling`. We keep a **self-contained** version with the grilling logic inlined, since we don't carry the `/grilling` skill. We deliberately keep **one question at a time**; upstream `/grilling` now asks the whole frontier in numbered rounds. |
| `grill-with-docs` | `skills/engineering/grill-with-docs/` | Same situation — upstream delegates to `/grilling` + `/domain-modeling`. We keep self-contained with full domain awareness + ADR/GLOSSARY.md logic inlined (`CONTEXT-FORMAT.md` renamed to `GLOSSARY-FORMAT.md` to follow upstream). |
| `handoff` | `skills/productivity/handoff/` | Close to upstream. |
| `improve-codebase-architecture` | `skills/engineering/improve-codebase-architecture/` | Upstream references `/codebase-design` for vocabulary. We keep the **inline glossary** (from LANGUAGE.md) since we don't carry that skill. HTML report format pulled from upstream. |
| `tdd` | `skills/engineering/tdd/` | Close to upstream. We keep local `deep-modules.md` and `interface-design.md` (upstream replaced these with `/codebase-design` references). |
| `teach` | `skills/productivity/teach/` | Full copy from upstream. |
| `research` | `skills/engineering/research/` | Full copy from upstream. |
| `code-review` | `skills/engineering/code-review/` | Adapted: removed `/setup-matt-pocock-skills` dep, uses `gh` CLI for issue/PR fetching. Smell baseline kept inline. |
| `wayfinder` | `skills/engineering/wayfinder/` | Heavy local adaptation: inlined grilling, removed issue-tracker dep (local markdown in `.scratch/`), removed `/domain-modeling` `/research` `/prototype` skill refs. Self-contained. Most upstream changes are GitHub-tracker-specific; port by hand, never 3-way merge. |
| `retro` | `skills/engineering/retro/` | Full copy. Depends on `writing-for-agents`. |
| `writing-for-agents` | `skills/productivity/writing-for-agents/` | Full copy (incl. `SKILL-MECHANICS.md`). Replaces the old `writing-great-skills` entry. |
| `wait-what` | `skills/productivity/wait-what/` | Full copy. |

### Skills we DON'T pull (upstream-only)

These exist in the repo but we don't use them — either they're Matt-specific, delegation stubs, or we have our own versions:

- `ask-matt` — Matt-specific router
- `codebase-design` — Deep module vocabulary. Our `improve-codebase-architecture` inlines the relevant parts.
- `domain-modeling` — ADR/GLOSSARY.md management. Our `grill-with-docs` inlines this.
- `grilling` — Core interview loop. Inlined into `grill-me` and `grill-with-docs`.
- `implement` — Implementation skill
- `prototype` — Throwaway prototype builder
- `setup-matt-pocock-skills` — Setup wizard for his full skill suite
- `triage` — Issue state machine (Matt-specific labels/workflow)
- `pr` — PR body writer. Overlaps our `pr-description`.
- `implement-spec` — Implements `/to-spec` + `/to-tickets` output; needs the tracker setup.
- `to-spec` — Convert discussions into specs (was `to-prd`)
- `to-tickets` — Break plans into tickets (was `to-issues`)
- `chief-of-staff`, `batch-grill-me`, `claude-handoff`, `loop-me`, `setup-ts-deep-modules`, `to-questionnaire`, `wizard` — In-progress skills
- `edit-article` — Matt-specific personal skill
- `obsidian-vault` — Matt-specific personal skill
- `git-guardrails-claude-code`, `migrate-to-shoehorn`, `scaffold-exercises`, `setup-pre-commit` — Misc/niche skills
- `writing-beats`, `writing-fragments`, `writing-shape` — In-progress writing skills

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

5. **Skip `agents/openai.yaml`** files — Codex-only metadata.

6. **Prefer a 3-way merge** (`git merge-file local base upstream`) against the upstream commit from the last sync date, so local adaptations survive. Upstream em-dash → colon rewrites cause noisy conflicts; take upstream wording unless the hunk carries a local adaptation.

7. After updating, bump the date below.

### Update log

| Date | What changed |
|---|---|
| 2026-06-18 | Initial sync. Replaced `debug` with upstream `diagnosing-bugs` (6-phase discipline). Added HTML report to `improve-codebase-architecture`. Updated `handoff` (redaction, disable-model-invocation). Updated `grill-me` (wait-for-feedback). Updated `tdd` (CONTEXT.md awareness). Added `teach` skill (new). |
| 2026-08-02 | Updated `tdd`: new Seams section, tautological anti-pattern, simplified rules of the loop (kept local deep-modules/interface-design refs). Updated `improve-codebase-architecture`: added YAGNI scoping and git-log hot-spot analysis to Explore step. Added `research` (full copy). Added `code-review` (adapted, removed setup dep). Added `wayfinder` (heavy adaptation: self-contained, local-file tracker, inlined grilling). Catalogued remaining new upstream skills (to-spec, to-tickets, and in-progress/misc). |
| 2026-10-24 | Synced to `5beb35b`. `debug`: secret redaction, red-capable loop checklist, `scripts/hitl-loop.template.sh` (was referenced but missing). `code-review`: search for standards files, foreground sub-agents (kept `gh` fetching, no setup dep). `tdd`: note what each seam catches/misses. `teach`: anchored workspace paths, quiz answer position. `handoff`: explicit temp-dir resolution. `wayfinder`: real ids in cross-refs, resolve by Type field (hand-ported). `improve-codebase-architecture`: harness-neutral sub-agent. `grill-me`/`grill-with-docs`: word questions so "yes" accepts the recommendation. Adopted upstream `CONTEXT.md` → `GLOSSARY.md` rename everywhere (grill-with-docs migrates a legacy file). Added `retro`, `writing-for-agents`, `wait-what`. |

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

## ayghri/i-have-adhd

**Repo**: https://github.com/ayghri/i-have-adhd
**Pinned at**: `1ecea19` (2026-10-11)

| Local skill | Notes |
|---|---|
| `i-have-adhd` | Full copy. Source comment in SKILL.md header tracks the pinned commit. |

### How to update

Check the repo for changes since the pinned commit:
```bash
gh api 'repos/ayghri/i-have-adhd/commits?since=2026-10-11' --jq '.[].sha'
```

### Update log

| Date | What changed |
|---|---|
| 2026-07-21 | Initial install. Full copy of `skills/i-have-adhd/SKILL.md`. |
| 2026-08-02 | Updated to latest. Added Persistence section, expanded tangent/restate rules, 2 new "when to break rules" items (rule-fights-task, rule-fights-harness), expanded pre-send check (hedge caveat, idiom ban). |
| 2026-10-24 | Updated to `1ecea19` (v0.4.1). Rule 9 now groups/ranks to ~5 per group without dropping items; metadata flattened for strict YAML parsers. |

---

## warpdotdev/common-skills

**Repo**: https://github.com/warpdotdev/common-skills
**Pinned at**: `8792394` (2026-10-20)

| Local skill | Upstream path | Notes |
|---|---|---|
| `merge-risk` | `.agents/skills/merge-risk/` | Adapted: expanded `description` with trigger phrases, added a "Gather inputs" section (`gh pr view`/`gh pr diff`, linked issue, CI status). Scoring rubric and output format unchanged. Upstream credits Matt Pocock's `pr` skill, which is a PR-body writer — not tracked here. |

### How to update

Check the repo for changes since the pinned commit:
```bash
gh api 'repos/warpdotdev/common-skills/commits?path=.agents/skills/merge-risk/SKILL.md&since=2026-10-20' --jq '.[].sha'
```

Preserve the local `description` and "Gather inputs" section when merging.

### Update log

| Date | What changed |
|---|---|
| 2026-10-20 | Initial install from `8792394`. |

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
- `technical-writing-cleanup`
- `writing-refinement`
