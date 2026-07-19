# Google Developer Documentation Style — Reference

Load this file when running in **`google`** mode, or when the user asks for
Google developer-docs style / "Google style."

Home: developers.google.com/style · Word list: developers.google.com/style/word-list
Base guide for anything unspecified: Chicago Manual of Style + Merriam-Webster.

## What this mode optimizes for

Clear, friendly, developer-facing documentation. Unlike STE, Google style keeps
a human, conversational register: contractions are fine, gerunds are fine
("Creating a bucket"), and there is **no closed dictionary** — only a blocklist
of words to avoid. Preserve the author's warmth and voice; tighten and correct,
don't sterilize.

## Voice, tense, grammar

- **Second person.** Address the reader as "you," not "we" or "the user"
  (a deliberate "let's" in a tutorial is fine).
- **Active voice.** The subject performs the action ("The command creates a
  file," not "A file is created").
- **Present tense.** "The command prints X," not "will print."
- **Imperative mood** for instructions ("Click **Save**").
- **Condition before instruction.** "To delete the file, click **Delete**" —
  not "Click Delete to delete the file, if you want to remove it."
- Standard American spelling; **serial (Oxford) comma**.

## Words to avoid (word list)

| Term | Verdict | Use instead |
|---|---|---|
| please | avoid in instructions | drop it ("Click Save", not "Please click Save") |
| simply / simple | don't use | remove; describe the actual steps |
| easy / easily | don't use | remove; state what to do |
| just | avoid | usually filler; use "only" if you mean only |
| e.g. | don't use | "for example" / "such as" |
| i.e. | don't use | "that is" |
| etc. | avoid | remove, or complete the list |
| in order to | avoid | "to" |
| via | caution | "with," "through," "by using" |
| and/or | don't use | rewrite ("x or y, or both") |
| allow (user capability) | avoid | "lets you" / "you can" |
| kill / abort / terminate | avoid | "stop," "cancel," "exit," "end" |
| hang | don't use | "stop responding" |
| native | avoid | "built-in," "runs directly on" |
| whitelist / blacklist | don't use | "allowlist" / "denylist" |
| master / slave | don't use | "primary/replica," "main," "leader/follower" |
| sanity check | don't use | "quick check," "validation" |
| dummy | don't use | "placeholder," "sample" |
| he / she (generic) | don't use | singular **they** |
| should (when you mean must) | clarify | "must" for requirements |
| note that | trim | usually removable filler |
| above / below (location) | avoid | "preceding/following," or a link |

## Sentence and paragraph length

- Prefer **short sentences; one idea per sentence.** Split a long sentence into
  several, or into a list. No hard word cap, but trim aggressively: cut
  "there is / there are," filler adverbs, and needless subordinate clauses.
- **Short paragraphs** (about 3–5 sentences), one topic each. Lead with the key
  point (bottom line up front).

## Lists and tables

- Numbered list = ordered sequence (steps). Bulleted list = unordered set.
  Description list = term/definition pairs.
- **Parallel structure:** every item starts with the same part of speech and
  grammatical form (all imperative verbs, or all noun phrases).
- Capitalize the first word of each item. Use a period only if any item is a
  full sentence (then punctuate them all).
- Introduce a list with a lead-in sentence ending in a colon.
- Use a table for multi-dimensional data; give every table a header row.

## Headings and titles

- **Sentence case** ("Configure the database," not "Configure The Database").
- Descriptive and unique; don't stack two headings with no text between them.
- Don't make a heading the antecedent of a pronoun in the body text.

## Clarity

- One idea per sentence.
- **Fix ambiguous pronouns.** "this," "that," "it," "they" need a clear, nearby
  antecedent — prefer "this *noun*" ("this setting," not bare "this").
- **Define acronyms on first use:** full term, then "(ABC)"; then use the
  acronym. Don't define an acronym you use only once.
- **Descriptive link text** — the linked words name the destination ("see the
  installation guide"), never "click here."
- Code font for code, commands, filenames, values; **bold** for UI element names.
- Unambiguous dates ("January 5, 2026," not "1/5/26").

## Accessibility and inclusive language

- Alt text on meaningful images; don't rely on color or spatial position alone
  ("the red button," "the box on the left").
- Avoid ableist language ("sanity check," "crippled," "dummy"), gendered terms,
  and violent metaphors ("hit," "kill," "hang").
- Use singular "they." Avoid "guys," "master/slave," "whitelist/blacklist."
- Write for a global audience: avoid idioms, cultural references, humor, and
  Latin abbreviations that don't translate.

## Before → after (Google)

| Before | After | Rule |
|---|---|---|
| "In order to simply deploy the app, just click here." | "To deploy the app, click **Deploy**." | *in order to*→to; drop *simply/just*; descriptive UI/link text |
| "The file will be created by the system." | "The system creates the file." | active voice; present tense |
| "Please note that this may fail." | "This deployment can fail if the quota is exceeded." | drop *please note*; fix ambiguous *this*; be specific |
| "Users can utilize the API to fetch data, e.g. logs." | "You can use the API to fetch data, such as logs." | second person; *utilize*→use; *e.g.*→such as |
| "Once it's done, it shows a message." | "After the build finishes, the console shows a message." | ambiguous *it* → specific antecedents |

## Checklist for `google` output

- [ ] Second person, active voice, present tense.
- [ ] No blocklisted words (please/simply/just/easy, e.g./i.e./etc., in order to,
      allow, whitelist/blacklist, etc.).
- [ ] Conditions placed before instructions.
- [ ] Ambiguous "this/that/it" given explicit antecedents.
- [ ] Acronyms defined on first use.
- [ ] Descriptive link text; sentence-case headings.
- [ ] Lists parallel; numbered for sequences, bulleted for sets.
- [ ] Inclusive, globally readable language.
- [ ] Friendly, human tone preserved (contractions and gerunds are fine).
