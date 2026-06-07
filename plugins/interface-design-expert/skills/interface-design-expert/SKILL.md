---
name: interface-design-expert
description: Modern, general-purpose UI/UX design expertise for any kind of interface — web, native desktop (macOS, Windows, Linux), mobile, games, terminal/TUI, voice, and emerging surfaces. Use it to DESIGN new interfaces and to REVIEW/critique existing ones (a screenshot, a described concept, or live code) across multiple design dimensions at once — layout, typography, color & theming, accessibility, interaction & motion, content & voice, navigation & information architecture, consistency, and aesthetics & visual composition — grounded in cognitive & perceptual foundations. Self-contained and built to hand off to a review agent (one lens per agent, in parallel). Reach for it to review/critique an interface, design a UI or design system, choose design principles/tokens, or reason about UX from first principles. Prefer the platform skills (ios/ipados/macos/web-design-guidelines) when the work targets exactly one of those platforms.
license: MIT
metadata:
  version: "1.0.0"
---

# Interface Design Expert

A multi-lens instrument for **designing** and **reviewing** interfaces of any kind — web, native
desktop, mobile, games, terminal/TUI, voice, spatial. It surveys a **screenshot**, a **described
concept**, or **live code** across nine independent design dimensions, each backed by a
self-contained lens file, all resting on shared **cognitive & perceptual foundations**. Run as many
lenses as the task needs — one for a focused question, all of them for a full review — sequentially
or fanned out to agents (one lens each).

The principles are universal; the **numbers are not** (see the value-resolution rule below).

## How this skill relates to the platform skills

This is the **cross-platform foundation**. When you know the target platform, also consult the
specific skill — `ios-design-guidelines`, `ipados-design-guidelines`, `macos-design-guidelines`, or
`web-design-guidelines` — for concrete components and code. For every other surface — **Windows,
Linux, games, terminal/TUI, voice, spatial/XR, or anything cross-platform** — this skill is the
primary reference. Use it when the work is platform-agnostic, spans multiple platforms, concerns a
design system, or no platform skill covers the target.

## Works on any interface

The nine dimensions and the foundations are **substrate-agnostic** — they describe human perception
and cognition, which don't change with the medium. What changes per interface type is the
*expression*: the input model, the available affordances, and the concrete values. Establish the
**interface type** alongside the platform, then adapt the expression while keeping the principles.

| Interface | Input model | Adapt especially |
|---|---|---|
| Web | pointer + touch + keyboard | responsive/fluid layout; WCAG; progressive enhancement |
| Native desktop (macOS / Windows / Linux) | pointer + keyboard | platform window/menu/shortcut conventions; higher density; pointer precision |
| Mobile / tablet | touch (+ pointer) | reach/thumb zones; larger targets; system light/dark & text scaling |
| Games | gamepad / KBM / touch | focus-based nav (no cursor); diegetic vs HUD; readable at distance (10-foot/TV); latency & frame budget; **build your own accessibility**; safe-area/overscan |
| Terminal / TUI | keyboard-first | monospace **character grid** (cells, not pixels); limited color palette; focus via highlight; no images; usable over low-bandwidth SSH |
| Voice / conversational | speech / text | linear and unscannable — keep choices few and recall-light; confirm destructive actions; short turns |
| Spatial / XR | gaze + gesture / controller | depth & comfort; large targets; minimal head movement; legibility against the real world |

For surfaces with no platform skill, resolve numbers per the rule below — falling back to the
most-inclusive/most-accessible value when a surface has no documented one. See
[platform-values.md → Surfaces beyond the defaults](rules/platform-values.md#surfaces-beyond-the-defaults).
The lens files use generic terms ("screen", "control", "view") — read them against your target medium.

## Core rule: principles are universal, values are resolved

Every quantitative spec (touch-target size, text minimum, motion duration, grid unit) is a
**parameter, not a constant**. Never emit a hard number from memory. Resolve it in this order:

1. **User-specified** — if the user or project pins a value ("min target 40pt", "base type 16px"), it wins.
2. **Platform default** — if the target platform is known, use its documented value.
3. **Most-inclusive fallback** — if neither is given, pick the *stricter / most accessible* value
   (e.g. 48dp ⊇ 44pt) so output is safe everywhere, and say so.

Always establish **"what platform?"** before committing to numbers. All concrete values live in
[`rules/platform-values.md`](rules/platform-values.md) — link there rather than inlining numbers.

**Verify at runtime, not just on paper.** Two things can't be confirmed by reading code or specs:
**motion** (does it honor Reduce Motion? does it feel fast?) and **live-theme contrast** (does text
actually pass in light *and* dark with increase-contrast on?). Flag these as "needs runtime check"
rather than passing them silently.

## Tradeoffs & intent

Good design is not "satisfy all nine dimensions equally" — it's making the **right** dimensions win
for the product's goal without breaching a floor. The nine dimensions conflict by design (denser
layout vs. breathing room; guidance vs. minimalism; expressive motion vs. restraint; ornament vs.
restraint; novelty vs. convention), so judge them **weighted by intent**, not as a flat checklist.

- **Lead with intent.** Before anything, name the design's *thesis* and the **one or two dimensions
  it must maximize**. Everything else is in service of that. A dense expert tool maximizes
  efficiency/information density and minimizes hand-holding; an onboarding flow inverts it; a game
  maximizes immersion and *expressive* motion (the opposite of "motion goes unnoticed"); a
  safety-critical console maximizes error-prevention and accepts slower flows.

- **Floors vs. dials.** Distinguish what you may *tune* from what you may not *trade away*:
  - **Floors (non-negotiable — adapt the expression per medium, never remove):** legibility;
    not encoding meaning by color alone; sufficient contrast; never gating function behind motion;
    honoring system/user settings; visible focus / keyboard operability; data integrity; truthful
    feedback; a performance/responsiveness budget; and any domain-specific safety constraint (e.g.
    confirming destructive actions, input latency in a game).
  - **Dials (tune to intent):** information density ↔ whitespace; guidance ↔ minimalism; motion
    restraint ↔ expressiveness; ornament ↔ restraint; convention ↔ novelty; breadth ↔ depth;
    consistency ↔ bespoke moments. Most legitimate "compromises" are dial settings, not floor breaches.

- **A deviation is only as good as its reason.** Relaxing a dial to serve the intent is craft;
  relaxing it by accident is a defect. Record which ideal was relaxed, for which goal — turn a
  silent compromise into a reviewable decision.

- **Beauty is a dial — and a special case.** Aesthetics intensifies with intent (and earns real
  trust and tolerance — see foundations), but it **never lowers a floor**, and it can *mask* defects:
  judge appeal *separately from and after* usability, and evidence beauty claims rather than
  asserting them. See the [Aesthetics lens](rules/aesthetics.md).

This reframes both modes: a **review** asks "do the right dimensions win for the stated intent, and
is any floor breached?" — not "is every box ticked." A **design** chooses which dials to push *before*
satisfying the rest.

## How to run a multi-dimensional survey

1. **Establish context and intent.** What's the artifact — a screenshot, a concept, or code? What
   platform and who are the users / what's the goal? Name the design's *thesis* and the dimension(s)
   it must maximize (see **Tradeoffs & intent**) — this **reweights the lenses** and drives
   value-resolution. If the intent isn't stated, infer it and say what you assumed.
2. **For a novel or ambiguous problem, derive first.** Before reaching for conventions, load
   [`rules/foundations.md`](rules/foundations.md) and work the generative loop (name the human
   constraint → state the requirement → enumerate *and invent* candidates → predict against the
   constraints → prototype & test).
3. **Select dimensions.** Default to **all nine** for a full review; pick a subset for a focused
   question. Each dimension is an independent lens — load its file (below) and apply its
   *Review — what to look for* checklist.
4. **Apply the lenses.** Sequentially for a quick pass. For a thorough review, run them **in
   parallel — one subagent per dimension** — since the lenses are independent; then merge results.
   Always include the foundations lens as the cross-cutting "why".
5. **Synthesize, weighted by intent.** Produce findings in the output format below. Separate
   **floor breaches** (defects — call them out regardless of intent) from **dial settings** (judge
   as *fits / doesn't fit* the stated intent, not as universal faults), and record genuine
   **tensions** where serving the goal meant relaxing an ideal. Resolve every number via the
   value-resolution rule, and flag motion / live-theme-contrast items as "needs runtime check".

## Designing a new interface

Same lenses, run generatively instead of evaluatively:

1. **Frame it and commit to a thesis.** Fix the interface type and platform, the users, and the
   *few core tasks* (the bedrock) the design must nail — then name the **one or two dimensions to
   maximize** and which dials you'll relax to serve them (see **Tradeoffs & intent**). Decide the
   tradeoffs on purpose, up front.
2. **Derive, don't copy.** Take the structure and key interactions from
   [`rules/foundations.md`](rules/foundations.md) (constraint → requirement → enumerate *and invent*
   candidates → predict), especially for anything novel.
3. **Satisfy each dimension.** Walk the lenses, applying their principles; choose tokens and values
   via the value-resolution rule, adapted to the interface type.
4. **State the model and the rationale.** Give the conceptual model and note which constraint each
   major decision serves, so the design can be reviewed and evolved rather than just admired.

Output a brief **spec + rationale** (structure, key screens/states, tokens, and the why) rather than
findings.

## Dimensions (lenses)

| # | Dimension | Lens file | Survey it for |
|---|---|---|---|
| — | Cognitive & perceptual foundations | [`rules/foundations.md`](rules/foundations.md) | the *why*; deriving novel solutions |
| 1 | Layout & visual hierarchy | [`rules/layout.md`](rules/layout.md) | what the eye hits first; scanability; responsiveness |
| 2 | Typography | [`rules/typography.md`](rules/typography.md) | type scale; legibility; measure; hierarchy |
| 3 | Color & theming | [`rules/color-theming.md`](rules/color-theming.md) | semantic color; dark mode; contrast |
| 4 | Accessibility | [`rules/accessibility.md`](rules/accessibility.md) | targets; contrast; semantics; AT; settings |
| 5 | Interaction, states & motion | [`rules/interaction.md`](rules/interaction.md) | state coverage; affordance; feedback; motion |
| 6 | Content & voice | [`rules/content-voice.md`](rules/content-voice.md) | clarity; voice/tone; labels; structure |
| 7 | Navigation & IA | [`rules/navigation-ia.md`](rules/navigation-ia.md) | structure; wayfinding; findability |
| 8 | Consistency | [`rules/consistency.md`](rules/consistency.md) | tokens; cohesion; conventions |
| 9 | Aesthetics & visual composition | [`rules/aesthetics.md`](rules/aesthetics.md) | focal point; balance; rhythm; polish; emotional tone *(dial)* |

Concrete numbers for every dimension live in [`rules/platform-values.md`](rules/platform-values.md).

## Output format

```
## <Artifact> — design survey
**Context:** <platform · users/goal · artifact type>
**Intent:** <the design's thesis and the dimension(s) it must maximize — stated or inferred>
**Summary:** <2–3 sentences: overall read and the most important takeaways>

### Findings
- **[<Dimension> · <severity: blocker/high/medium/low>]** <Principle> — <the issue, concretely> — Fix: <what to do>
  (...one per finding, grouped or sorted by severity; floor breaches are defects regardless of intent...)

### Tensions & tradeoffs
- <where serving the intent meant relaxing an ideal: what was relaxed, for which goal — and whether the call is sound>

### Needs runtime check
- <motion / live-theme-contrast items that static review can't confirm>

### Strengths
- <what's already working, so it's preserved>
```

For each finding, name the **principle**, the **issue**, and the **fix**; resolve any number via the
value-resolution rule.

## Handing off to a review agent

Each lens is independent and self-contained, so a review fans out cleanly. To delegate:

- Give the agent the **artifact** (screenshot / concept / code) and the **context** (interface type,
  platform, users/goal).
- For a focused review, name the lenses; for a full review, run **one agent per lens in parallel**,
  then merge their findings and de-duplicate.
- Require the output format above.

Briefing template (fill the `< >` and paste):

```
Review <artifact> using the interface-design-expert skill.
Context: interface type=<web|desktop|mobile|game|TUI|voice|…>, platform=<…>, users/goal=<…>.
Intent: <the design's thesis and the dimension(s) it must maximize>. Weight your lens against this:
flag floor breaches (accessibility, contrast, color-only meaning, focus, safety) as defects
regardless of intent, but judge dial settings (density, minimalism, motion, novelty) as fit/misfit
to the intent — not as universal faults.
Lenses: <all nine | named subset>. For each, read its file in interface-design-expert/rules/ and apply the
"Review — what to look for" checklist; consult foundations.md for the "why" and platform-values.md
for numbers (resolve per the value-resolution rule — never invent a number).
Return: the skill's output format — [Dimension · severity] principle — issue — fix, a "Tensions &
tradeoffs" note, plus "Needs runtime check" and "Strengths". Cite the element/location of each finding.
```

For a parallel sweep, give each agent **one** lens (`Lenses: Accessibility`, etc.) and merge.
