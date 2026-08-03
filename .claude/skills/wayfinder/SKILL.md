---
name: wayfinder
description: 'Plan a large, foggy chunk of work as a map of decision tickets, then resolve them one at a time until the way forward is clear. Use when the user says "wayfind this", "chart a path", "map this out", "this is too big for one session", "plan this large effort", or has a loose idea that needs structured decomposition before building.'
disable-model-invocation: true
---

# Wayfinder

A loose idea has arrived — too big for one agent session, and wrapped in fog: the way from here to the **destination** isn't visible yet. Wayfinding is about finding that way, not charging at the destination. This skill charts the way as a **shared map** of local markdown files, then works its **decision tickets** — questions whose resolution is a decision, not slices of a build to execute — one at a time until the route is clear.

The destination varies per effort, and naming it is the first act of charting — it shapes every ticket. It might be a spec to hand off and iterate on, a decision to lock before planning starts, or a change made in place like a data-structure migration. The map is domain-agnostic — engineering work, course content, whatever fits the shape.

## Plan, don't do

Wayfinder is **planning** by default: each ticket resolves a decision, and the map is done when the way is clear — nothing left to decide before someone goes and does the thing. The pull to just do the work is usually the signal you've reached the edge of the map and it's time to hand off. An effort can override this in its **Notes** — carrying execution into the map itself — but absent that, produce decisions, not deliverables.

## Refer by name

Every ticket has a **name** — its title. In everything the human reads — narration, the map's Decisions-so-far — refer to it by that name, never by a bare number or slug. A wall of `#42, #43, #44` is illegible; names read at a glance.

## Storage

Everything lives under `.scratch/<effort-slug>/`:

```
.scratch/my-effort/
  MAP.md                    # the canonical map
  tickets/
    01-first-question.md
    02-second-question.md
    ...
```

Tickets are numbered in creation order (`01`, `02`, …). The number is an id, not a priority.

## The Map

The map is `MAP.md` — the canonical artifact. Its tickets are files in `tickets/`.

### Map body

The whole map at low resolution, loaded once per session.

```markdown
# <Effort name>

## Destination

<what reaching the end of this map looks like — the spec, decision, or change this effort is finding its way to. One or two lines; every session orients to it before choosing a ticket.>

## Notes

<domain; standing preferences for this effort; any skills every session should consult>

## Decisions so far

<!-- the index — one line per resolved ticket: enough to judge relevance, then read the ticket for detail -->

- **<ticket title>** (01) — <one-line gist of the answer>

## Not yet specified

<!-- fog of war: in-scope fog you can't ticket yet; graduates as the frontier advances -->

## Out of scope

<!-- work ruled beyond the destination; never graduates -->
```

### Tickets

Each ticket is a file in `tickets/`. Its body is the question, sized to one agent session:

```markdown
# <NN> — <Ticket title>

**Type:** research | prototype | grilling | task
**Status:** open | claimed | resolved
**Blocked by:** 03, 05 (or "none")

## Question

<the decision or investigation this ticket resolves>

## Resolution

<!-- filled on resolution -->

<the answer, with any assets linked>
```

A ticket is **unblocked** when every ticket in its "Blocked by" list is resolved. The **frontier** is the set of open, unblocked tickets — the edge of the known.

## Ticket Types

Every ticket is either **HITL** (human in the loop — worked with the user) or **AFK** (agent-driven).

- **Research** (AFK): Investigate a question against primary sources — official docs, source code, specs. Spin up a background agent to do the reading. Resolved when the fact is surfaced.
- **Prototype** (HITL): Build a quick, cheap, concrete artifact to react to — an outline, a stub, a rough UI. Links the prototype as an asset. Use when "how should it look/behave" is the key question.
- **Grilling** (HITL): Interview the user relentlessly, one question at a time, providing a recommended answer with each question. The default type when the ticket is a design decision.
- **Task** (HITL or AFK): Manual work that must happen before a decision can be made — nothing to decide, prototype, or research, but a ticket is blocked until it's done. Resolved when the work is complete; the resolution records what was done and any facts later tickets depend on.

## Fog of war

The map is deliberately incomplete: don't chart what you can't yet see. Beyond the live tickets lies the **fog of war** — decisions you can tell are coming but can't yet pin down, because they hang on questions still open. Resolving a ticket clears the fog ahead of it, graduating whatever's now specifiable into fresh tickets.

The map's **Not yet specified** section is where that dim view is written down. It's the undiscovered frontier toward the destination — everything here is in scope, just not sharp enough to ticket.

**Fog or ticket?** The test is whether you can state the question precisely now — not whether you can answer it now.

- **Ticket when** the question is already sharp, even if blocked.
- **Not yet specified when** you can't yet phrase it that sharply.

## Out of scope

Fog only gathers toward the destination. Work beyond the destination is **out of scope** — it isn't fog, it doesn't belong in Not yet specified. It gets its own section on the map. Out-of-scope work never graduates; it returns only if the destination is redrawn.

When a ticket turns out to sit past the destination, mark it resolved with a resolution of "Out of scope — <reason>" and add one line to the Out of scope section.

## Invocation

Two modes. **Never resolve more than one grilling/prototype/task ticket per session** — research tickets are the exception (fire several in parallel).

### Chart the map

User invokes with a loose idea.

1. **Name the destination.** Interview the user one question at a time — provide a recommended answer with each — to pin down what this map is finding its way to. The destination fixes the scope, so it's settled first.
2. **Map the frontier.** Interview again, **breadth-first** this time: fan out across the whole space rather than deep on any one thread, surfacing the open decisions and the first steps takeable now. **If this surfaces no fog** — the way to the destination is already clear, the whole journey small enough for one session — you don't need a map. Stop and ask the user how they'd like to proceed.
3. **Create the map**: write `MAP.md` with Destination and Notes filled in, Decisions-so-far empty, fog sketched into Not yet specified.
4. **Create the tickets you can specify now** as files in `tickets/` — then fill in blocking edges (tickets need to exist before they can reference each other).
5. **Fire background research.** For each research ticket, spin up a background agent to resolve it in parallel.
6. Stop — charting is one session's work; it resolves nothing itself.

### Work through the map

User invokes with a map path or effort name. A ticket is optional — without one, you pick the next frontier ticket.

1. Load the **map** — the low-res view, not every ticket body.
2. Choose the ticket. If the user named one, use it. Otherwise take the first unblocked, open ticket.
3. **Claim it**: set status to `claimed` before any work.
4. Resolve it — read related resolved tickets as needed for context. For grilling tickets: interview one question at a time, recommended answer attached. For research: spin up a background agent. For prototypes: build the artifact. For tasks: do the work or hand the user a checklist.
5. Record the resolution: fill in the Resolution section, set status to `resolved`, and append a one-line gist to the map's Decisions-so-far.
6. Graduate fog: add newly-surfaced tickets, clear each graduated patch from Not yet specified. If the resolution invalidates other tickets, update or close them.
