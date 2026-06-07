# Interaction, States & Motion — interface-design-expert lens
**Impact: HIGH**

Resolve numbers via the value-resolution rule in [`../SKILL.md`](../SKILL.md) and
[`platform-values.md`](platform-values.md).

## Principles — interactive states

Every interactive element needs a deliberate *set* of states, not just a default look — missing
states are where an interface feels broken.

- **Core states (always):** default, hover, active/pressed, focus, disabled.
- **Functional states (where they apply):** loading, success, error, selected/toggled.
- **Keep role, style, and state distinct.** A control's *role* (submit, toggle), its *style*
  (primary / secondary / ghost), and its *state* (hover, disabled…) are independent dimensions — a
  primary submit button moves through every state without changing role or style.
- **Affordance:** a control must look interactive in its *default* state. Don't hide that something
  is clickable until the user hovers it.
- **Focus is non-negotiable.** Show a visible focus indicator for keyboard and assistive-tech
  users; never remove it without a clear custom replacement.
- **Disabled needs a reason.** Pair a disabled control with a tooltip or inline message saying what
  would unblock it — otherwise users just click a dead button.
- **Loading and error carry the flow.** Disable during loading to prevent duplicate submissions; an
  error state must say what went wrong and offer a way to retry.
- **Never signal a state by color alone** — pair it with icon, text, weight, or shape.
- **Map the full set of states** (and what each leads to) for complex flows, so edge cases — failed
  payment, stalled upload, unavailable action — surface before build, not in production.
- **Nail the bedrock before breadth.** Identify the few tasks people repeat constantly and make
  those fast and dependable before adding features; an opinionated, intentionally narrow surface
  beats a broad, shallow one.
- **Reveal complexity progressively.** Surface the next relevant option as the user advances rather
  than presenting everything at once; emphasis should track priority.

## Principles — motion

Motion serves function, stays subtle, and respects attention.

- **Purposeful, not decorative.** Motion should orient (where did this come from / go?), give
  feedback, or direct attention — not entertain. The best interface motion may go unnoticed.
- **Fast for routine, expressive for rare.** Keep everyday micro-interactions quick; reserve
  vibrant or celebratory motion for occasional important moments.
- **Consistent and predictable.** The same kind of change animates the same way everywhere; use a
  small set of easing and duration tokens rather than bespoke curves.
- **Treat motion as a consistent personality, not one-off effects.** Easing and timing carry tone,
  so derive a small shared set of curves and reuse it; keep transitions spatially continuous (a
  panel animates from its real origin), and periodically audit and cut purposeless motion.
- **Motion can improve usability — reach for it when it helps, not by default (opportunity).**
  Continuity / shared-element transitions — a tapped card expanding to fill the screen, a thumbnail
  opening to its detail, a row morphing into an editor — animate the *same object* from its origin so
  the user keeps their bearings across a context change, preserving object permanence and answering
  "where did this come from / go?". Most screens don't need this and its **absence is never a
  defect**; when you do use it, keep it fast and give a reduced-motion fallback (instant cross-fade
  or cut) so the function survives without the animation.
- **Remove motion that's noticed too often.** If users consciously notice an animation repeatedly,
  shorten or cut it.
- **Always honor Reduce Motion.** Provide a non-animated path; never gate function behind motion.
- **Immediate feedback.** Every interactive element acknowledges input (pressed/hover/focus/loading
  states) within a perceptual instant.

## Review — what to look for

*Weight these against the stated intent (see [`../SKILL.md`](../SKILL.md) → Tradeoffs & intent): floor breaches (accessibility, contrast, color-only meaning, focus, safety) are defects regardless of goal; dials are judged fit-or-misfit to the intent; opportunities (optional techniques) are judged "would this help here?" — their absence is not a finding.*

- Are the core states present for every interactive element (default/hover/active/focus/disabled)?
- Are functional states handled where needed (loading/success/error/selected)?
- Is affordance clear in the *default* state, not hidden until hover?
- Is there a visible focus indicator, never removed without a replacement?
- Do disabled controls explain what would unblock them?
- Does loading disable to prevent duplicates, and do errors explain + offer retry?
- Is any state signalled by color alone?
- Are the bedrock tasks fast and dependable; is complexity revealed progressively?
- Is motion purposeful and fast for routine actions, using a small shared set of easing tokens?
- Where a tap changes context, *would* a continuity / shared-element transition help — and if one is used, is it fast with a reduced-motion fallback? (Opportunity — its absence is fine.)
- Is Reduce Motion honored, and does feedback arrive within a perceptual instant?

## Values

See [platform-values.md → Motion](platform-values.md#motion) and
[Component states](platform-values.md#component-states).
