# Color & Theming — interface-design-expert lens
**Impact: CRITICAL**

Color is **functional, not decorative**, and **theme-resolved, never hard-coded**. Resolve numbers
via the value-resolution rule in [`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **Use color to communicate.** Brand, status/feedback, continuity, and comprehension — judicious
  use enhances communication; overuse distracts and reduces clarity.
- **Color meaning is contextual, not universal.** The same hue carries different connotations
  across cultures and contexts (red can mean danger, or luck and celebration; white can mean
  purity, or mourning). Don't assume a color reads the way you intend — validate brand and status
  colors for the target audience, and never rely on a learned convention (red = error) as the
  *only* signal.
- **Define semantic / role-based color tokens.** Name colors by *role* (label, primary, on-primary,
  surface, error…), not by hue. This is the single most important theming rule.
- **Themes are automatic, not per-app toggles.** Respect the system light/dark preference; don't
  build an app-specific appearance switch that fights it. Ensure the UI looks right in *both* modes.
- **Dark mode is not an inversion.** Use dimmer backgrounds and brighter foregrounds; convey depth
  with layered surfaces (e.g. a brighter "elevated" surface for foreground content). Test with
  increase-contrast and reduce-transparency on.
- **Meet contrast by design.** Bake accessible contrast into the palette so correct use can't
  produce a contrast failure. Offer higher-contrast variants where possible.

## Review — what to look for

*Weight these against the stated intent (see [`../SKILL.md`](../SKILL.md) → Tradeoffs & intent): floor breaches (accessibility, contrast, color-only meaning, focus, safety) are defects regardless of goal; tunable choices are judged as fit or misfit to the intent.*

- Is color carrying meaning (status / brand / continuity), or just decorating? Is it overused?
- Is any meaning conveyed by color alone, without an icon/text/shape backup?
- Are colors defined as semantic role tokens, or hard-coded hex values?
- Does it respect the system light/dark setting and look right in both? Any app-specific toggle fighting the system?
- Is dark mode a real adaptation (dimmer bg, brighter fg, layered surfaces), not a literal inversion?
- Does contrast pass in *every* theme? Is a higher-contrast variant available?
- Have culturally-loaded hues been validated for the target audience?

## Values

See [platform-values.md → Color & theming](platform-values.md#color--theming).
