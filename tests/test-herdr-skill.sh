#!/usr/bin/env bash
set -euo pipefail

# Static checks on the Herdr bootstrap skill; no live Herdr CLI is needed.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill="$REPO_ROOT/.claude/skills/herdr/SKILL.md"
BASH_BIN="$(command -v bash)"

# Execute the exact environment guard from the bootstrap.
# shellcheck disable=SC2016 # Match the literal guard in the Markdown source.
guard=$(grep -o 'test "${HERDR_ENV:-}" = 1' "$skill")
[ -n "$guard" ]
for value in '' 0 true 01; do
  if HERDR_ENV="$value" "$BASH_BIN" -c "$guard"; then
    echo "FAIL: guard accepted '$value'" >&2
    exit 1
  fi
done
(unset HERDR_ENV; ! "$BASH_BIN" -c "$guard")
HERDR_ENV=1 "$BASH_BIN" -c "$guard"
grep -q 'herdr --skill' "$skill"
grep -q 'entire live guide' "$skill"
echo 'PASS: exact inherited environment guard and static live-guide references'
