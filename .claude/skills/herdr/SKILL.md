---
name: herdr
description: 'Discover Herdr for explicit Herdr requests or requests to launch, coordinate, or inspect another agent or terminal pane. Not for generic coding, unsolicited delegation, or abstract multi-agent discussion. Requires inherited HERDR_ENV exactly 1 before any Herdr inspection or control.'
---

# Herdr discovery

1. Load this bootstrap only for the triggers above. Discovery is not authorization to launch agents or change layout; respect the user's scope and prohibitions.
2. If no bash execution tool is available, stop and report that limitation. In bash, check `test "${HERDR_ENV:-}" = 1`. If it fails, report that this agent is outside Herdr and stop: no session inspection or control. Never set, export, fabricate, or override `HERDR_ENV` to pass the check.
3. Check `command -v herdr`. If unavailable, stop and report; do not install it or substitute another controller. Run `herdr --skill` and read the **entire live guide**, continuing through any truncated output before proceeding. If retrieval fails or the full guide cannot be read, stop and report.
4. Follow that guide for current CLI semantics and safety; do not guess flags, copy a cached guide, or run bare `herdr`. If its authorization rules are stricter than this discovery trigger (for example, requiring explicit Herdr intent), ask for confirmation before control on an implicit request.
5. Act only within authorized scope. Preserve the caller's cwd and user focus; default to sibling panes in the current tab unless the user requests another topology/location. Use caller context and live returned IDs, not UI focus or guessed targets. Read-only requests must remain read-only. Do not answer another agent's approval prompts without user permission.
