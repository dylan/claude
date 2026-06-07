# Accessibility — interface-design-expert lens
**Impact: CRITICAL**

Treat accessibility as foundational rather than a later pass, because it **benefits everyone** (not
only users with disabilities) and because retrofitting it is far more expensive than designing for
it — an inaccessible default quietly excludes real users. Resolve numbers via the value-resolution
rule in [`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **Ground it in the accessibility standard.** Target WCAG AA as the baseline — perceivable,
  operable, understandable.
- **Give everyone the same quality of experience.** Inclusive design adapts to users and
  situations; it is a default, not an add-on or a separate "accessible version".
- **Adequate touch/click targets.** Guarantee targets large enough to hit reliably, with spacing
  between them (resolve the exact size per platform).
- **Sufficient contrast.** Text and meaningful UI must clear the contrast threshold in *every*
  theme. Never encode meaning in color alone — pair with text, icon, or shape.
- **Honor accessibility settings.** Reduce Motion, Increase Contrast, Reduce Transparency, larger
  text — design so these degrade gracefully, not break.
- **Semantics & focus.** Every control has an accessible name/role/value; support keyboard and
  assistive-tech navigation with a logical focus order.
- **Prefer native semantic elements over rebuilt ones.** A real button, checkbox, or field gives
  you focus, keyboard, and state behavior for free; a generic container with an added role must
  reimplement all of it and usually ships incomplete. Reserve roles/ARIA for genuine gaps and truly
  custom widgets.
- **Give every control a real, associated name** (prefer visible or visually-hidden text over
  attribute-only labels), and keep purely decorative content out of the accessibility tree.
- **Treat reading comfort as accessibility.** Generous line-height and paragraph spacing, adequate
  letter-spacing, familiar typefaces, no ultra-thin weights (see text-spacing minimums in
  platform-values).
- **Go beyond a blanket reduce-motion toggle.** Parallax, scrolljacking, fixed/pinned backgrounds,
  and autoplay can trigger nausea and disorientation — treat them as high-risk, and never hide
  content behind an entry animation that fails to render when motion is suppressed.
- **Use real structure and meaningful link text.** Landmarks, a heading outline, real lists and
  tables let content survive reader modes and assistive tech; make link/button text meaningful out
  of context (not ten "Learn more"s); and test by actually operating the UI with keyboard and
  screen reader, not just automated checks.

## Review — what to look for

*Weight these against the stated intent (see [`../SKILL.md`](../SKILL.md) → Tradeoffs & intent): floor breaches (accessibility, contrast, color-only meaning, focus, safety) are defects regardless of goal; dials are judged fit-or-misfit to the intent; opportunities (optional techniques) are judged "would this help here?" — their absence is not a finding.*

- Does it meet WCAG AA (perceivable / operable / understandable) as a baseline?
- Are native semantic elements used, or generic containers with bolted-on roles?
- Does every control have a real, associated name; is decorative content kept out of the a11y tree?
- Are targets large enough and adequately spaced (per platform)?
- Does contrast pass in every theme, and is meaning never color-only?
- Are Reduce Motion / Increase Contrast / Reduce Transparency / larger text honored gracefully?
- Is it keyboard-operable with a logical focus order and a visible focus indicator?
- Is reading comfort (line-height / paragraph / letter spacing) adjustable without breakage?
- Are vestibular risks (parallax / scrolljack / fixed bg / autoplay) controlled, and is no content hidden behind an entry animation?
- Is there real structure (landmarks / headings / lists / tables) and meaningful link text — and has it been operated with keyboard + screen reader?

## Values

See [platform-values.md → Accessibility](platform-values.md#accessibility).
