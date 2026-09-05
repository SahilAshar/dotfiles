#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX="$(mktemp -d)"
trap 'rm -rf "$SANDBOX"' EXIT
BASH_BIN="$(command -v bash)"
mkdir -p "$SANDBOX/bin" "$SANDBOX/repo/.claude/skills/herdr"
cp "$REPO_ROOT/install-herdr-skill.sh" "$SANDBOX/repo/"
cp "$REPO_ROOT/.claude/skills/herdr/SKILL.md" "$SANDBOX/repo/.claude/skills/herdr/"
# Only filesystem primitives are reachable by the installer; no network/install CLI.
for cmd in dirname readlink mkdir ln; do
  ln -s "$(command -v "$cmd")" "$SANDBOX/bin/$cmd"
done
export HOME="$SANDBOX/home with spaces"
mkdir -p "$HOME"
installer="$SANDBOX/repo/install-herdr-skill.sh"
src="$SANDBOX/repo/.claude/skills/herdr"
dest="$HOME/.agents/skills/herdr"
run_install() { PATH="$SANDBOX/bin" "$BASH_BIN" "$installer" "$@"; }
refuses() {
  if run_install "$@" > "$SANDBOX/output" 2>&1; then
    echo "FAIL: expected refusal" >&2
    exit 1
  fi
}

refuses
refuses --unknown
[ ! -e "$HOME/.agents" ]
run_install --shared
[ "$(readlink "$dest")" = "$src" ]
run_install --shared
[ "$(readlink "$dest")" = "$src" ]
[ "$(find "$HOME" -type l | wc -l | tr -d ' ')" = 1 ]
[ ! -e "$HOME/.pi" ] && [ ! -e "$HOME/.claude" ] && [ ! -e "$HOME/.codex" ]
echo 'PASS: explicit opt-in, Herdr-only link, idempotency, spaces in HOME'

rm "$dest"
printf 'keep\n' > "$dest"
refuses --shared
[ "$(< "$dest")" = keep ]
rm "$dest"
mkdir "$dest"
printf 'keep\n' > "$dest/owned"
refuses --shared
[ "$(< "$dest/owned")" = keep ]
rm -r "$dest"
for target in "$src/" "$SANDBOX/missing"; do
  ln -s "$target" "$dest"
  refuses --shared
  [ "$(readlink "$dest")" = "$target" ]
  rm "$dest"
done
echo 'PASS: file, directory, alternative and broken link collisions preserved'

for parent in "$HOME/.agents/skills" "$HOME/.agents"; do
  rm -r "$parent"
  mkdir -p "$SANDBOX/redirect"
  ln -s "$SANDBOX/redirect" "$parent"
  refuses --shared
  [ -z "$(ls -A "$SANDBOX/redirect")" ]
  rm "$parent"
  printf 'keep\n' > "$parent"
  refuses --shared
  [ "$(< "$parent")" = keep ]
  rm "$parent"
done
mv "$src/SKILL.md" "$SANDBOX/saved-skill"
refuses --shared
[ ! -e "$HOME/.agents" ]
echo 'PASS: redirected/non-directory parents and missing source fail safely'

# Execute the exact environment guard from the bootstrap, not a live Herdr CLI.
# shellcheck disable=SC2016 # Match the literal guard in the Markdown source.
guard=$(grep -o 'test "${HERDR_ENV:-}" = 1' "$SANDBOX/saved-skill")
[ -n "$guard" ]
for value in '' 0 true 01; do
  if HERDR_ENV="$value" "$BASH_BIN" -c "$guard"; then
    echo "FAIL: guard accepted '$value'" >&2
    exit 1
  fi
done
(unset HERDR_ENV; ! "$BASH_BIN" -c "$guard")
HERDR_ENV=1 "$BASH_BIN" -c "$guard"
grep -q 'herdr --skill' "$SANDBOX/saved-skill"
grep -q 'entire live guide' "$SANDBOX/saved-skill"
echo 'PASS: exact inherited environment guard and static live-guide references'
