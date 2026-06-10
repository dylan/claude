# Interaction, States & Motion — interface-design-expert lens
**Impact: HIGH**

Resolve numbers via the value-resolution rule in [`../SKILL.md`](../SKILL.md) and
[`platform-values.md`](platform-values.md).

## Principles — interactive states

Every interactive element needs a deliberate *set* of states — missing states read as broken.

- **Map the full state set.** *(signifiers, models)* Core always: default, hover, active, focus,
  disabled; functional where relevant: loading, success, error, selected; role, style, and state
  are independent dimensions. Map where each state leads, so edge cases surface before build.
- **Affordance and focus are visible.** *(signifiers)* Controls look interactive by *default*,
  not just on hover; focus gets a visible indicator, never removed without a replacement (floor).
- **Disabled needs a reason.** *(signifiers)* Pair a disabled control with what would unblock
  it — otherwise users just click a dead button.
- **Loading never blocks; errors carry the flow.** *(timing, attention)* Show something
  immediately, load in the background, disable during loading (no duplicate submits); errors say
  what failed and offer retry. Progress is honest — determinate when known, indeterminate only
  when not, none for near-instant; glanceable surfaces say "you'll be notified", not a spinner.
  Boot placeholders match the real first screen; gate expensive content behind explicit action.
  User-initiated tasks finish unattended in the background, never pinging every completion.
- **Never signal state by color alone** *(recognition)* — pair with icon, text, or shape (floor).
- **Prevent input errors instead of correcting them.** *(motor, choice, memory)* Prefer selection
  over free typing (pickers constrain to valid values and beat a keyboard); auto-format fields so
  invalid input can't exist; derive what the system knows; accept paste and drag; validate in
  place as people enter, not after submission. Show required-ness through control state — submit
  unavailable until required data is present; obscure secrets as typed, never prepopulate them.
- **Nail the bedrock; reveal the rest progressively.** *(complexity, attention)* Make the few
  constantly repeated tasks fast and dependable before adding breadth; options surface as users
  advance.

## Principles — agency & forgiveness

People came to get something done; the interface helps, then gets out of the way.

- **Stay out of the way — never lock people into flows.** *(agency-trust, interruption)* Get
  people directly to the task — chrome, ceremony, and interstitials that delay it need a reason;
  no forced sequences or modes; guided flows (onboarding, wizards) stay easy to skip or escape.
- **Make immersion opt-in and escape obvious.** *(agency-trust)* Launch into the normal/windowed
  context; fullscreen, immersive, or focused modes are the user's explicit choice via a clear
  control, with a prominent in-experience exit — needing OS gestures or hardware buttons to
  escape means a trapped experience. Keep essential controls reachable inside, retain the
  platform's standard exit gesture, never resize the user's window or change display settings —
  the person, not the product, decides when immersion begins and ends (floor).
- **Build forgiveness in.** *(agency-trust)* Consequential actions are reversible — undo/redo,
  drafts, restore — so exploring is safe and recovery is cheap. Prefer undo to confirmation for
  routine actions (prompts get dismissed by reflex); confirming the truly irreversible is a floor,
  and the confirmation restates *every* consequential parameter — what, how much, where/to whom —
  not just the headline item.
- **Use modality deliberately — never stack or branch it.** *(interruption, models)* A modal
  surface (dialog, sheet, voice confirmation turn) suspends its parent and demands explicit
  dismissal: reserve it for focused tasks and critical decisions, full-screen takeovers for
  genuinely immersive multistep work. Never a modal on a modal; a modal is a corridor, not an
  app-within-an-app, its flow linear and single-purpose. If dismissal could discard work,
  intercept it — gesture or button — and offer to save or discard.
- **Make undo deep, visible, and grouped.** *(models, memory)* Undo reaches back to a logical
  checkpoint (the last save), never an arbitrary depth cap; show each undo/redo's result,
  scrolling to it if off-screen, so people never conclude it failed and repeat it; group related
  micro-edits into one unit; an accident-prone trigger (a shake) confirms what will be undone.

## Principles — feedback & the interruption budget

Interruption spends a finite attention-and-trust budget — judged on the aggregate, not per alert.

- **Match the interruption to the stakes.** *(interruption, attention)* Consultable status lives
  on passive, glanceable surfaces; interruptive alerts are for critical, actionable information —
  overuse trains dismissal, eroding the critical. An explicit urgency scale, not the sender's
  wishes, decides what breaks through quiet settings; deferral never delays the content itself.
- **Warn for the unexpected, not the intended.** *(interruption, models)* Warn before unexpected
  irreversible loss, not loss that's the point (routine moves to trash); confirm success only for
  high-stakes outcomes — people assume their actions succeed and need to hear when they fail.
- **Let people dismiss; don't dismiss for them.** *(timing, agency-trust)* UI that vanishes on a
  timer fails slow readers and assistive-tech users — wait for dismissal or persist recoverably.
- **Solicit feedback at natural breaks.** *(interruption)* Rating prompts wait for a stopping
  point, dismiss in one action, respect opt-out, never repeat-pester — repetition lowers opinion.

## Principles — motion

Motion serves function and respects attention; motion volume is a budget judged on the aggregate.

- **Purposeful, not decorative.** *(attention)* Motion orients, gives feedback, or directs
  attention; the best motion goes unnoticed — if users notice one repeatedly, shorten or cut it.
- **Immediate and fast.** *(timing)* Acknowledge every input within a perceptual instant; keep
  routine micro-interactions quick, reserving expressive motion for rare important moments.
- **One motion personality.** *(fluency, learning)* Easing and timing carry tone — derive a small
  shared set of curves and duration tokens; the same kind of change animates the same way
  everywhere; keep transitions spatially continuous (a panel animates from its real origin).
- **Continuity / shared-element transitions (elective move).** *(models, attention)* Animating
  the *same object* from its origin (a card expanding to its detail) preserves bearings across a
  context change; absence is never a defect — used, it stays fast with a reduced-motion fallback.
- **Always honor Reduce Motion.** *(agency-trust)* Never gate function behind motion (floor).
  Reduction is substitution, not removal: fades for translations and zooms, tighter springs,
  remaining motion tied to the gesture, no animated blurs or depth — and nothing moving or
  flashing autoplays without an opt-out and a discoverable stop.
- **Motion follows the gesture — never holds people hostage.** *(models, motor)* Dismissal
  mirrors the invoke spatially (in from the top → away upward); direct manipulation tracks the
  gesture, not played back at the user; every animation stays cancellable and skippable.

## Checks beyond the principles

*Weight per [SKILL.md → operating loop](../SKILL.md): floors and budget overdrafts are defects regardless of intent; dials are fit-to-thesis; an elective move's absence is never a finding.*

- State-walk one bedrock task end-to-end through all its states; every state must lead somewhere.
- Count the interruptions a first session produces (alerts, modals, prompts); cite worst spenders.
- Verify a Reduce Motion path exists for every animation (substitution, not removal).

## Values

See [platform-values.md → Motion](platform-values.md#motion) and
[Component states](platform-values.md#component-states).
