# Layout & Visual Hierarchy — interface-design-expert lens
**Impact: CRITICAL**

Establish hierarchy so the eye lands on what matters first. Resolve numbers via the value-resolution
rule in [`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **Prioritize essential content.** Give the most important information space and prominence;
  don't obscure it by crowding it with nonessential detail.
- **Follow natural reading order.** Place primary content and actions near the top and leading edge
  to exploit how people scan (top→bottom, leading→trailing).
- **Align deliberately.** Alignment communicates organization and hierarchy and makes a screen
  easier to scan; align leading elements (icons, avatars, thumbnails) to a shared edge.
- **Group with proximity and rhythm.** Related items belong close together; consistent spacing
  between groups creates scannable rhythm. Use containers or dividers only when proximity isn't enough.
- **Adapt responsively.** A layout must work and stay *recognizably consistent* across orientation,
  window resize, extra displays, and different devices.
- **Design from the content out.** Anchor the layout to a constant in the content (ideal line
  length, a key module's proportions) and place breakpoints where relationships actually break —
  not at device-class widths. Devices change faster than you can enumerate them.
- **Make components respond to their own container and content,** not the screen, so a module works
  dropped into a main column, a sidebar, or a card grid without rework.
- **Prefer relative/intrinsic units over fixed pixels for structure,** bounded by min/max so an
  element flexes but never becomes unusable (e.g. 50% of container, never under 300 nor over 600).
- **Design for input mode and grip, not just screen size.** Place primary actions within
  comfortable one-handed reach, enlarge anything in hard-to-reach corners, and adapt target size,
  contrast, and asset weight to finger-vs-pointer and ambient conditions.
- **Treat performance and resilience as design constraints** — a layout that doesn't load is a
  failed design. Build a usable baseline that works without styling/scripts, then layer
  enhancements on top.

**Mechanism — Gestalt:** hierarchy is produced by proximity, similarity, common region, and
continuity. When something "looks busy," check which Gestalt grouping is missing.

## Review — what to look for

*Weight these against the stated intent (see [`../SKILL.md`](../SKILL.md) → Tradeoffs & intent): floor breaches (accessibility, contrast, color-only meaning, focus, safety) are defects regardless of goal; tunable choices are judged as fit or misfit to the intent.*

- Does the most important thing draw the eye first, or is it crowded by nonessential detail?
- Do primary content and actions sit top/leading, following reading order?
- Are elements aligned to shared edges — any arbitrary misalignment that hurts scanning?
- Are related items grouped by proximity and consistent rhythm? Are containers/dividers used only where proximity isn't enough?
- Does it adapt across sizes and stay recognizable? Are breakpoints at content-break points, not device classes?
- Would each component still work dropped into a different container?
- Is structure built on relative units with min/max bounds, or brittle fixed pixels?
- Are primary actions in comfortable reach for the likely input mode/grip? Anything stranded in hard-to-reach corners?
- Does a usable baseline survive without styling/scripts/heavy assets?
- Where it "looks busy," which Gestalt grouping (proximity/similarity/common region/continuity) is missing?

## Values

See [platform-values.md → Spacing & grid](platform-values.md#spacing--grid).
