---
name: interface-design-expert
description: Modern, general-purpose UI/UX design expertise for any kind of interface — web, native desktop (macOS, Windows, Linux), mobile, games, terminal/TUI, voice, and emerging surfaces. Use it to DESIGN new interfaces and to REVIEW/critique existing ones (a screenshot, a described concept, or live code) across multiple design dimensions at once — layout, typography, color & theming, accessibility, interaction & motion, content & voice, navigation & information architecture, consistency, and aesthetics & visual composition — grounded in cognitive & perceptual foundations. Self-contained and built to hand off to a review agent (one lens per agent, in parallel). Reach for it to review/critique an interface, design a UI or design system, choose design principles/tokens, or reason about UX from first principles. Prefer the platform skills (ios/ipados/macos/web-design-guidelines) when the work targets exactly one of those platforms.
license: MIT
metadata:
  version: "2.0.0"
---

# Interface Design Expert

A first-principles instrument for **designing** and **reviewing** interfaces in any medium — web,
desktop, mobile, games, terminal/TUI, voice, spatial, and surfaces nobody has documented yet.
Human perception and cognition don't change with the substrate; only the expression and the values
do. Everything here runs on that split: **principles are universal; values are resolved per
medium; novel problems are derived from the invariants** in
[`rules/foundations.md`](rules/foundations.md), never pattern-matched from another platform.

## The operating loop

Run this for every engagement, both modes:

1. **Establish context and thesis.** The artifact (screenshot / concept / code), the medium and
   platform, the users and their goal. Then name the design's **thesis**: the one or two
   dimensions it must maximize, and which dials it relaxes to get there. If the thesis isn't
   stated, infer it and say what you assumed. *Genericism check: if the thesis would fit any
   product in the category, it isn't doing work — sharpen it until it forces at least one visible
   design choice.*
2. **Resolve every number.** Never emit a quantitative value from memory. Resolution order:
   (1) user/project override → (2) documented platform/medium default → (3) the stricter,
   most-inclusive fallback, named as such. Concrete values live only in
   [`rules/platform-values.md`](rules/platform-values.md). The rule covers **every number in the
   deliverable, including the tail** — line-heights, focus-ring widths, timeouts, panel widths,
   thresholds — not just the headline values. Where no documented source exists, declare the
   choice inline — `(chosen: <one-line rationale>)` — an explicit declaration is provenance;
   silence is not.
3. **Judge each consideration by its kind** — four kinds, four procedures:
   - **Floors** (pass/fail; a breach is a defect regardless of intent): legibility; sufficient
     contrast; meaning never by color alone; function never gated behind motion; system/user
     settings honored; user agency over interruption and immersion (the person — not the product —
     decides when interruptions, full-screen, and immersive modes begin and end); visible focus and
     keyboard operability; data integrity; truthful feedback; honest patterns (transparent about
     what the product does and collects — never deceptive); cheap recovery from mistakes (undo
     where feasible; confirm what can't be undone); a responsiveness floor; and any domain-specific
     safety constraint. Adapt a floor's *expression* per medium; never remove it.
   - **Budgets** (finite aggregates; overdraft is a defect even when each instance fits the
     intent): attention/emphasis, interruption & trust, novelty, motion, performance weight.
     Ceilings derive from the finite-attention and finite-trust invariants and are
     intent-independent — the thesis tunes only the *allocation*. Judge on the whole: a screen can
     pass every per-element check and still be overdrawn. Cite the worst spenders.
   - **Dials** (tuned to the thesis; misfit, not breach): density ↔ whitespace; guidance ↔
     minimalism; motion restraint ↔ expressiveness; ornament ↔ restraint; convention ↔ novelty;
     breadth ↔ depth; consistency ↔ bespoke moments; coexistence ↔ immersion. A relaxed dial in
     service of the thesis is craft; relaxed by accident, a defect. Record which ideal was
     relaxed, for which goal.
   - **Elective moves** (tools, not requirements): continuity transitions, delight moments,
     dynamic theming, coachmarks, deep progressive disclosure. Judge *"would this help here, and
     is it well-executed if used?"* — **absence is never a finding.**
4. **Work the lenses** — generatively (build order below) or evaluatively (survey below). For
   anything novel or ambiguous, derive from [`rules/foundations.md`](rules/foundations.md) first:
   constraint → requirement → candidates (conventional *and* invented) → predict → test.
5. **Deliver the contract** (output formats below), flagging what static work can't confirm —
   motion feel, live-theme contrast — as "needs runtime check." The deliverable speaks the
   client's domain language: never reference this skill's internal machinery ("lenses", "dials",
   "budgets", "the value-resolution rule") inside the artifact — state each rationale in the
   domain's own terms.

## Media: dominant lenses and adaptation

The lenses are substrate-agnostic; what changes per medium is the input model, the dominant
lenses, and the values (resolve per the rule above; surface-specific values and constraints live
in [`platform-values.md → Surfaces beyond the defaults`](rules/platform-values.md#surfaces-beyond-the-defaults)).

| Interface | Input model | Dominant lenses |
|---|---|---|
| Web | pointer + touch + keyboard | layout · accessibility · navigation/IA |
| Native desktop | pointer + keyboard | interaction · consistency (platform conventions) · layout |
| Mobile / tablet | touch (+ pointer) | layout (reach) · interaction · accessibility |
| Games | gamepad / KBM / touch | interaction (latency, focus-nav) · aesthetics · accessibility (build it yourself) |
| Terminal / TUI | keyboard-first | layout (cell grid) · interaction · color (palette limits) |
| Voice / conversational | speech (+ keypad) | content/voice · interaction · navigation/IA |
| Spatial / XR | gaze + gesture | interaction (comfort floors) · layout (depth) · accessibility |
| Wearable / TV / novel | varies | derive from foundations; resolve values per the rule |

When you know the target is exactly iOS, iPadOS, macOS, or the web platform, also consult that
platform skill (`ios-design-guidelines`, `ipados-design-guidelines`, `macos-design-guidelines`,
`web-design-guidelines`) for concrete components; this skill is the primary reference for
everything else and for cross-platform work.

## Designing (build order)

**Default posture: boring by default, novel on purpose.** Absent a thesis reason, take the
established convention — spend the novelty budget only where the thesis demands a visible
difference. Each step names its governing lens and produces an artifact the next step consumes:

1. **Thesis & dial settings** → one paragraph: intent, maximized dimensions, relaxed dials, the
   emotion the product should evoke *(foundations, aesthetics)*.
2. **Conceptual model & objects** → the user-facing objects, their relationships, and the actions
   on them — match models users already hold *(foundations)*.
3. **Structure** → organization, labels, navigation, search; entry architecture (what gates the
   first session) *(navigation-ia)*.
4. **Layout system** → grid/spacing unit, hierarchy per screen, responsive/adaptive behavior
   *(layout)*.
5. **Interaction model & bedrock states** → the few bedrock tasks, each with a full state map
   (default/hover/focus/disabled/loading/error/empty); input methods; forgiveness (undo/confirm)
   *(interaction)*.
6. **Tokens** → type scale, semantic color (light+dark), spacing, motion — every value resolved
   with provenance *(typography, color-theming, platform-values)*.
7. **Copy** → labels, prompts, errors in the product's voice; transparency at every ask
   *(content-voice)*.
8. **Composition pass** → squint test per key screen: one focal point, decisive contrast, coherent
   whole; spend the emphasis budget deliberately *(aesthetics)*.

**Self-check before delivering (cheap, not a full review):** floors — all of them, against the
list above; budgets — any aggregate overdrawn?; squint test on the primary screen; state-walk one
bedrock task end to end; and **sweep the finished artifact for bare numbers** — every numeral,
down to line-heights, widths, breakpoints, and timeouts, carries a source or a `(chosen: …)` tag.
The tail values are where this always fails. Then ship the spec as **structure + key screens/states + tokens +
rationale** (which constraint each major decision serves). Treat it as a starting point: prototype
early, discard what doesn't work — craft is ongoing, not a phase.

## Reviewing (survey)

1. Run the operating loop (context, thesis, value resolution).
2. **Select lenses.** All nine + foundations for a full review; the medium's dominant lenses for a
   quick pass; one lens for a focused question. Fan out one agent per lens for thorough work
   (briefing below).
3. **Calibrate severity:** floor breach → `blocker`/`high` · budget overdraft → `high` (judged on
   the aggregate; cite the worst spenders) · dial misfit → `medium` (fit-to-thesis, argued) ·
   polish → `low` · elective-move absence → not a finding (at most a suggestion).
4. **Synthesize weighted by the thesis** — do the right dimensions win, and is any floor breached
   or budget overdrawn?

```
## <Artifact> — design survey
**Context:** <medium · platform · users/goal · artifact type>
**Intent:** <thesis and maximized dimension(s) — stated or inferred>
**Summary:** <2–3 sentences: overall read and the most important takeaways>

### Findings
- **[<Dimension> · <blocker/high/medium/low>]** <Principle> — <the issue, concretely, located> — Fix: <what to do>

### Tensions & tradeoffs
- <ideal relaxed, for which goal — and whether the call is sound>

### Needs runtime check
- <motion / live-theme items static review can't confirm>

### Strengths
- <what's working, so it survives the fixes>
```

## Dimensions (lenses)

| # | Dimension | Lens file | Owns |
|---|---|---|---|
| — | Cognitive & perceptual foundations | [`rules/foundations.md`](rules/foundations.md) | the invariants; deriving the novel |
| 1 | Layout & visual hierarchy | [`rules/layout.md`](rules/layout.md) | the eye's first stop; grids; adaptation |
| 2 | Typography | [`rules/typography.md`](rules/typography.md) | type system; legibility; measure |
| 3 | Color & theming | [`rules/color-theming.md`](rules/color-theming.md) | semantic color; modes; contrast |
| 4 | Accessibility | [`rules/accessibility.md`](rules/accessibility.md) | floors made concrete; AT; settings |
| 5 | Interaction, states & motion | [`rules/interaction.md`](rules/interaction.md) | states; agency; feedback; motion |
| 6 | Content & voice | [`rules/content-voice.md`](rules/content-voice.md) | words; tone; transparency |
| 7 | Navigation & IA | [`rules/navigation-ia.md`](rules/navigation-ia.md) | structure; wayfinding; entry |
| 8 | Consistency | [`rules/consistency.md`](rules/consistency.md) | tokens; conventions; cohesion |
| 9 | Aesthetics & visual composition | [`rules/aesthetics.md`](rules/aesthetics.md) | the assembled whole; emphasis budget; emotion |

Numbers for every dimension: [`rules/platform-values.md`](rules/platform-values.md).

## Handing off to a review agent

Each lens file is self-contained. Per agent:

```
Review <artifact> with the interface-design-expert skill.
Context: medium=<…>, platform=<…>, users/goal=<…>. Intent: <thesis>.
Lens: <one lens>. Read its file in interface-design-expert/rules/, apply its principles as checks,
plus its "Checks beyond the principles". Consult foundations.md for the why; resolve every number
via platform-values.md (never invent one).
Judge by kind: floors and budget overdrafts are defects regardless of intent (severity: floors →
blocker/high, budgets → high on the aggregate); dials are fit-to-thesis (medium); absence of an
elective technique is never a finding.
Return the survey format: [Dimension · severity] principle — issue (located) — fix, plus Tensions,
Needs runtime check, Strengths.
```

Merge agent results, de-duplicate, and re-rank severities against the calibration above.
