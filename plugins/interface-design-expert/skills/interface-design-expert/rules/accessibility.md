# Accessibility — interface-design-expert lens
**Impact: CRITICAL**

Accessibility is foundational, not a retrofit: inclusive design adapts to users and situations and
benefits everyone — a default, never a separate "accessible version". Nearly everything in this
lens is a **floor**: a breach is a defect regardless of thesis. Resolve every number via
[`../SKILL.md`](../SKILL.md) → value resolution and [`platform-values.md`](platform-values.md).

## Principles

- **Target WCAG AA as the baseline.** *(convention)* Perceivable, operable, understandable.
- **Adequate touch/click targets.** *(motor)* Sized and spaced to hit reliably (per platform).
- **Sufficient contrast in every theme.** *(convention)* Text and meaningful UI clear the minimum.
- **Provide redundant channels for every important signal.** *(signifiers)* Never deliver essential
  information through a single sense or property: meaning never by color alone (pair text, icon, or
  shape); audio cues get visual and haptic equivalents (vital for off-screen events in games and
  spatial UIs); media gets captions and transcripts; haptics and motion stay optional — fully
  usable without them; charts carry accessible value labels, not just a visible summary.
- **Honor accessibility settings — alone and in combination.** *(agency-trust)* Reduce Motion,
  Increase Contrast, Reduce Transparency, and larger text degrade gracefully — and in combination:
  dark plus increased contrast or reduced transparency can leave text illegible though each passes.
- **Semantics & focus.** *(recognition, motor)* An accessible name/role/value on every control;
  keyboard and assistive-tech navigation in a logical focus order with a visible indicator; any
  single-key shortcut needs a remap/disable path (WCAG 2.1.4) — dictation and stray keys fire it.
- **Offer low-effort alternatives to demanding interactions.** *(motor, signifiers)* Every drag,
  multi-finger gesture, or device-motion action has an equivalent visible control, menu, keyboard,
  or clipboard path, exposed semantically so assistive tech can perform it too (a visible delete
  button alongside swipe-to-delete — gestures alone are invisible to keyboard, switch, and voice
  users); and movement is never *required* (bring the object to the person) unless it's the point.
- **Prefer native semantic elements over rebuilt ones.** *(convention)* A real button, checkbox, or
  field gives you focus, keyboard, and state behavior for free; a generic container with an added
  role must reimplement all of it and usually ships incomplete. Reserve roles/ARIA for genuine gaps
  and truly custom widgets.
- **Give every control a real, associated name,** *(recognition)* preferring visible or
  visually-hidden text over attribute-only labels; keep decorative content out of the a11y tree.
- **Treat reading comfort as accessibility.** *(fluency)* Generous line-height and paragraph
  spacing, familiar typefaces, no ultra-thin weights (text-spacing minimums in platform-values).
- **Go beyond a blanket reduce-motion toggle.** *(agency-trust)* Parallax, scrolljacking,
  fixed/pinned backgrounds, and autoplay risk nausea and disorientation — and never hide content
  behind an entry animation that fails to render when motion is suppressed.
- **Use real structure and meaningful link text.** *(recognition)* Landmarks, a heading outline,
  and real lists and tables let content survive reader modes and assistive tech; link/button text
  reads meaningfully out of context (not ten "Learn more"s).

## Checks beyond the principles

*Weight per [SKILL.md → operating loop](../SKILL.md): floors and budget overdrafts are defects regardless of intent; dials are fit-to-thesis; an elective move's absence is never a finding.*

- Operate it end to end by keyboard, then by screen reader — automated checks catch only a fraction.
- Render at 200% text scaling (WCAG 1.4.4): no clipped, overlapping, or lost content or function.
- Test settings in combination — large text with increased contrast together — not one at a time.

## Values

See [platform-values.md → Accessibility](platform-values.md#accessibility).
