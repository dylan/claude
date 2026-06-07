# Platform Values Reference

Concrete, platform-specific values for the principles in `../SKILL.md`. **These are not universal
constants.** Resolve every number in this order: (1) user/project override → (2) target-platform
default below → (3) most-inclusive fallback (pick the stricter / most-accessible value and say so).

Legend: **pt** = iOS/macOS points · **dp/sp** = Android density-independent pixels · **px/rem** = web.

---

## Touch targets

| Platform | Minimum target | Spacing between targets |
|---|---|---|
| iOS / iPadOS | **44 × 44 pt** | — |
| Android | **48 × 48 dp** (~9 mm) | **≥ 8 dp** |
| Web | **24 × 24 CSS px** (AA) · **44 × 44** (AAA) | spacing exemption applies |

- **Most-inclusive fallback:** treat **48 dp / 44 pt** as the floor and keep ≥8 dp spacing.

---

## Type scale

| | iOS / macOS | Android | Web |
|---|---|---|---|
| Construction | Dynamic Type text styles | scalable type, Major Second (1.125) base ~14 sp | `rem` scale, root usually 16 px |
| Named roles | LargeTitle → Title → Body → Caption | Display / Headline / Title / Body / Label | h1…h6 / body / caption (your roles) |
| Token bundle | size + weight (via style) | size, weight, line-height, tracking | size, weight, line-height, tracking |
| Min body size | **11 pt** iOS · **10 pt** macOS | scales with user pref (sp) | **16 px** recommended |
| Default body | **17 pt** iOS · 13 pt macOS | ~14–16 sp | ~16 px |
| Unit | pt | sp | rem (rem = px / 16) |

- **Principle:** commit to one ratio (1.125 is a safe default), pick the few roles you need, keep
  *impactful contrast* between adjacent sizes, never go below the platform minimum, and support
  user text scaling (don't lock pixel sizes).
- **Measure (line length):** aim for **~45–75 characters** per line for body text; re-tune measure
  and line-height together whenever the typeface or size changes.

---

## Color & theming

### Semantic / role-based tokens (use these, never raw hex)

| Platform | Typical token set |
|---|---|
| iOS / macOS | `label` / `secondaryLabel` / `tertiaryLabel` / `quaternaryLabel`, system colors, `separator`, `fill` |
| Android | role-based: `primary` / `onPrimary` / `primaryContainer` / `onPrimaryContainer`, `surface`, `error`, … |
| Web | CSS custom properties mapped to roles (`--color-text`, `--color-surface`, `--color-primary`, …) |

### Contrast minimums (WCAG)

| Context | Threshold |
|---|---|
| Body / normal text (AA) | **4.5 : 1** |
| Large text (≥ ~24 px / 18.66 px bold) (AA) | **3 : 1** |
| Non-text / UI components & graphics | **3 : 1** |
| Enhanced (AAA), and a good target for small custom text | **7 : 1** |

Offer a higher-contrast variant where the platform exposes one.

### Dark mode

- **Not an inversion.** Use dimmer backgrounds and brighter foregrounds; some colors flip, others
  don't.
- **Semantic colors auto-adapt.** Define light/dark pairs per role; never hard-code hex.
- **Convey depth with surface tone**, not just shadows — a brighter "elevated" surface advances
  foreground content (modals, popovers); a dimmer "base" surface recedes.
- **Respect the system setting.** Don't ship an app-specific appearance toggle that fights it.
- **Test** in both modes with increase-contrast and reduce-transparency enabled.

---

## Accessibility

| Spec | Value / standard |
|---|---|
| Baseline standard | **WCAG AA** — perceivable, operable, understandable |
| Text contrast | 4.5 : 1 (normal), 3 : 1 (large) — see Color table |
| Non-text / UI contrast | **3 : 1** |
| Touch target | per platform (see Touch targets) |
| Color-only meaning | **prohibited** — always pair with text / icon / shape |
| Motion | provide a **Reduce Motion** path (no function gated behind animation) |
| Settings to honor | Reduce Motion, Increase Contrast, Reduce Transparency, larger / dynamic text |
| Text spacing (user-adjustable, no loss) | line-height **≥ 1.5×** font size · paragraph **≥ 2×** · letter **≥ 0.12×** · word **≥ 0.16×** |
| Link / control text | meaningful out of context (avoid repeated "Learn more"); names programmatically associated |

---

## Motion

| Purpose | Duration | Easing |
|---|---|---|
| Micro-interaction (state, hover, ripple) | **~90–150 ms** | standard ease, e.g. `cubic-bezier(0.2, 0, 0, 1)` |
| Standard transition (small/medium area) | **~200–300 ms** | standard / decelerate on entry, accelerate on exit |
| Large or expressive transition | **~300–500 ms** (rarely >600 ms) | emphasized, e.g. `cubic-bezier(0.05, 0.7, 0.1, 1)` |

- **Principle:** fast and subtle for routine, expressive reserved for rare important moments,
  a small shared set of easing/duration tokens, and **always** a reduced-motion path.
- **Response-time thresholds:** keep interactions within ~**1 s** to preserve the user's flow of
  thought; show working feedback once past ~1 s, and a progress indicator + cancel past ~**10 s**.
  Aim for near-immediate feedback on direct manipulation (treat "0.1 s = instant" as a soft target,
  not a hard law).

---

## Component states

Interactive elements need an explicit, consistent set of states across the system:

- **Core (always):** default · hover · active/pressed · focus · disabled
- **Functional (where relevant):** loading · success · error · selected/toggled

| Concern | Guidance |
|---|---|
| State-change timing | **~100–200 ms** — responsive without being sluggish or easy to miss |
| Focus indicator | clearly visible (e.g. ~3 px ring with offset); contrast against control *and* background; never remove without a visible replacement |
| Disabled | muted fill + reduced contrast, **plus** a tooltip/inline reason; keep it visible so the action reads as possible-but-not-yet |
| State signalling | never color-only — pair with icon, text, weight, or shape |
| Loading | disable the control to prevent duplicate submissions; spinner for short waits, progress bar when measurable |

---

## Spacing & grid

- **Base unit:** an **8 px** grid is the common default, with **4 px** as a sub-step for fine
  adjustments. Snap spacing to the unit.
- **Group by proximity**, establish rhythm with consistent gaps, and use negative space for
  emphasis.
- **Adapt density to breakpoint** — tighter on small screens, more generous on large ones; keep
  content within a readable max width.

---

## Elevation & depth

- Convey depth and hierarchy with a **small set of elevation / layer tokens**, applied consistently.
- Two valid approaches, often combined: **shadow-based** z-elevation, and **tonal / translucent
  surfaces** (a brighter surface or a blurred material layer reads as "higher").
- Prefer subtle, tonal depth cues over heavy shadows; keep components at their default elevation
  and change it only in response to interaction (e.g. a slight lift on hover/drag).

---

## Design tokens

Express every design decision as a **named token** — this is the consistency primitive that makes
theming, dark mode, and platform retargeting tractable:

- **Color** — semantic roles (see Color table).
- **Type** — per-role tokens bundling font / size / weight / line-height / tracking.
- **Spacing** — the base-unit scale.
- **Motion** — easing + duration tokens.
- **Elevation** — z-level / layer tokens.

Assemble UIs from tokens and shared components rather than ad-hoc values.

---

## Navigation & Information Architecture

| Concern | Guidance |
|---|---|
| Menu / disclosure depth | cap interactive depth at **2 tiers**; deeper → mega menu or landing/routing pages |
| Category count | driven by content scope & findability — **no fixed limit** ("7±2" doesn't apply to visible menus); simple sites ~5 top-level, complex sites legitimately more |
| Hidden nav (hamburger) | small-screen compromise only; hiding the main nav roughly **halves discoverability** and markedly slows desktop tasks — prefer visible nav where space allows |
| Label length | short & scannable — aim **≤ ~7 words / ~55 characters**; avoid more than ~**4** sibling labels starting with the same word; ensure labels survive truncation |
| Label ↔ destination | the link label, page heading, and title should agree; use plain task language, not jargon or brand names |
| Ordering | by importance/frequency where a meaningful principle exists; **alphabetical only for long (~20+) lists** where users know the exact label |
| Breadcrumbs | secondary aid; **location-based** (hierarchy), not click history |
| Progressive disclosure | **two tiers** max (key options first, advanced on request) |
| Wayfinding | always show current location ("you are here"); interior pages are common entry points |
| Research | findability → tree testing / card sorting; discoverability → click / usability testing |

The four IA systems — **organization, labeling, navigation, search** — are structural and stay
consistent across platforms; platform conventions govern only how they're presented.

---

## Surfaces beyond the defaults

The tables above lead with web / mobile / desktop because those have documented values. Other
surfaces use the **same resolution rule** — adapt the *expression* and fall back to the
most-inclusive/most-accessible value when nothing is documented:

- **Native desktop (Windows / Linux / macOS):** the pointer is precise, so click targets can be
  smaller than touch (keep a ≥ ~24 px hit area, and respect each OS's own minimum), but honor the
  platform's window, menu, and keyboard-shortcut conventions and its higher information density.
- **Console / TV / "10-foot" UI:** viewed from across a room — scale type and targets up sharply,
  navigate by **focus** (a highlighted element, not a cursor), keep safe-area / overscan margins,
  and never depend on hover.
- **Games:** input is gamepad / KBM / touch; navigation is focus-based; budget for **latency and
  frame rate** (feedback within a frame or two); distinguish diegetic (in-world) UI from HUD; and
  **build accessibility yourself** (remappable controls, subtitle sizing, colorblind-safe encodings)
  rather than inheriting it from an OS.
- **Terminal / TUI:** the grid is **character cells**, not pixels — size and align to cells; the
  minimum target is a full row/cell with a clear focus highlight; color is limited (16 / 256 /
  truecolor, and the user may override the palette) so never rely on exact hues; there are no images,
  so carry state with text, symbols, and box-drawing; keep it usable over low-bandwidth SSH.
- **Voice / conversational:** no visual scanning — keep options few (recall is costly), confirm
  destructive or irreversible actions, and front-load the outcome.

---

## Notes

- **These are platform values, not universals.** When platforms disagree (e.g. 44 pt vs 48 dp vs
  24 px for touch targets), resolve per the priority order at the top of this file.
- **Standards evolve.** Contrast and target thresholds track the current WCAG version — re-verify
  against the latest release when it matters.
