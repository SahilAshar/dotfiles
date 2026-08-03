---
name: strategy-memo
description: >
  Write internal strategy memos and leadership communications in prose-driven,
  Paul Graham-inspired style — narrative flow, no bullet points, timelines woven
  into the argument, proposal that feels inevitable by the time you state it.
  Triggered by: "strategy memo", "write a memo", "leadership memo", "internal memo",
  "draft a memo", "prose memo", "write up my thinking", "send a strategy email",
  "put together a memo". Also use whenever the user has raw thinking (often
  voice-transcribed stream of consciousness) they want turned into a polished,
  persuasive internal communication — even if they don't say "memo" explicitly.
  Use this skill whenever the user mentions writing strategy docs, alignment emails,
  proposals to leadership, or any internal communication meant to persuade a small
  audience of technical leaders toward a decision.
---

# Strategy Memo

Turn raw thinking into a polished prose memo that reads like a Paul Graham essay
and lands like an Amazon 6-pager — but fits in an email.

## Why This Style Works

Two research-backed insights drive this skill:

**Paul Graham's essay method.** Short, punchy paragraphs. Each one lands a single
point and builds on the last. The reader follows your thinking and arrives at your
conclusion feeling like they got there themselves. Conversational but precise.
Reframes that make the familiar look different. Persuade small point by small point.

**Amazon's narrative memo principle.** Writing in full prose forces clear thinking.
If you can't connect your ideas in paragraphs, you haven't actually thought them
through. Replace adjectives with data. Keep sentences under 30 words. A memo is an
exercise in clear strategy, not clear writing.

The synthesis: a 1-2 page narrative memo — no bullet points, no section headers in
the body — that a busy technical leader can read in one sitting and walk away
knowing exactly what you're proposing and why it's the only sensible path.

## Phase 1: Understand the Raw Thinking

The user will often arrive with a stream-of-consciousness dump — voice transcription,
scattered notes, a verbal brain dump. Before drafting, extract these four things. If
any are unclear, ask — but if you can reasonably infer from context, do so and
confirm rather than interrogating.

1. **The core proposal.** What is the user actually proposing? Strip away the
   narrative and name the one-sentence ask. "Gate all new capabilities behind the
   search API" or "Consolidate three teams into one org" or "Kill project X and
   redirect to project Y."

2. **The audience.** Who reads this? 4-8 people who already know the landscape, or
   a broader group that needs context? The answer determines how much you explain
   vs. assume. Most memos from this user go to a small group of peers and
   skip-levels — assume shared context unless told otherwise.

3. **The timelines creating pressure.** Every good memo has an implicit "why now."
   Find the dates and deadlines that make the proposal urgent. These aren't
   decoration — they're the engine of the argument.

4. **The political subtext.** What can't be said directly? Deprecations, blame,
   criticism of other teams — these need to be implied through structural arguments,
   never stated. Understand what the user wants to communicate without saying.

## Phase 2: Draft the Memo

### The Eight Principles

Follow these in order of priority. When they conflict, the higher-numbered principle
yields to the lower.

**1. Narrative prose over structure.**
No bullet points in the body. No headers. No numbered lists. Short paragraphs —
each one lands a single point. Each paragraph builds on the last so the reader
follows a chain of reasoning, not a checklist. Bold the opening phrase of key
paragraphs to create visual anchors without breaking into sections.

**2. Timelines woven into the narrative.**
Never section off "Why Now" as its own block. Dates and deadlines appear exactly
where they create pressure in the argument. "Our beta begins August 17th" lands
inside the paragraph about quality — not in a timeline section three paragraphs
later. The reader should feel urgency building through the logic, not announced
by a header.

**3. Proposal lands late and feels inevitable.**
Build the argument so the reader arrives at the conclusion before you state it.
Lay out what needs to happen. Show why the timelines don't allow the status quo.
Let the reader think "obviously we should consolidate this" — and then say it.
The proposal is confirmation, not surprise.

**4. Conversational but precise.**
Plain language. Short declarative sentences. Replace adjectives with data: not
"significant improvement" but "30% faster." No corporate jargon — "synergies,"
"leverage," "align around," "drive outcomes" are banned. No hedge words — "perhaps,"
"it might be worth considering," "we could potentially" are the sound of someone
who hasn't decided what they think.

**5. Reframes over complaints.**
Never open with what's broken. Never lead with a defensive posture. Lead with what
needs to happen. Frame the proposal as "here's the smart way to deliver these
investments" not "here's what's wrong with how we do things." The reader should feel
like they're being invited into a strategy, not handed a problem.

**6. Implications over declarations.**
Don't explicitly name deprecations, blame, or criticism. Let structural arguments
do the work. "Rather than spreading investment across existing surfaces" does the
job of "we should deprecate the old APIs" without the political cost. If upstream
teams are slow to adopt, say "without a forcing function, team X migrates mid-Q4"
— that's data, not criticism.

**7. Short enough for email.**
These memos go to 4-8 people who already know the context. 350-500 words is the
sweet spot. Anything over 600 words needs to justify its length. The reader should
be able to finish it in under 3 minutes. No appendices, no "supporting materials"
sections. If it can't stand alone in the body of an email, it's too long.

**8. Close with a clear ask.**
End with one paragraph that states what you need from the audience. Not bulleted
next steps. Not "thoughts?" Just: "What I'm looking for is alignment that X is
the path forward, and that we communicate this to Y." Direct, specific, and done.

### Structure Template

This is the shape, not a rigid format. Every memo should feel organic, not
templated.

```
Opening (1-2 sentences): Set the frame. What's converging, what's in flight.
End with the question the memo answers.

Investment/situation paragraphs (3-5 short paragraphs): What needs to happen.
Each one is a bolded-opener paragraph. Timelines embedded where they create
pressure. Data over adjectives.

Pivot paragraph (1-2 sentences): "The question is where that investment lands"
or "The timelines say that's the wrong approach." Transition from situation to
proposal.

Proposal (1 paragraph): State it cleanly. One sentence for the proposal itself,
then 2-3 sentences on why it works structurally.

Implication paragraph (1 paragraph): What this means for the audience and
upstream teams. The benefits stated as outcomes, not bullet points.

Ask (1 paragraph): What you need. Who you've already talked to. What alignment
looks like.
```

### What Bad Looks Like vs. What Good Looks Like

**Corporate memo style (avoid):**

```
## Problem Statement
We currently face quality challenges across our retrieval surfaces...

## Proposed Solution
We recommend consolidating all new capability development behind a
unified API layer, which would provide:
- Reduced integration overhead
- Improved quality attribution
- Streamlined upstream adoption

## Timeline
- Phase 1 (Aug): ...
- Phase 2 (Sep): ...
- Phase 3 (Q4): ...

## Next Steps
1. Align on proposal
2. Define delivery timeline
3. Communicate to stakeholders
```

**Prose memo style (use this):**

```
Three major investments are converging on client content this quarter.
Each is funded, each primarily serves client content, and each needs
to be available to upstream teams. The question isn't whether we build
them — it's how we deliver them.

**Retrieval quality.** The product today has no reranking, no recency
signals, and no document diversity. Beta begins August 17th. Once
people start using it, quality is the first thing they'll ask about.

**Connectors.** Third-party connectors are targeting September 30th.
When those land, the next question is immediate: when can we have
auto-enrichments? Massive corpuses ingested through connectors can't
be manually tagged.

All three require real investment. The question is where it lands.

We have multiple retrieval surfaces today. Upstream teams are planning
to adopt on their own timelines — one team mid-Q4, another maybe
January. In the meantime, we'd be shipping these capabilities across
existing surfaces and duplicating the work for every team that
eventually needs them.

The timelines say that's the wrong approach. August starts the quality
conversation. September starts the enrichment conversation. Both
arrive before upstream teams would naturally move. If we ship into
existing surfaces now and ask teams to migrate later, we do the work
twice.

My proposal: deliver all three through the new API. It's already in
development, designed to be uniform across both content domains. One
integration, one contract, one path forward.

I've discussed this with two other leads who see the value. What I'm
looking for is alignment that this is the delivery vehicle, and that
we communicate the direction to upstream teams.
```

Notice what the good version does: the reader arrives at "obviously, use one API"
before the author says it. The timelines (August, September) appear where they
create pressure, not in a separate section. There are no bullet points. The
deprecation of old surfaces is implied ("rather than shipping across existing
surfaces") without being declared. The close is one paragraph, not a numbered list.

## Phase 3: Review and Tighten

After drafting, run these checks:

- **The 30-word test.** Read every sentence. If any sentence exceeds 30 words,
  split it or cut words. Long sentences are where fuzzy thinking hides.

- **The adjective test.** Find every adjective. Can it be replaced with a number
  or removed? "Significant quality improvements" → "30% better recall" or just
  cut the adjective entirely.

- **The hedge test.** Search for "might," "could," "potentially," "perhaps,"
  "it may be worth." These signal that the author hasn't committed to a position.
  Either commit or cut the sentence.

- **The inevitability test.** Cover the proposal paragraph. Read everything above
  it. Does the conclusion feel obvious? If not, the setup is missing a link in
  the chain.

- **The email test.** Could this be pasted into the body of an email and sent as-is?
  If it needs an attachment, a deck, or a "see the doc for details," it's not
  self-contained enough.

- **The subtext test.** Read it from the perspective of someone being implicitly
  criticized. Would they feel attacked, or would they see a structural argument
  they can't disagree with? The latter is the goal.

Present the draft to the user with a brief note on what you cut, what you
sharpened, and any political subtext you handled. Let them react before finalizing.
