#!/bin/bash
# PostToolUse hook for Claude Code's Skill tool.
# Appends one JSONL line per skill invocation to ~/.claude/skill-usage.jsonl.
# Designed to NEVER fail or block — any error is swallowed so the parent
# tool call always proceeds normally.

{
  LOG="${SKILL_USAGE_LOG:-$HOME/.claude/skill-usage.jsonl}"
  mkdir -p "$(dirname "$LOG")"

  payload=$(cat)
  tool=$(printf '%s' "$payload" | jq -r '.tool_name // empty' 2>/dev/null)
  [ "$tool" = "Skill" ] || exit 0

  skill=$(printf '%s' "$payload" | jq -r '.tool_input.skill // "unknown"' 2>/dev/null)
  cwd=$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null)
  session=$(printf '%s' "$payload" | jq -r '.session_id // empty' 2>/dev/null)
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  host=$(hostname -s 2>/dev/null || echo "unknown")

  jq -nc \
    --arg ts "$ts" \
    --arg skill "$skill" \
    --arg cwd "$cwd" \
    --arg host "$host" \
    --arg session "$session" \
    '{ts:$ts, skill:$skill, cwd:$cwd, host:$host, session:$session}' \
    >> "$LOG" 2>/dev/null
} 2>/dev/null

exit 0
