---
name: merge-risk
description: 'Assess the risk of merging a PR and give a low/medium/high verdict across alignment, impact, verification, rollback cost, and error detection. Use when asked "merge risk", "is this safe to merge", "should I merge this", "risk check this PR", or when assessing the risk of merging a PR or branch.'
license: MIT
metadata:
  source: "https://github.com/warpdotdev/common-skills/blob/main/.agents/skills/merge-risk/SKILL.md"
  pinned: "8792394 (2026-10-20)"
  credits:
    skill: pr
    author: Matt Pocock
    url: "https://github.com/mattpocock/skills/blob/main/skills/engineering/pr/SKILL.md"
---

## Gather inputs

Before scoring, collect what the verdict depends on:

- **The PR**: `gh pr view <number> --json title,body,files,closingIssuesReferences,statusCheckRollup` and `gh pr diff <number>`. For a local branch with no PR, use `git diff <base>...HEAD` and `git log <base>..HEAD --oneline`; ask for the base if it isn't obvious.
- **The source issue**, when referenced: `gh issue view <number>`.
- **CI status**: from `statusCheckRollup`, or `gh pr checks <number>`.
- **Evidence in the PR body**: screenshots, recordings, profiling, test output.

Read the changed code itself, not just the description — verdicts must be grounded in the diff.

Output format:

```
**Merge risk: <low-medium-high>**

**<category>:** <verdict>
<list gaps that increase risk. Use bullets, keep succinct. Include links to relevant files as needed>

<...list all categories>
```

These are the **categories** and **verdicts** that affect risk, with descriptions of what "low risk" means:

- **Alignment (poor ⚠️ / decent 👀 / good ✅):** Code aligns with the description and source issue, when present. Behavior assumptions and drive-bys must be documented.
- **Impact (large ⚠️ / medium 👀 / small ✅):** Scope is contained and away from sensitive code paths.
  - Consider blast radius: potential impact or scope of the changes introduced by this PR. Consider all possibilities. Examples are layout shift, breakages for consumers, mobile responsiveness, etc.
  - Sensitive areas carry outsized risk regardless of diff size: auth, permissions, payments, PII, secrets, data migrations, dependency bumps, and infra or config changes. Flag any that are touched, and call out anything that widens access, weakens validation, or logs sensitive data.
- **Verification (poor ⚠️ / decent 👀 / good ✅):** Behavior is verified, where applicable.
  - Changes to the user experience **need** end-to-end proof as screenshots or recordings. Changes that could meaningfully affect performance **need** profiling. Prefer before-and-after evidence to standalone proof. When this coverage is lacking, it's a failure.
  - Edge cases must be tested, or documented when they aren't; review the code closely and link the user to relevant code when only documentation is present.
- **Rollback cost (high ⚠️ / medium 👀 / low ✅):** The code is reversible once merged. Consider one-way vs. two-way doors. You can walk back through two-way doors, but not one-way doors. A PR that is cheap to roll back is lower risk. Changes that involve destructive actions or hard-to-reverse decisions are one-way doors.
- **Error detection (poor ⚠️ / decent 👀 / good ✅ / N/A ✅):** If applicable, critical flows should be monitored; If this breaks in production, someone should find out before users report it. Look for swallowed errors or fallbacks that hide breakage.

Generate a risk score for merging this PR on a scale of low - medium - high.

Verdicts:

- ⚠️ = 3
- 👀 = 2
- ✅ = 1

Weights:

- Impact = 2x
- Verification = 2x
- Rollback cost = 1.5x
- Error detection = 1x
- Alignment = 1x

Score = Σ(score × weight) / Σ(weights).

- low: < 1.5
- medium: 1.5 – < 2.25
- high: ≥ 2.25

Keep the numerical score and its calculations internal; do not include them in the output.
