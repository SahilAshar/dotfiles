#!/usr/bin/env bash
set -euo pipefail

# Focused opt-in bootstrap; never invoke the general dotfiles installer.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
case "${1:-}" in
  --pi|--herdr|--claude-skills)
    exec python3 "$SCRIPT_DIR/scripts/bootstrap-agent-config.py" "$@"
    ;;
esac
if [ "$#" -ne 1 ] || [ "$1" != "--shared" ]; then
  echo "Usage: bash install-herdr-skill.sh --shared OR [--pi] [--herdr] [--claude-skills]" >&2
  exit 2
fi

echo "WARNING: --shared is an alternative; do not use if Pi already loads ~/.claude/skills (duplicate names)." >&2
src="$SCRIPT_DIR/.claude/skills/herdr"
: "${HOME:?HOME must be set}"
if [ ! -f "$src/SKILL.md" ]; then
  echo "ERROR: Missing source: $src/SKILL.md" >&2
  exit 1
fi

# Refuse redirected parent paths rather than writing into another config tree.
for parent in "$HOME/.agents" "$HOME/.agents/skills"; do
  if [ -L "$parent" ] || { [ -e "$parent" ] && [ ! -d "$parent" ]; }; then
    echo "ERROR: Resolve non-directory or symlink parent manually: $parent" >&2
    exit 1
  fi
done

dest="$HOME/.agents/skills/herdr"
if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
  echo "Already linked: $dest"
  exit 0
fi
if [ -e "$dest" ] || [ -L "$dest" ]; then
  echo "ERROR: Existing destination left untouched; resolve manually: $dest" >&2
  exit 1
fi

mkdir -p "$HOME/.agents/skills"
ln -sn "$src" "$dest"
echo "Linked: $dest → $src"
