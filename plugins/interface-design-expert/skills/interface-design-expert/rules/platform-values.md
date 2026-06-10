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

Guidance lives in the [color-theming lens](color-theming.md); the operative values: every semantic
token carries a light/dark pair, and both modes must pass the contrast table above — verify with
increase-contrast and reduce-transparency enabled.

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
| Text enlargement | usable with text scaled to **200 %** (**140 %** on watch-sized screens) — via the platform's dynamic text mechanism or equivalent custom scaling |
| Text spacing (user-adjustable, no loss) | line-height **≥ 1.5×** font size · paragraph **≥ 2×** · letter **≥ 0.12×** · word **≥ 0.16×** |
| Link / control text | meaningful out of context (avoid repeated "Learn more"); names programmatically associated |

---

## Motion

| Purpose | Duration | Easing |
|---|---|---|
| Micro-interaction (state, hover, ripple) | **~90–150 ms** | standard ease, e.g. `cubic-bezier(0.2, 0, 0, 1)` |
| Standard transition (small/medium area) | **~200–300 ms** | standard / decelerate on entry, accelerate on exit |
| Large or expressive transition | **~300–500 ms** (rarely >600 ms) | emphasized, e.g. `cubic-bezier(0.05, 0.7, 0.1, 1)` |

- **Response-time thresholds:** keep interactions within ~**1 s** to preserve the user's flow of
  thought; show working feedback once past ~1 s, and a progress indicator + cancel past ~**10 s**.
  Aim for near-immediate feedback on direct manipulation (treat "0.1 s = instant" as a soft target,
  not a hard law). Launch counts too: target ≤ ~**2 s** from start to the first usable screen, and
  past a couple of seconds show an indicator (or partial content) rather than a blank screen.

---

## Component states

State sets are defined in the [interaction lens](interaction.md) (core: default · hover ·
active/pressed · focus · disabled; functional: loading · success · error · selected). The values:

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
  adjustments. Snap spacing to the unit; keep body content within a readable max width (see
  Measure, above).

---

## Elevation & depth

- A **small set of elevation / layer tokens**, applied consistently — shadow-based and/or tonal
  (a brighter or blurred surface reads as "higher"); change elevation only in response to
  interaction.
- **Translucency needs a legibility budget:** when a highly transparent surface sits over bright
  underlying content, back it with a dark dimming layer — Apple's figure is **35 % opacity** — so
  foreground content keeps contrast; skip the scrim when what's underneath is already dark. And the
  thinner/clearer the material, the fewer low-contrast text tiers it can carry — drop the faintest
  label tier on the thinnest materials.

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
  frame rate** (feedback within a frame or two; a *consistent* **30–60 fps** reads as smooth — ship
  per-device defaults so players don't have to tune settings first); distinguish diegetic (in-world)
  UI from HUD; and **build accessibility yourself** (remappable controls, subtitle sizing,
  colorblind-safe encodings) rather than inheriting it from an OS.
- **Terminal / TUI:** the grid is **character cells**, not pixels — size and align to cells; the
  minimum target is a full row/cell with a clear focus highlight; color is limited (16 / 256 /
  truecolor, and the user may override the palette) so never rely on exact hues; there are no images,
  so carry state with text, symbols, and box-drawing; keep it usable over low-bandwidth SSH.
- **Spatial / XR:** targeting is gaze + gesture, so space controls generously (see table below) and
  never let interactive elements overlap; comfort is a floor — avoid sustained oscillating motion
  (people are most sensitive around **0.2 Hz**; if you must oscillate, keep amplitude low and make
  the content translucent), keep immersive experiences inside a safety boundary (~**1.5 m** from the
  wearer's starting position, fading to passthrough as they approach it), and let people set their
  own immersion level (**120–360°** is the documented default adjustable range) — visionOS's figures.
- **Voice / conversational:** no visual scanning — keep options few (recall is costly), confirm
  destructive or irreversible actions, and front-load the outcome.

Where a surface has documented values, they track **viewing distance and input precision** (Apple's
figures below, as the best-documented exemplars — substitute your platform's own where published):

| Surface | Body type (default / min) | Control size (default / min) | Spacing & safe zones |
|---|---|---|---|
| Desktop (pointer) | 13 pt / 10 pt | 28 × 28 / 20 × 20 pt | pointer precision permits the smaller sizes |
| TV / 10-foot | **29 pt / 23 pt** | **66 × 66 / 56 × 56 pt** | inset content **60 pt** top/bottom and **80 pt** from the sides; pad focusables so the enlarged focus state never overlaps a neighbor |
| Spatial / XR (gaze) | 17 pt / 12 pt | **60 × 60 / 28 × 28 pt** | control centers ≥ **60 pt** apart with ≥ **16 pt** clear space; interactive elements never overlap |
| Wearable / watch | 16 pt / 12 pt | 44 × 44 / 28 × 28 pt | text enlargeable to **140 %** (vs **200 %** elsewhere — see Accessibility) |

The pattern: 10-foot type runs roughly **2×** desktop sizes, and gaze or distance demands wider
*spacing*, not just bigger targets.

---

## Notes

- **These are platform values, not universals.** When platforms disagree (e.g. 44 pt vs 48 dp vs
  24 px for touch targets), resolve per the priority order at the top of this file.
- **Standards evolve.** Contrast and target thresholds track the current WCAG version — re-verify
  against the latest release when it matters.
