# Color & Theming — interface-design-expert lens
**Impact: CRITICAL**

Color is **functional, not decorative**, and **theme-resolved, never hard-coded**. Resolve numbers
via the value-resolution rule in [`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **Use color to communicate.** *(attention)* Color spends the emphasis **budget**, judged on the
  aggregate: every accent can be justified per-instance while the screen overall is overdrawn.
- **Brand with one accent, applied systemically.** *(attention, agency-trust)* One accent token
  propagated to interactive elements, not a wholesale recolor — and where the platform offers a
  user-chosen accent, it replaces the brand's: user preference outranks brand color.
- **Color meaning is contextual, not universal.** *(convention)* The same hue reads differently
  across cultures and contexts (red: danger, or luck and celebration; white: purity, or mourning).
  Don't assume a color reads as intended, and never rely on a learned convention (red = error) as
  the *only* signal.
- **Define semantic / role-based color tokens.** *(models)* The single most important theming rule.
  Name colors by *role* (label, primary, on-primary, surface, error…), not hue, with explicit
  variants per appearance (light, dark, higher-contrast) even if one mode ships today. Use each role
  only for its intended job: a separator color used as text, or secondary-text used as a background,
  breaks when the theme changes — variants are tuned to the role's foreground/background context.
- **Themes are automatic, not per-app toggles.** *(agency-trust)* Respect the system light/dark
  preference — no app-specific switch fighting it — and make the UI right in *both* modes.
- **Dark mode is not an inversion.** *(fluency)* Dimmer backgrounds and brighter foregrounds;
  depth via layered surfaces (a brighter "elevated" surface for foreground content).
- **Guarantee legibility over imagery and translucency.** *(fluency)* Content over photos, video,
  or blur sits on an unpredictable backdrop: protect anything text-heavy with a scrim or more-opaque
  surface variant; color foregrounds with adaptive, backdrop-aware tokens, never fixed values;
  reserve high transparency for sparse controls where the media should dominate. Every translucent
  surface must respond to reduce-transparency / increase-contrast settings.
- **Meet contrast by design.** *(fluency)* Bake accessible contrast into the palette so correct
  token use can't produce a contrast failure; offer higher-contrast variants.
- **Theme imagery, icons, and logos too.** *(recognition)* Tokens re-theme automatically; assets
  don't. A dark glyph, or a mark on a pure-black/pure-white field, merges into the matching
  surface — fix the asset (e.g. a subtle outline) or supply per-theme variants under one logical
  asset name; a dark variant is a subdued version of the same mark, not a new design.

## Checks beyond the principles

*Weight per [SKILL.md → operating loop](../SKILL.md): floors and budget overdrafts are defects regardless of intent; dials are fit-to-thesis; an elective move's absence is never a finding.*

- Test both modes with increase-contrast and reduce-transparency turned on.
- Verify text-over-imagery against the worst-case backdrop, not the demo image.
- Audit every icon, illustration, and logo in each theme at its shipped size and local background.
- Validate culturally-loaded brand and status hues with the target audience.

## Values

See [platform-values.md → Color & theming](platform-values.md#color--theming).
