# ASD-STE100 Simplified Technical English — Reference

Load this file when running in **`ste-strict`** mode, or when the user
explicitly asks for Simplified Technical English / STE compliance.

## What STE is

ASD-STE100 Simplified Technical English (STE) is a *controlled natural
language*: a restricted subset of English designed so that safety-critical
technical documentation is unambiguous and easy to read, including for
non-native English speakers and machine translation. It was born in aerospace
maintenance manuals and is now used across defense, medical devices, and
engineering.

- Maintained by ASD (AeroSpace, Security and Defence Industries Association of
  Europe), via the STE Maintenance Group (STEMG).
- **Issue 9** (15 January 2025) is the current standard: 53 writing rules in 9
  sections, plus a dictionary of ~900 approved general words.

STE is far stricter than ordinary "plain English." It trades away tonal
warmth and vocabulary range for maximum precision. That trade-off is the whole
point — do not soften it in this mode. If the user wants a friendlier result,
they should use `google` or the blended default instead.

## The two components

1. **Writing rules** — how to build sentences, verbs, and paragraphs.
2. **The dictionary** — a closed list of ~900 approved general words, each with
   one controlled meaning and one approved part of speech. On top of the core
   dictionary, each project adds its own *Technical Names* (nouns) and
   *Technical Verbs*. You will not have the full dictionary; apply the rules and
   the substitution table below, and prefer the shortest common word for a
   concept.

## The 9 rule sections

### 1. Words
- Use only approved words with their one approved meaning. **One word = one
  meaning** (no using a word for a second sense) and **one meaning = one word**
  (no synonyms — pick a single word per concept and reuse it).
- Use a word only as its approved part of speech. Do not verb a noun
  ("oil the bearing" → "Apply oil to the bearing").
- No slang, jargon, idioms, or colloquialisms.
- Use one consistent spelling per word.

### 2. Noun clusters
- **No noun cluster longer than 3 nouns.** Break longer stacks apart with
  prepositions and articles.
  - ✗ "runway light connection resistance calibration"
  - ✓ "calibration of the resistance in the connection for the runway lights"

### 3. Verbs
- Use only these forms: infinitive, imperative, simple present, simple past,
  simple future, and the past participle **used only as an adjective**.
- **No `-ing` forms** (gerunds/present participles) except inside an approved
  Technical Name ("landing gear", "wiring diagram").
- **Active voice.** Passive is allowed only in descriptive text when the actor
  is unknown or irrelevant — never in procedures.
- **Imperative for every instruction** ("Open the valve", not "The valve should
  be opened").
- No compound/perfect tenses. Replace present perfect with simple past.

### 4. Sentences
- **Procedural (instruction) sentence: 20 words maximum.**
- **Descriptive sentence: 25 words maximum.**
- **One instruction per sentence.** Two actions → two sentences.
- One topic per sentence.
- Keep articles (a, an, the) — do not write "telegraphically" ("Remove the
  bolt", not "Remove bolt").

### 5. Procedures
- Sequential steps become separate numbered instructions, each starting with a
  command verb.
- No narrative, no passive.
- Put the condition/qualifier **before** the command ("Before you start the
  engine, make sure that the area is clear").

### 6. Descriptive writing
- Active voice; keep the ≤25-word limit.
- Present tense for permanent facts; simple past for events.
- Logically ordered paragraphs, one topic each.

### 7. Warnings and cautions
- Put the warning/caution **before** the step it applies to — never after.
- Start with a clear command (what to do or not do), then give the reason.
  ("Do not touch the terminals. High voltage can kill you.")
- Warning = risk to people. Caution = risk to equipment.

### 8. Punctuation and word counts
- Simple punctuation. Use colons and dashes for vertical/tabular layouts.
- Avoid slashes and parentheses for essential meaning; avoid semicolons
  (prefer two sentences).
- Enforce the sentence word-count caps from section 4.

### 9. Writing practices
- **Paragraph: 6 sentences maximum.**
- One topic per paragraph; new topic → new paragraph.
- Vary sentence construction so text stays readable.

## Approved-word substitutions

Apply these in `ste-strict` mode. Treat the list as representative of the STE
dictionary's intent, not exhaustive — when a word is not here, prefer the
shortest, most common everyday word for the meaning.

| Avoid | Use |
|---|---|
| commence, initiate | start / begin |
| terminate, cease | stop |
| in order to | to |
| prior to | before |
| subsequent to, following | after |
| in the vicinity of, adjacent to | near |
| utilize, employ | use |
| assist | help |
| obtain, procure | get |
| sufficient, adequate | enough |
| approximately | about |
| accomplish, perform, execute | do |
| ascertain, verify, confirm, ensure, check | make sure (of) |
| illumination | light |
| endeavor, attempt | try |
| in the event that | if |
| a number of, numerous | many / several |
| defective, inoperative | not correct / does not work |
| de-energize | remove the electrical power |
| depress (a button) | push / press |
| additional | more |
| component | part |
| require | need |
| indicate | show |
| permit | let |
| retain | keep |

## Before → after (non-STE → STE)

| Non-STE | STE | Rule triggered |
|---|---|---|
| "The valve should be opened prior to commencing the test." | "Open the valve before you start the test." | active/imperative; *prior to*→before; *commence*→start |
| "It is recommended that the operator verify that all connections are secure." | "Make sure that all the connections are tight." | one-word-one-meaning (*verify*→make sure); active; article |
| "Removing the panel, disconnect the wiring harness." | "1. Remove the panel. 2. Disconnect the wiring harness." | no `-ing`; one action per sentence; sequential steps |
| "Ensure adequate illumination in the vicinity of the work area." | "Make sure that there is enough light near the work area." | *ensure*→make sure; *adequate*→enough; *illumination*→light; *in the vicinity of*→near |
| "The high-pressure fuel line pressure sensor calibration procedure is complex." | "The procedure to calibrate the pressure sensor for the high-pressure fuel line is difficult." | noun cluster >3; simpler words |
| "Do not touch the wires after the power has been applied." | "Warning: Do not touch the wires. Electrical power can kill you." | warning before the step; command + reason |

## Checklist for `ste-strict` output

- [ ] Every instruction is imperative and active.
- [ ] No `-ing` verb forms (except technical names).
- [ ] No procedural sentence over 20 words; no descriptive sentence over 25.
- [ ] No paragraph over 6 sentences.
- [ ] No noun cluster over 3 nouns.
- [ ] One instruction per sentence; steps numbered where sequential.
- [ ] Warnings/cautions before the step, command first then reason.
- [ ] Unapproved words swapped for their approved equivalents.
- [ ] Articles kept; no telegraphic style.
