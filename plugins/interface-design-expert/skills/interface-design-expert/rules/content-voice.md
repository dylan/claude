# Content & Voice — interface-design-expert lens
**Impact: HIGH**

Words are UI. Write for the user's goal. Qualitative dimension — no platform numbers to resolve.

## Principles

- **Plain, simple, direct — and for everyone.** *(fluency)* Goal-oriented style over strict
  grammar; concise but not robotic. Style signals who the product is "for": define or avoid
  specialized terms, skip idioms and culture-bound humor (they don't travel), and drop unnecessary
  gender references — neutral nouns, plural pronouns, nongendered imagery for generic people.
- **One consistent voice, contextual tone.** *(convention)* Voice (the product's attitude) stays
  constant; tone varies by moment — lighter in onboarding, calm in errors, brief in confirmations.
- **Lead with the user's benefit or action.** *(attention, signifiers)* Label buttons with the
  verb of what happens ("Save changes", not "OK"); front-load the important word.
- **Error messages help, don't blame.** *(agency-trust, learning)* Say what happened, why, and
  the way out — next to the problem, phrased as the positive fix ("Use only letters", not "Don't
  use numbers"), no insincere "oops!". Prevent where you can: state expected formats up front
  (labels, placeholder examples, defaults); when something fails or can't be measured, say what
  still works; if words alone can't stop a frequent error, redesign the interaction.
- **Be consistent in terminology.** *(recognition, learning)* Same concept, same word everywhere.
- **Address the person directly.** *(convention)* "You/your" for the person, "we/our" only for
  the company — and keep "we" out of error messages, where its referent is unclear ("Unable to
  load content"). Avoid "the user"/"the player", trim needless possessives ("Favorites", not
  "Your Favorites"), and hold one perspective throughout.
- **Structure content by meaning; state each fact once.** *(models)* Model content by what it
  *is* (a product, a step, a question-and-answer pair), keep related pieces together as one
  reusable unit, and reuse it everywhere it appears — duplicated copy drifts out of sync and
  erodes trust. Front-load the user's intent over the brand's framing.
- **Organize by the user's task, not internal structure.** *(models, attention)* Replace FAQ
  dumps and feature-led pages with purposeful, task-titled content and short topic headings
  ("Online payment options"), not repetitive question strings.
- **Write for linear consumption.** *(convention, memory)* Device-agnostic verbs ("choose", not
  "click"/"tap"); instructions in chronological order ("next…", not "the button below"); critical
  information *before* the field or action it governs.
- **Labels predict their consequence.** *(signifiers, models)* Before someone commits, the words
  say exactly what will happen: undo names the operation it reverses ("Undo Typing"); exit
  controls say whether they pause, step back, or quit — with a chance to save before a quit-style
  exit; sign-in buttons name the method; search states its scope; sharing controls summarize
  current access ("Only invited people can edit"). Don't overload platform-reserved terms.

## Principles — transparency & honesty (floor)

- **Give the real rationale at the point of the ask.** *(agency-trust)* When asking for a
  permission or for data: what's collected, why it's needed, how it's used, in plain words. A
  vague or missing rationale reads as having something to hide.
- **Ask for the minimum — asks spend a trust budget.** *(agency-trust)* Each ask can fit its
  feature, yet the aggregate overdraws: front-loading every permission at launch erodes trust
  before the product has earned any. Tie each ask to the moment its value is obvious, and judge
  the volume of asks on the whole.
- **No deceptive patterns.** *(agency-trust)* No confirmshaming ("No thanks, I hate saving
  money"), trick wording, double negatives in consent, false urgency or scarcity, or burying the
  decline option. Honest framing is a **floor**, not a tone choice — no intent justifies it.

## Checks beyond the principles

*Weight per [SKILL.md → operating loop](../SKILL.md): floors and budget overdrafts are defects regardless of intent; dials are fit-to-thesis; an elective move's absence is never a finding.*

- Read every error message asking: does it say what happened, why, and the way out?
- Walk each permission/data ask: does the copy give its rationale at the point of the ask?
