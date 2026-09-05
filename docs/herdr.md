# Portable Pi + Herdr bootstrap (opt-in)

This is a **configuration bundle**, not a Pi package or a copy of a live home
folder. `install.sh` remains unchanged. Nothing is activated just by cloning.

## What belongs in dotfiles

| Tracked source | Purpose |
|---|---|
| [pi/settings.json](../pi/settings.json) | Preferred `openai-codex/gpt-6-astra`, dark theme, global `~/.claude/skills` discovery; retain project-trust prompts and extra-usage warnings. |
| [pi/keybindings.json](../pi/keybindings.json) | Explicit small stock baseline: Ctrl+L model selector, Ctrl+O tool output, Shift+Enter/Ctrl+J newline. Other bindings follow Pi defaults, including platform-specific ones. |
| [herdr/config.toml](../herdr/config.toml) | Group agents by workspace, terminal notification delivery, confirmation before closing workspaces. |
| [.claude/skills/herdr/SKILL.md](../.claude/skills/herdr/SKILL.md) | Short portable bootstrap that fully reads the installed `herdr --skill` guide on demand. |

The model/theme and Herdr grouping/notification preferences were selected from
allowlisted, inspected local reference settings, not a recursive config copy.
Keybindings deliberately pin documented defaults, not unverified local overrides.
Herdr notification support still depends on the host terminal/OS and permissions.
Leave Herdr `onboarding` unset so each new machine can complete setup. Omit Pi
`lastChangelogVersion`: it is runtime bookkeeping, not a preference.

**Generated integrations are separate.** Herdr's agent-state extension is generated
by its supported integration installer; recreate it per machine after prerequisites
rather than copying it into dotfiles. Do not track auth/credentials, sessions, logs,
trust databases, model catalogs, sockets, runtime state, downloaded packages, or
whole `.pi`/Herdr config directories. No package list is needed for these preferences;
Pi packages can install dependencies and execute extensions and require separate review.
Repo-specific skills (for example `../.claude/skills` in a project's `.pi/settings.json`)
stay in that repo, never in this global template.

## Clean-machine sequence — human actions, not performed by this PR

1. Install supported Pi and Herdr releases from their official instructions:
   [Pi](https://pi.dev), [Herdr](https://herdr.dev/docs/install/). The focused
   bootstrap requires Bash and **Python 3.11+**; it does not install prerequisites.
   Use `herdr --help`, `herdr --default-config`, and installed Pi docs to check
   compatibility. Review this checkout and its skills before exposing them globally.
2. From a stable dotfiles checkout, with Pi/Herdr settings editors closed, run:
   ```bash
   bash install-herdr-skill.sh --claude-skills --pi --herdr
   ```
   Each flag is independently opt-in. `--claude-skills` safely links individual
   canonical skill directories to `~/.claude/skills`; it skips symlinked source
   entries (including machine-specific/broken links) and entries without `SKILL.md`.
   `--pi` configures settings and keybindings; `--herdr` configures Herdr preferences.
   Resolve reported conflicts manually and rerun; do not force-overwrite them.
3. Start Pi and authenticate locally with `/login`, choosing your provider. Never
   copy another machine's auth file into this repo. Use `/model` and Ctrl+S to save
   an available model. The tracked Codex model is a preference, **not a guarantee
   of catalog availability, subscription access, or authentication**. If it prevents
   startup, edit/remove the two default model/provider keys in the local copy, or
   launch with `pi --provider <available-provider> --model <available-model>`.
   A local fallback differing from the template intentionally conflicts on rerun;
   retain it and skip `--pi`, or reconcile the tracked preference explicitly.
4. After Herdr and Pi are installed and their config locations established, inspect
   `herdr integration` and run `herdr integration install pi`. Use
   `herdr integration status` to verify. Install other supported integrations only
   for harnesses you actually use (e.g. `herdr integration install claude`). These
   commands generate machine-local integration files; the bootstrap never runs them.
   With custom harness config directories, verify the installed integration's target
   support before running it; do not assume it honors every override.
5. Restart Pi for startup settings/model changes. `/reload` reloads skills,
   keybindings and context; `/skill:herdr` explicitly loads the bootstrap when model
   discovery is skipped. Launch/attach Herdr from an ordinary terminal, **not inside
   an existing Herdr pane**. For an existing server, a human can apply edits with
   `herdr server reload-config` (or the UI reload-config action); do not stop the server.
   `herdr config check` validates the selected TOML file without changing preferences.

## Deployment contract and conflicts

Mutable JSON/TOML files are **regular copies, not symlinks**. Pi saves preferences
and bookkeeping; Herdr's settings UI can rewrite config. Symlinking these files
would let runtime writes dirty tracked source. To share a preference change, edit
the small tracked template deliberately and review its diff; do not sync whole files
back from home. Skill sources remain symlinked and track future source edits.

The focused shell entry point delegates structured parsing to a small Python helper.
Python 3.11's standard-library JSON/TOML parsers avoid unsafe text substitution or a
new third-party dependency. No Pi/Herdr CLI, network, package, auth or service command
is invoked. All selected resources are preflighted before writes:

- **Pi JSON:** fill missing keys, recursively preserve unrelated keys, union the
  `skills` array without adding an existing exact path twice. Different existing
  scalar/keybinding values or malformed types conflict rather than being overwritten.
  Changed files get an exclusive `.dotfiles.bak` containing the exact previous bytes;
  an existing backup blocks another change. Equivalent configs are byte/mtime-preserving
  no-ops. New files/backups are private; updates preserve the existing file mode.
- **Herdr TOML:** copy when absent. An existing config containing the tracked subset
  is a byte-preserving no-op, including its unrelated preferences and comments.
  Missing/different tracked preferences require a manual merge from the template.
  This intentionally avoids a general TOML reserializer or comment-destroying merge.
- **Collisions:** refuse wrong/broken links, directories, hard-linked config files,
  symlinked parents and occupied skill destinations without deleting anything.
  Correct skill links are no-ops. Backups must be reviewed/relocated manually before
  another update; never overwrite them. No global context is replaced.
- **Concurrency:** close tools that may write these configs while deploying. Preflight
  and per-file replacement are not a cross-file transaction; filesystem errors or
  concurrent writers can cause partial progress. Resolve and rerun, preserving backups.

Defaults: `~/.pi/agent/{settings,keybindings}.json` and `~/.config/herdr/config.toml`.
`PI_CODING_AGENT_DIR` and `HERDR_CONFIG_PATH` override their respective destinations;
use absolute paths or `~/...`, not repo-relative paths. The bootstrap rejects paths
inside this checkout or redirected parents. It does not infer Herdr's destination
from `XDG_CONFIG_HOME`; the installed help documents `HERDR_CONFIG_PATH` explicitly.
`--claude-skills` targets the portable `~/.claude/skills` used by the Pi template.
With a different `CLAUDE_CONFIG_DIR`, deploy skills and adjust Pi's path manually.
The general `install.sh` respects that variable but also does unrelated setup and
replaces existing skill destinations: **do not run it just for this bootstrap**.

## Herdr discovery: choose one exposure route

The preferred expanded setup is now Pi's global `skills: ["~/.claude/skills"]` plus
reviewed per-skill Claude links. It deliberately exposes the universal Claude skill
collection, as approved for this expanded scope; it does not load repo-local skills.

The original `bash install-herdr-skill.sh --shared` remains a **Herdr-only alternative**
for users who do not want that collection. It links only Herdr into
`~/.agents/skills/herdr`, which installed Pi docs confirm is auto-discovered. Do not
combine the two routes: duplicate names can warn and the first discovered skill wins.
`--pi` refuses an existing shared Herdr entry; inspect its target and remove only the
redundant link manually before switching routes. `--shared` warns against using it
with an already-configured Claude path. Neither mode silently deletes the other route.
Other existing skill locations may also cause name collisions; review startup warnings.
Codex-specific discovery/activation remains future work pending verification.

If model discovery remains unreliable, a human may append this brief optional note
to their existing Pi global `~/.pi/agent/AGENTS.md` (or overridden agent directory),
after review; substitute the shared path if using the alternative:

> For explicit Herdr requests or requests to launch, coordinate, or inspect another agent/pane, read `~/.claude/skills/herdr/SKILL.md` first. Not for generic coding or abstract multi-agent discussion. Never inspect/control Herdr unless inherited `HERDR_ENV` is exactly `1`; follow the live guide and user authorization.

No global-context merge mechanism is introduced just for this sentence. Automatic
loading remains model-dependent; explicit invocation is the reliable discovery fallback.

## Validation and boundary walkthroughs

Run `bash tests/test-install.sh`, `bash tests/test-herdr.sh`,
`bash tests/test-agent-config.sh`, and
`shellcheck install.sh install-herdr-skill.sh tests/*.sh`.
Fixtures use temporary HOME/repo trees and restricted PATH with blocked harness/network
CLIs. They cover formats, additive JSON merges/backups, TOML subset checks, idempotence,
conflicts, path overrides, skill collisions and duplicates. No real installs are tested.

These instruction walkthroughs are **static, not live model behavior tests**:

| Request / environment | Expected boundary |
|---|---|
| “Use Herdr to inspect the reviewer”, inherited `1` | Check environment/CLI, fully read live guide; inspect only. |
| “Launch another agent to review this diff”, inherited `1` | Discover bootstrap; ask before control if the live guide requires explicit Herdr intent. Once authorized: sibling pane, same cwd, unchanged focus. |
| “Coordinate the other agent” / “Inspect the other pane” | Same discovery, environment and authorization gates; no unsolicited spawning. |
| “Fix this bug” / “Explain multi-agent architecture” | No Herdr invocation for generic coding or abstract discussion. |
| Any trigger with unset, empty, `0`, `true`, or `01` environment | Stop outside Herdr; never manufacture `1`, inspect, or control. |
| No bash/CLI, failed guide, or unreadable truncation | Stop and report; no installation or alternate controller. |
| “Inspect Herdr; do not spawn anything” | Authorized reads only; no new agents or layout changes. |
