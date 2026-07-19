---
name: technical-writing-cleanup
description: 'Rewrite prose to be clearer, plainer, and compliant with ASD-STE100 Simplified Technical English or Google''s developer-documentation style guide. Use whenever the user wants to clean up, tighten, simplify, de-jargon, or copy-edit written text — docs, READMEs, release notes, emails, instructions, procedures, UI copy, error messages — or asks to make writing "plainer", "clearer", "more concise", "less wordy", "STE-compliant", "simplified technical english", or "Google style". Also use proactively when you notice prose that is wordy, passive, jargon-heavy, or has overlong sentences — but when the user did not ask, offer the rewrite rather than silently replacing their text (see the output contract). This is for natural-language text, NOT source-code readability (use a code-review skill for code).'
---

# Technical Writing Cleanup

Rewrite written English so it is clear, direct, and compliant with a chosen
technical-writing standard. The goal is text a reader understands on the first
pass — short sentences, active voice, plain words, no jargon.

## Output contract

Return a **clean rewrite only**: the improved text and nothing else. No preamble
("Here's the rewrite"), no change log, no commentary — just the text, in the same
format it came in. "Same format" means the markup and register carry over
(Markdown stays Markdown, a heading stays a heading); it does **not** forbid the
structural reshaping a standard requires — `ste-strict`, for example, splits a
narrative sentence into numbered steps by design. The user chose brevity; respect
it. Add explanation only if they ask, or in the rare cases noted under *Judgment
calls* below.

**One exception, for proactive use:** when the user explicitly asked you to clean
up text, return the rewrite alone. When *you* noticed the problem and they did
not ask, don't silently overwrite their words — say one line offering the cleaned
version and show it as a suggestion. Silently rewriting text someone didn't ask
you to touch reads as ignoring their actual question.

## Step 1 — Pick the mode

Three modes. Infer from the request; if genuinely ambiguous, use the blended
default rather than stopping to ask.

| Mode | Trigger | What it does |
|---|---|---|
| **`blended`** (default) | any general "clean this up", "make it clearer", "tighten this" | Applies the shared core below. Modern, readable, keeps a human tone. |
| **`ste-strict`** | "STE", "simplified technical english", "ASD-STE100", "strict", procedures/warnings for manuals | Full ASD-STE100: controlled vocabulary, hard length caps, no `-ing`, no passive in steps. |
| **`google`** | "Google style", "developer docs style", "dev docs" | Google's word list + voice/tense/second-person/link/heading/accessibility rules. |

For **`ste-strict`**, read `references/ste.md` before rewriting.
For **`google`**, read `references/google.md` before rewriting.
For **blended**, the shared core below is enough — no reference file needed.

The two standards genuinely conflict on some axes (STE bans gerunds, synonyms,
contractions, and a friendly tone that Google encourages; STE has hard length
caps, Google has soft ones). The blended default resolves conflicts toward the
more permissive Google rule while still applying every plain-language fix the
two standards agree on. If the user wants the strict, machine-checkable version,
that is what `ste-strict` is for.

## Step 2 — Apply the shared core (all modes)

These are the plain-language rules the two standards broadly share. They do the
bulk of the work in every mode.

**Precedence in `ste-strict`:** ASD-STE100's controlled dictionary and safety
rules override this shared core wherever they disagree. STE deliberately keeps a
few formal words the core simplifies — it wants *sufficient* (not "enough") and
*necessary* (not "need") — and it mandates blunt hazard verbs the inclusive-
language rule below would otherwise soften, so an STE warning may read "can kill
you." In `ste-strict`, follow `references/ste.md` when it conflicts with a rule
here. In `blended` and `google`, the plainer choice below wins.

1. **Short sentences, one idea each.** Break a long or multi-clause sentence
   into several. A reader should never have to re-read to parse it.
2. **Active voice.** Name the actor. "The system creates the file," not "A file
   is created." Passive is a last resort for when the actor truly is unknown.
3. **Imperative for instructions.** "Open the valve," not "The valve should be
   opened." Put any condition first: "Before you turn on the power, close the
   door."
4. **Plain words.** Swap inflated words for common ones. The always-on list
   (blended/google direction; `ste-strict` reverses the two marked †):
   - in order to → to · prior to → before · subsequent to → after
   - utilize → use · assist → help · commence → start · terminate → stop
   - invoke → call · leverage → use · in the vicinity of → near
   - sufficient → enough† · require → need† · approximately → about
   - obtain → get · additional → more · indicate → show
   - Drop filler: *simply, just, easy, easily, please* (in instructions),
     *e.g.* → for example, *i.e.* → that is, *etc.* → finish the list or cut it.
5. **No jargon, idioms, or slang.** Write for a global reader who may not be a
   native English speaker. Spell out an acronym on first use, then reuse it.
6. **Fix ambiguous pronouns.** "this," "that," "it" need a clear, nearby noun —
   prefer "this *setting*" over a bare "this."
7. **Parallel, well-typed lists.** Numbered for sequences, bulleted for sets;
   every item in the same grammatical form.
8. **Inclusive language.** allowlist/denylist (not whitelist/blacklist),
   primary/replica (not master/slave), singular "they," no ableist or violent
   metaphors ("sanity check," "kill," "hang").
9. **Cut what earns nothing.** Delete "there is/there are" openers, redundant
   qualifiers, and throat-clearing ("It is important to note that…").

Then layer the mode-specific rules from the reference file when in `ste-strict`
or `google`.

## Step 3 — Preserve meaning and structure

Cleaning up prose must never change what it says or invent detail.

- **Keep the facts.** Don't add claims, numbers, or steps the original didn't
  have. Don't drop caveats or conditions to make a sentence shorter.
- **Leave code, commands, file paths, URLs, identifiers, and proper names
  exactly as written.** Rewrite the prose around them, not them. Leave any
  non-English spans as written too; clean only the English prose around them.
- **Short fragments** (button labels, toasts, menu items, error-message stubs):
  apply only word-choice and inclusive-language fixes. Sentence-splitting,
  active-voice, and length rules don't apply to a two-word label.
- **Preserve document structure** — headings, list nesting, code blocks, tables,
  links. Improve the words inside, keep the skeleton.
- **Match the register to the mode.** Blended and `google` keep the author's
  voice and contractions; `ste-strict` is deliberately formal and terse.
- **Already-clean text:** if a passage already meets the standard, return it
  unchanged rather than churning it for the sake of change. When the output is
  identical to the input, add the single line `Note: already compliant; returned
  unchanged.` so the caller can tell "nothing to fix" apart from a no-op.

## Judgment calls

Default to returning only the rewrite. Use a single short line at the very end
prefixed `Note:` only in these cases:

- A sentence can't be made compliant without a decision only the author can make
  — a pronoun with no recoverable antecedent, a missing fact, an ambiguity that
  changes the meaning. Make the most reasonable choice, then flag what you
  assumed.
- The source states a safety-relevant fact that implies an unstated action (for
  example, "discharge time is about 5 minutes" implies "wait before you touch
  it"). Don't invent the step, but flag it so the author can add a caution.
- The text was already compliant (see Step 3).

Keep notes rare and to one line; most text needs none.

## Examples

**Blended — a wordy internal doc:**
Input: "In order to utilize the new dashboard, users should simply navigate to
the settings page, where they will be able to enable it. It is important to note
that this may take a few minutes to take effect."
Output: "To use the new dashboard, go to the settings page and turn it on. The
change can take a few minutes to take effect."

**`ste-strict` — a procedure:**
Input: "The operator should ensure that the valve is closed prior to commencing
the pressure test, and it is recommended that adequate illumination be provided
in the vicinity of the work area."
Output:
"1. Make sure that the valve is closed.
2. Make sure that there is sufficient light near the work area.
3. Start the pressure test."

**`google` — release-note copy:**
Input: "We've made it easy for users to simply export their data — just click
the button below and the file will be generated by the system."
Output: "You can now export your data. Click **Export**, and the system
generates the file."
