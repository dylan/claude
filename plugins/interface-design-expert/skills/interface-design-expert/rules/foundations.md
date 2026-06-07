# Cognitive & Perceptual Foundations — interface-design-expert lens

The nine dimensions are *conclusions*; these are the human invariants they're derived from. This is
the engine the other lenses run on. Reach for it to reason about **novel, ambiguous, or high-stakes**
problems where copying a convention isn't enough and you need to *derive* a solution. Read each
invariant as **constraint → design move**.

## Invariants

- **Working memory is small (~4 chunks).** Don't make people hold information across steps; chunk
  and group, carry context forward, surface current state. *(The "7±2" figure is a misreading — it
  is not a menu-length limit; the lever is chunking, not a magic number.)* → Layout, Nav/IA, Content
- **Recognition beats recall.** Show options and state rather than making people remember names,
  codes, or earlier screens. → Navigation/IA, Interaction
- **Bigger and closer targets are faster (Fitts's law).** Size and place primary actions
  generously, exploit screen edges and corners, and expand hit areas beyond the visible shape.
  → Layout, Interaction
- **More choices slow decisions (Hick's law).** Reduce or stage options; use progressive disclosure
  and sensible defaults for dense decisions. → Navigation/IA, Interaction
- **Affordance is a relationship; the cue you draw is the signifier.** What's possible depends on
  the user's capabilities and context, so you must *supply* perceivable signifiers — never assume a
  control "obviously" looks interactive. → Interaction, Accessibility, Consistency
- **People bring mental models from elsewhere.** Match models users already hold, and give a
  coherent, usefully-simplified conceptual model rather than exposing internals — innovate the
  substance, keep the model learnable. → Navigation/IA, Consistency
- **Grouping reads pre-attentively (Gestalt).** Proximity, similarity, alignment, and common region
  register before reading — use them to encode hierarchy. → Layout, Typography
- **Complexity is conserved (Tesler's law).** Every task has irreducible complexity; absorb it in
  the system rather than pushing it onto the user. → Content, Navigation/IA
- **Response time shapes perception.** Keep interactions within the flow-of-thought window; show
  feedback when work runs long and progress-plus-cancel when it runs much longer (numbers in
  platform-values). → Interaction/Motion
- **Attention is selective and quality is cumulative.** People miss what's outside their focus (and
  tune out ad-like regions); over a multi-step experience sustained quality matters — don't bank on
  polishing only the peak and the ending. → Layout, Content, Interaction
- **Beauty is functional, fast, and double-edged (aesthetic-usability effect).** Visual appeal is
  judged in the first moments and raises *perceived* usability, credibility, trust, and tolerance
  for friction — but it is mostly *perception* (not raw task speed), it decays with repeated use, and
  it **masks real defects in evaluation**. → Invest in first-impression polish and derive beauty from
  fluency levers (alignment, symmetry, contrast, coherent/prototypical form); never let it substitute
  for working flows; test usability *separately from* appeal. → Aesthetics, Layout, Color

## The generative method

When no convention cleanly fits, derive rather than copy:

1. **Name the human constraint** at play — memory, attention, motor cost, choice cost, mental
   model, perception, timing.
2. **State the requirement** that constraint imposes on any acceptable solution.
3. **Enumerate *and invent* candidates** — list conventional patterns *and* novel ones that could
   satisfy the requirement. Innovation lives in this step; don't stop at the first familiar answer.
4. **Predict each candidate** against that constraint *and* the other invariants (a fix that
   relieves one constraint often violates another).
5. **Prototype and test** with real users; keep what both the constraint-check and the evidence
   support. The test step is not optional — a clever derivation can still be wrong.

### Constraint-test checklist

Before committing to a pattern, check it against each relevant invariant:

- **Memory** — does it require holding anything across steps/screens? Can it be recognized instead?
- **Choice cost** — how many options at once? Can they be staged, grouped, or defaulted?
- **Motor cost** — are frequent/primary targets large, close, and reachable?
- **Signifiers** — is every possible action perceivably cued for the *actual* user and context?
- **Mental model** — does it match what users already expect; is the conceptual model coherent?
- **Grouping** — does visual structure encode the intended hierarchy pre-attentively?
- **Complexity** — is irreducible complexity absorbed by the system, not dumped on the user?
- **Timing** — does feedback arrive within the flow-of-thought window?
- **Attention** — does it survive selective attention; is quality sustained, not just peak/end?
- **Accessibility** — does it hold for different capabilities, input modes, and assistive tech?

## Worked derivations

### 1. Navigation — a settings screen with ~40 options

- **Constraint:** working-memory limits + choice cost rises sharply with flat option count; users
  scan, they don't read.
- **Requirement:** never present 40 equal choices at once; support both known-item finding *and*
  browsing.
- **Candidates:** flat alphabetical list · grouped categories · search/filter · "most-used" +
  recents · progressive disclosure (summary → detail) · usage-adaptive surfacing.
- **Predict:** a flat list fails choice-cost and scanning; pure search fails discoverability
  (recognition beats recall); grouped categories + persistent search + a recents shortcut satisfies
  memory, choice cost, and both finding modes.
- **Decide & test:** grouped categories with persistent search and a recents shortcut; validate the
  grouping with tree testing / card sorting and check labels against destination headings.

### 2. Input — a frequent primary action on a large touch screen

- **Constraint:** target-acquisition cost grows with distance and shrinks with size; one-handed
  reach is limited; the action repeats often.
- **Requirement:** minimize travel and size cost for the single most frequent action without
  crowding the rest.
- **Candidates:** top-bar button · floating action button in the thumb zone · edge/corner anchor ·
  gesture · duplicate the action next to the content it affects · command palette/shortcut.
- **Predict:** a top-bar button is far from the thumb (high distance cost); a gesture-only control
  fails signifiers and discoverability; a thumb-zone primary *plus* a keyboard/command alternative
  covers reach, frequency, and power users.
- **Decide & test:** thumb-zone primary action with a visible signifier + a command/shortcut path;
  validate with reach maps, tap-error rate, and time-on-task.

## Common misapplications (don't repeat these)

- **"7±2 limits how many items a menu or nav can show."** No — that figure is about one-dimensional
  *absolute judgment*, not item memory or menu length. The real simultaneous limit is ~4 and depends
  on chunk complexity; the lever is **chunking and grouping**, not a magic number. Set option counts
  by content scope and findability.
- **Treating cognitive load as a measurable additive budget.** The intrinsic / extraneous / germane
  split is a useful *lens*, not separately measurable or strictly additive. Operationally: cut
  **extraneous** load (clutter, split attention, redundancy) and manage **intrinsic** load by
  chunking, sequencing, and matching the user's expertise. Don't claim to "measure germane load."
- **"Affordance = the visual cue."** The affordance is the *possible action* (object × user
  capability); the visible cue is the **signifier**, which you must supply. When the team says
  "affordance," pin down which sense is meant.
- **Reciting Fitts's law as a precise formula.** Use the qualitative relationship — bigger and
  closer is faster, edges and corners behave as effectively huge — not a memorized equation; it
  breaks down for overlapping or time-constrained targets.
- **Treating "0.1 s = instant" as a hard law.** Aim for near-immediate feedback on direct
  manipulation, but the well-supported thresholds are ~**1 s** (flow of thought) and ~**10 s**
  (attention). See [`platform-values.md` → Motion](platform-values.md#motion).
- **Peak-end rule as a universal.** For rich, multi-step experiences and memories that persist,
  sustained *average* quality predicts the remembered experience better than the peak and ending
  alone — don't optimize only those two moments.
- **Treating beauty as proof of usability.** The aesthetic-usability effect makes an attractive
  design *feel* more usable and earns tolerance — but much of that is a halo (controlling for
  processing fluency collapses most of the correlation), it fades with use, and in a usability test
  it hides the very problems you're testing for. Bank beauty for first-impression trust and adoption,
  never as evidence that flows work; score appeal and usability separately, usability first.

## Invariant → dimension map

| Invariant | Primary dimensions it governs |
|---|---|
| Working memory / chunking | Layout · Navigation & IA · Content |
| Recognition over recall | Navigation & IA · Interaction |
| Target size & distance (Fitts's law) | Layout · Interaction · Accessibility |
| Choice cost (Hick's law) | Navigation & IA · Interaction |
| Affordance & signifiers | Interaction · Accessibility · Consistency |
| Mental & conceptual models | Navigation & IA · Consistency |
| Pre-attentive grouping (Gestalt) | Layout · Typography |
| Conservation of complexity (Tesler's law) | Content · Navigation & IA |
| Response-time thresholds | Interaction & Motion |
| Selective attention / cumulative quality | Layout · Content · Interaction |
| Aesthetic-usability / processing fluency | Aesthetics · Layout · Color |

Hard numbers (target sizes, response-time thresholds, text spacing) live in
[`platform-values.md`](platform-values.md), not here.
