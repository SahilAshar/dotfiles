#!/usr/bin/env bash
set -euo pipefail

# Opt-in, Herdr-only deployment; never invoke the general dotfiles installer.
if [ "$#" -ne 1 ] || [ "$1" != "--shared" ]; then
  echo "Usage: bash install-herdr-skill.sh --shared" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
