# Aesthetics & Visual Composition — interface-design-expert lens
**Impact: contextual — a *dial*, not a floor.** It intensifies with intent (consumer / brand /
first-impression products high; safety / utility / expert tools low, where beauty collapses into
*clarity and coherence*). It **never overrides the floors** below.

Run this lens **after** the per-property lenses — it judges the *assembled whole*, not parts in
isolation. Resolve numbers via the value-resolution rule in [`../SKILL.md`](../SKILL.md); the shared
perceptual basis (Gestalt) lives in [`foundations.md`](foundations.md).

Each principle is tagged: **[evidence]** = grounded in perception research; **[craft]** = a useful
generative heuristic that is *not* an empirical predictor of preference — apply it, don't cite it as law.

## Principles — composition (the screen as a perceived whole)

- **Compose to one focal point. [evidence]** Every screen needs a clear first-stop; make one element
  differ on a dimension (size, weight, color, isolation) nothing else shares — the odd-one-out is
  the strongest attention magnet.
- **Make contrast decisive, not timid. [evidence]** Near-miss differences (slightly different sizes
  or weights) read as mistakes; commit to clear deltas so differences read as intent. (This is
  contrast as *craft* — distinct from the accessibility contrast *floor*.)
- **Establish rhythm with repetition. [evidence]** Repeat a spacing / size / shape interval for a
  scannable cadence; break it deliberately to mark a shift.
- **Treat negative space as active. [evidence]** Whitespace is a composing element and the strongest
  grouping cue (proximity) — space *is* structure, not leftover.
- **Guide the eye path. [evidence]** Order the focal sequence to match natural scan (reading order);
  let alignment and leading edges carry the eye.
- **Resolve to one coherent whole (unity). [evidence]** The screen must read as a single intentional
  object, not a pile of individually-correct parts; keep figure-ground unambiguous. This Gestalt
  coherence is the bedrock under everything above.
- **Balance visual weight. [craft]** Distribute weight (size, darkness, saturation, isolation) so
  the frame doesn't feel like it tips; asymmetric balance usually reads livelier than dead symmetry.
  *"Balanced = preferred" is a generative heuristic, not a measured law — direct tests find no
  reliable preference.*
- **Derive sizes from one proportion. [craft]** Use a consistent ratio between size tiers so jumps
  feel intentional. *Skip golden-ratio / rule-of-thirds mysticism — there's no reliable preference
  for them; a committed, consistent scale is what reads as "composed."*

## Principles — emotional & contextual read

- **Beauty is emotional, and emotion is functional. [evidence]** Visual appeal is read in the first
  moments and shapes trust, credibility, and tolerance for friction (the aesthetic-usability effect;
  see foundations). Invest in first-impression polish and a coherent visual tone — but it never
  substitutes for working flows.
- **Beauty is a dial tuned to intent, brand, genre, and culture. [principle]** There is no universal
  "beautiful"; judge *fit to context*, not conformance to a current reference look. A maximal RPG HUD
  and a restrained fintech dashboard are each "right" for their world. Treat trend-chasing ("looks
  like today's Dribbble") as a risk — trends decay — and never use style words ("modern", "clean",
  "flat") as if they were virtues.

## The floors it must never breach

Aesthetics cannot buy its way below a floor, and **no aesthetic justifies a floor breach**:
legibility, contrast, visible focus, target sizes, reduced-motion, and the **performance budget**
hold regardless of how good it looks ("minimal/clean" never excuses gray-on-gray text or a 4 MB hero
image). Because beauty **masks problems**, judge appeal *separately from and after* usability, and
**evidence** beauty claims (first-impression / desirability testing) rather than asserting them.

## Review — what to look for

*Weight these against the stated intent (see [`../SKILL.md`](../SKILL.md) → Tradeoffs & intent): floor breaches (accessibility, contrast, color-only meaning, focus, safety) are defects regardless of goal; dials are judged fit-or-misfit to the intent; opportunities (optional techniques) are judged "would this help here?" — their absence is not a finding.*

- **Squint test:** can you find the single focal point in ~1 second? Does one thing clearly lead?
- Does the frame feel weighted to one side without intent (visual balance)?
- Are size / weight / color differences decisive, or timid near-misses that read as errors?
- Is there a discernible rhythm, or arbitrary spacing?
- Do sizes follow one proportional scale, or ad-hoc values?
- Is negative space doing grouping work, or just leftover gaps?
- Does the eye path match the intended reading order?
- Does it read as one coherent object, with clear figure-ground — or scattered correct parts?
- Does the visual tone fit the brand / genre / culture and the stated intent — not just a current trend?
- **Anti-masking:** has appeal been separated from usability? Is any floor (contrast, focus, motion,
  performance) being traded for looks? Is the polish dressing a dark pattern?

## How this lens relates to the others (altitude — don't duplicate)

- **Layout** owns the grid and spacing *skeleton*; this lens judges what that skeleton *produces*
  perceptually (weight, focal flow, the gestalt).
- **Typography / Color** own their *tokens*; this lens judges how type and color *participate as
  visual weight* in the whole — link out, don't re-specify.
- **Consistency** asks "the same across screens?"; this lens asks "resolved *within* one screen?"

## Values

Mostly qualitative. The concrete numbers it touches — contrast floors, type-scale ratio, spacing
grid — live in [`platform-values.md`](platform-values.md) via the Color, Typography, and Layout lenses.
