#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/install-prompts.sh [--copy|--symlink] [--dest PATH]

Options:
  --copy     Copy prompt files (default).
  --symlink  Symlink prompt files.
  --dest     Destination directory for Copilot Chat prompts.

Environment:
  CODE_VARIANT      VS Code folder name (default: Code). Example: "Code - Insiders".
  XDG_CONFIG_HOME   Overrides ~/.config on Linux.
USAGE
}

MODE="copy"
DEST=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy)
      MODE="copy"
      shift
      ;;
    --symlink)
      MODE="symlink"
      shift
      ;;
    --dest)
      DEST="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_ROOT/prompts"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Prompt directory not found: $SRC_DIR" >&2
  exit 1
fi

if [[ -z "$DEST" ]]; then
  CODE_VARIANT="${CODE_VARIANT:-Code}"
  if [[ "$(uname -s)" == "Darwin" ]]; then
    DEST="$HOME/Library/Application Support/$CODE_VARIANT/User/prompts"
  else
    CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    DEST="$CONFIG_HOME/$CODE_VARIANT/User/prompts"
  fi
fi

mkdir -p "$DEST"

for file in "$SRC_DIR"/*.md; do
  base="$(basename "$file")"
  target="$DEST/$base"
  if [[ "$MODE" == "symlink" ]]; then
    ln -sf "$file" "$target"
  else
    cp -f "$file" "$target"
  fi
  echo "$MODE: $file -> $target"
done

cat <<EOF

Installed prompts to:
  $DEST

Open Copilot Chat and use /prompt to select the files.
EOF
