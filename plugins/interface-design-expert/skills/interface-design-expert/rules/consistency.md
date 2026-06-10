# Consistency — interface-design-expert lens
**Impact: HIGH**

Consistency is a **co-equal foundation**, not a supreme rule — the consistency ↔ bespoke-moments
**dial** in the operating loop: relax it only in service of the thesis, achieve it structurally.
Resolve numbers via [`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **One signal, one meaning.** *(signifiers, learning)* Each color, icon variant, sound, haptic,
  and phrasing/capitalization convention means exactly one thing throughout — above all status and
  interactivity (a color that marks interactive elements must not also style static text, or users
  can't tell what responds). Map feedback channels to a small semantic vocabulary of outcomes.
- **Internal > external consistency, but honor platform conventions.** *(learning, convention)* Be
  consistent with yourself first; then with the platform (a control should behave the way the OS
  taught users it behaves). Deviate only with a deliberate reason.
- **Prefer the platform's standard surface for commodity tasks.** *(memory, convention)* Sharing,
  open/save, printing, sign-in and consent, playback, full-screen, feedback prompts: the system
  versions carry learned trust and muscle memory, handle device capabilities and user settings for
  free, and stay current. A custom replacement can be the right call (an immersive game can
  out-style a stock loading view) — but then mirror the standard closely or diverge unmistakably:
  a near-copy that differs subtly is the worst case, because people can't tell which of their
  habits still work. Keep its safeguards (familiar entry points, opt-outs, frequency limits).
- **Respect what the platform owns.** *(convention, agency-trust)* Never repurpose reserved inputs
  or recognizable system elements — standard shortcuts and gestures (undo, media controls),
  system haptic patterns, branded system visuals — they carry a cross-app contract. Ignore an
  unsupported standard control rather than reassigning it; build custom only for what's missing.
  Don't duplicate system settings (appearance, accessibility, authentication) in-app — the copy
  implies the global choice might not apply — and reference only capabilities present in context.
- **Reuse tokens and components; derive sizes from one ratio.** *(complexity, learning)* Express
  decisions as named tokens and assemble UIs from a shared component set rather than rebuilding
  primitives ad hoc; fewer, geometrically related size options strengthen hierarchy and alignment.
- **Recognizable across contexts.** *(recognition, memory)* Same action set in the same order
  everywhere it's offered; same category scheme on every browsing surface; same form, colors, and
  annotations when one dataset shows at different scopes (preview vs. expanded). Across theme and
  platform variants, vary the *treatment* of core visual elements, not the elements themselves.
- **Make parts look "drawn with the same pen."** *(fluency)* Icon stroke matched to type weight,
  radii to each other, shadow tone to background — element-level cohesion reads as intentional.
- **Treat the design system as a living product.** *(learning)* Versioned, owned, fed back into;
  give each component usage guidance (purpose, when, behavior) or experiences drift while the
  components stay consistent. Prefer flexible components to variant sprawl; retire deliberately.

## Checks beyond the principles

*Weight per [SKILL.md → operating loop](../SKILL.md): floors and budget overdrafts are defects regardless of intent; dials are fit-to-thesis; an elective move's absence is never a finding.*

- Same-pen inspection: compare icon stroke weight to type weight, corner radii across components,
  and shadow/border tone against the background.
- Diff the same component across screens; unexplained variation between instances is drift.

## Values

See [platform-values.md → Elevation & depth](platform-values.md#elevation--depth) and
[Design tokens](platform-values.md#design-tokens).
