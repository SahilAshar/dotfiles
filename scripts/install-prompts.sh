#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_ROOT/github/.github/prompts"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Canonical prompt directory not found: $SRC_DIR" >&2
  exit 1
fi

GENERATE_FILE="$SRC_DIR/generate.prompt.md"
if [[ ! -f "$GENERATE_FILE" ]]; then
  echo "Missing generate.prompt.md in $SRC_DIR" >&2
  exit 1
fi

DEST="${COPILOT_PROMPTS_DIR:-}"
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

echo "Deploying prompts from: $SRC_DIR"
echo "Symlinking generate prompt"
echo "  source: $GENERATE_FILE"
echo "  target: $DEST/generate.prompt.md"

ln -sf "$GENERATE_FILE" "$DEST/generate.prompt.md"

cat <<EOF

Published generate.prompt.md to:
  $DEST

Open Copilot Chat and run /generate to scaffold repo prompts.
Set COPILOT_PROMPTS_DIR to override the destination if needed.
EOF
