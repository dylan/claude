# Layout & Visual Hierarchy — interface-design-expert lens
**Impact: CRITICAL**

Establish hierarchy so the eye lands on what matters first. Resolve numbers via the value-resolution
rule in [`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **Prioritize essential content, in reading order.** *(attention)* the most important thing gets
  space and prominence, top and leading where the scan starts, not crowded by nonessential detail.
- **Treat reading direction as a layout parameter.** *(convention)* Build with leading/trailing,
  not left/right. Where spatial order carries meaning (chronology, rank, steps), reverse it when
  mirrored — but digit order *within* numbers (phones, prices, IDs) never reverses; keep one
  alignment for every item in a list, even mixed-script items, so the scan line holds.
- **Align deliberately.** *(grouping, fluency)* shared edges signal organization and speed
  scanning; align leading elements (icons, avatars, thumbnails) to one edge.
- **Group with proximity and rhythm.** *(grouping)* related items sit close; consistent spacing
  between groups creates rhythm; containers or dividers only when proximity isn't enough.
- **Let content own the canvas; float chrome above it.** *(signifiers, attention)* Extend content
  to the display/window edges; layer controls *over* it rather than carving opaque slabs beside
  it — layering signals control vs. content; a forward element (a sheet over its dimmed backdrop)
  reads as prominent. Chrome may hide for focal content if an easy, familiar gesture restores it.
- **Respect safe areas; keep essentials in the safe zone.** *(convention)* Honor platform safe
  areas and guides — no collisions with hardware cutouts, system chrome, or overscan. Where a
  container may crop, scale, or animate its contents (hover/focus, TV edges, masked icons), keep
  essentials centered away from the edges; on aspect-ratio change, scale and crop, never stretch.
- **Design from the content out.** *(fluency)* Anchor layout to a constant in the content (ideal
  line length, a key module's proportions); breakpoints go where relationships break, not at
  device-class widths — devices change faster than you can enumerate them. Components respond to
  their container and content, not the screen; structure uses relative units with min/max bounds.
- **Collapse late; grow by proportion.** *(memory, recognition)* Stay recognizable across sizes:
  design the full-size layout first and keep it while it fits — shed tertiary panes first when
  narrowing; when growing, change proportions, not which elements appear. Assume arbitrary user
  tilings; keep critical controls off a movable window's bottom edge — it often sits off-screen.
- **Design for input mode and grip, not just screen size.** *(motor)* place primary actions within
  comfortable one-handed reach, enlarge anything in hard-to-reach corners, and adapt target size,
  contrast, and asset weight to finger-vs-pointer and ambient conditions.
- **Let text scaling reshape the layout.** *(fluency)* When users scale text up, adapt the whole
  layout, not just the type: enlarge meaningful icons alongside text, switch crowded inline
  arrangements to stacked ones, reduce column counts, keep hierarchy anchored near the top — as
  much useful text at the largest sizes as at standard, not truncated.
- **Treat performance and resilience as design constraints.** *(timing)* a layout that doesn't
  load is a failed design — a floor. Usable baseline without styling/scripts first, then enhance.

**Mechanism — Gestalt:** hierarchy comes from proximity, similarity, common region, continuity.

## Checks beyond the principles

*Weight per [SKILL.md → operating loop](../SKILL.md): floors and budget overdrafts are defects regardless of intent; dials are fit-to-thesis; an elective move's absence is never a finding.*

- Render mirrored (RTL locale or forced direction): semantic order reversed, digit order within
  numbers preserved, one alignment per list with mixed scripts, no hard-coded left/right.
- Resize through the tiled/snapped window sizes users actually choose: tertiary panes shed first,
  growth changes proportions rather than the set of visible elements.
- Load with styling, scripts, and heavy assets disabled: a usable baseline must survive.
- Where a screen "looks busy," name which Gestalt grouping is missing — that names the fix.

## Values

See [platform-values.md → Spacing & grid](platform-values.md#spacing--grid).
