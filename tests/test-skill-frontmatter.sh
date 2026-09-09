#!/usr/bin/env bash
set -euo pipefail

# Pi only recognizes YAML frontmatter at the start of a skill file.
# Keep provenance comments below it. This checks framing, not YAML syntax;
# it needs neither Pi nor a model/network connection.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/../.claude/skills"
PASS=0
FAIL=0

while IFS= read -r -d '' skill; do
  if awk '
    NR == 1 { if ($0 != "---") exit 1; next }
    $0 == "---" { closed = 1; exit }
    END { if (!closed) exit 1 }
  ' "$skill"; then
    PASS=$((PASS + 1))
  else
    printf 'FAIL: %s must start with a closed YAML frontmatter block; put comments below it\n' "$skill" >&2
    FAIL=$((FAIL + 1))
  fi
done < <(find "$SKILLS_DIR" -type f -name SKILL.md -print0)

if [ "$PASS" -eq 0 ] && [ "$FAIL" -eq 0 ]; then
  echo "FAIL: no shared skills found" >&2
  exit 1
fi

printf 'Skill frontmatter: %s passed, %s failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
