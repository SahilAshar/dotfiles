# Shared Herdr discovery (optional)

[The bootstrap](../.claude/skills/herdr/SKILL.md) is the canonical portable source.
It loads the installed `herdr --skill` guide on demand instead of maintaining a
second CLI manual. No generated Herdr extension is involved.

## Future activation — not performed by this change

After reviewing the source, from a stable dotfiles checkout run:

```bash
bash install-herdr-skill.sh --shared
```

This standalone installer links **only Herdr** to `~/.agents/skills/herdr`.
It does not run `install.sh`, install packages, access the network, merge settings,
or edit context files. Correct links are a no-op; existing files, directories,
wrong/broken links, and symlinked parent directories are refused untouched.
Resolve collisions manually after inspection. Keep the checkout at that path:
symlinks track future source edits immediately. To undo, remove only this symlink
after checking its target; do not remove its source directory.

Pi's installed README and `docs/skills.md` confirm global discovery from
`~/.agents/skills/` and on-demand loading from descriptions. Restart Pi or use
`/reload` after activation; `/skill:herdr` explicitly loads the bootstrap if
automatic discovery is skipped. No global `skills` array or broad exposure of
`~/.claude/skills` is needed. Other same-name skills may win discovery order;
review any collision warning. Discovery does not itself execute Herdr.

The existing general `install.sh` separately links canonical skills into
`${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills`. It also performs unrelated setup and
replaces existing skill destinations: **do not run it just to activate Herdr**.
That pre-existing behavior is unchanged here. Codex-specific discovery and
activation remain future work pending verification against its installed docs.

## Optional always-loaded routing note

Pi documents `~/.pi/agent/AGENTS.md` as global context. If discovery is unreliable,
a human may append the following brief note to their existing context, after
review (adapt the path if using another deployment location):

> For explicit Herdr requests or requests to launch, coordinate, or inspect another agent/pane, read `~/.agents/skills/herdr/SKILL.md` first. Not for generic coding or abstract multi-agent discussion. Never inspect/control Herdr unless inherited `HERDR_ENV` is exactly `1`; follow the live guide and user authorization.

No context file is created, replaced, or symlinked by this installer. The repo has
no shared global-context merge mechanism; adding one just for a routing sentence
would widen scope and risk existing instructions. The tradeoff is that automatic
skill loading remains model-dependent until the user adds the optional note or
invokes the skill explicitly.

## Review scenarios

These are static instruction walkthroughs, **not live model behavior tests**.
No agents/panes need to be spawned for validation.

| Request / environment | Expected boundary |
|---|---|
| “Use Herdr to inspect the reviewer”, inherited `1` | Load bootstrap, check environment/CLI, fully read live guide; inspect only. |
| “Launch another agent to review this diff”, inherited `1` | Discover bootstrap; obey live guide's stricter explicit-Herdr requirement and ask before control if required. Once authorized, default sibling pane, same cwd, unchanged focus. |
| “Coordinate the other agent” / “Inspect the other pane” | Discover bootstrap; same environment and authorization gates. No unsolicited spawning. |
| “Fix this bug” | No Herdr discovery or delegation merely because parallel work might help. |
| “Explain multi-agent architecture” | Abstract discussion: no Herdr invocation. |
| Any trigger with unset, empty, `0`, `true`, or `01` environment | Stop outside Herdr; never manufacture `1`, inspect, or control. |
| Trigger without bash/CLI, failed/truncated unreadable guide | Stop and report limitation; no install or alternate controller. |
| “Inspect Herdr; do not spawn anything” | Discovery and authorized reads only; no layout changes or new agents. |

Run `bash tests/test-install.sh`, `bash tests/test-herdr.sh`, and
`shellcheck install.sh install-herdr-skill.sh tests/*.sh`. The Herdr tests execute
the actual standalone installer only in temporary HOME fixtures with a restricted
command PATH; no real harness install, network, or live Herdr control is tested.
