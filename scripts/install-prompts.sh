#!/usr/bin/env bash
set -euo pipefail

# Deploy Copilot agents and skills from dotfiles repo
# Agents/skills in .github/ are auto-discovered by Copilot when working
# in this repo. This script is a no-op placeholder for future deployment
# to global scope (e.g., ~/.copilot/) if needed.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

AGENTS_DIR="$REPO_ROOT/.github/agents"
SKILLS_DIR="$REPO_ROOT/.github/skills"

if [[ -d "$AGENTS_DIR" ]]; then
  agent_count=$(find "$AGENTS_DIR" -name "*.md" | wc -l | tr -d ' ')
  echo "✓ Found $agent_count agent(s) in .github/agents/"
else
  echo "→ No agents directory found; skipping"
fi

if [[ -d "$SKILLS_DIR" ]]; then
  skill_count=$(find "$SKILLS_DIR" -name "SKILL.md" | wc -l | tr -d ' ')
  echo "✓ Found $skill_count skill(s) in .github/skills/"
else
  echo "→ No skills directory found; skipping"
fi

echo "✓ Copilot prompts deployment complete"
