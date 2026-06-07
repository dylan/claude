# Consistency — interface-design-expert lens
**Impact: HIGH**

Consistency is a **co-equal foundation** — important, but not a single supreme rule that overrides
the others. Achieve it structurally. Resolve numbers via the value-resolution rule in
[`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **Ground everything in a shared design language.** Components and patterns should be designed to
  work together for cohesive experiences, derived from one system.
- **Reuse tokens and components.** Express decisions (color, type, spacing, motion, elevation) as
  named tokens and assemble UIs from a shared component set — don't rebuild primitives ad hoc.
- **Treat a design system as a living product, not a one-off deliverable.** Give it versioning, an
  owner, and a feedback loop; without them teams quietly work around it and it fragments.
- **Ship components with usage guidance.** State each component's purpose, when to use it, and how
  it behaves — without this, components stay consistent but the *experiences* built from them drift.
- **Favor flexible components over variant sprawl,** and retire or deprecate deliberately rather
  than only ever adding.
- **Internal > external consistency, but honor platform conventions.** Be consistent with yourself
  first; then with the platform (a control should behave the way the OS taught users it behaves).
  Deviate only with a deliberate reason.
- **Recognizable across contexts.** The experience stays familiar across devices, themes, and states.
- **Make parts look "drawn with the same pen."** Match icon stroke weight and corner radius to the
  typeface, and shadow/border luminosity to the background; element-level cohesion is what makes a
  system feel intentional.
- **Reduce decisions with one proportional system.** Derive sizes from a single ratio so widths and
  steps are geometrically related — fewer, constrained options strengthen hierarchy and alignment.

## Review — what to look for

*Weight these against the stated intent (see [`../SKILL.md`](../SKILL.md) → Tradeoffs & intent): floor breaches (accessibility, contrast, color-only meaning, focus, safety) are defects regardless of goal; dials are judged fit-or-misfit to the intent; opportunities (optional techniques) are judged "would this help here?" — their absence is not a finding.*

- Is the work grounded in a shared design language, or a patchwork of one-offs?
- Are decisions expressed as named tokens, with UIs assembled from shared components rather than ad-hoc primitives?
- Is the design system treated as a living product (versioned, owned, with a feedback loop)?
- Do components ship with usage guidance (purpose, when, behavior)?
- Are components flexible rather than a sprawl of variants, with deliberate deprecation?
- Is it internally consistent first, and do platform conventions get honored — with deviations justified?
- Does the experience stay recognizable across devices, themes, and states?
- Do the parts look "drawn with the same pen" (icon weight/radius matched to type; shadow luminosity to background)?
- Is there one proportional system behind sizes and spacing?

## Values

See [platform-values.md → Elevation & depth](platform-values.md#elevation--depth) and
[Design tokens](platform-values.md#design-tokens).
