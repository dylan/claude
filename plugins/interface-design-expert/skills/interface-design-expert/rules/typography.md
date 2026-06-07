# Typography — interface-design-expert lens
**Impact: CRITICAL**

Drive type from a **system, not ad-hoc choices**. Resolve numbers via the value-resolution rule in
[`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **Use a tokenized type scale.** Define a finite set of roles (display → body → label/caption),
  each a token bundling size + weight + line-height + tracking. Pick a ratio (a Major Second, 1.125,
  is a safe default) and commit to it.
- **No single product uses every style.** Select the few roles the content needs; ensure
  *impactful contrast* between adjacent sizes (avoid near-duplicates).
- **Enforce legible minimums.** Set a minimum size appropriate to viewing distance and device;
  never ship body text below it.
- **Respect user text-size preferences.** Support dynamic/scalable text (sp, rem) so type reflows
  when users enlarge it — don't lock pixel sizes.
- **Color type for legibility.** Keep running text neutral and high-contrast; reserve accent color
  for primary actions and emphasis.
- **Choose for legibility at size.** Prefer typefaces with a generous x-height and open counters
  for body and UI text — they hold up at small sizes and lower contrast.
- **Set comfortable line-height.** Longer lines and denser text need more leading; cramped leading
  hurts readability as much as a too-small size.
- **Make it scannable.** Break content into short, labeled chunks rather than walls of text, so the
  eye can skim structure before reading.
- **Constrain the measure (line length).** Treat it as a first-class choice alongside typeface and
  size, and re-tune measure and line-height *together* whenever the face or size changes — they are
  interdependent, not separate knobs.
- **Make type conditional, not fixed.** Specify size, measure, and spacing as ranges that adapt to
  viewport and context, and match fallback-font metrics so a substitute font doesn't shift the
  layout.
- **Use the right numerals and real glyphs.** Old-style figures in running prose, lining figures in
  headings and caps, tabular figures in data columns; prefer true small-caps and super/subscripts
  over faux-scaled ones.
- **Design tables as text to be read.** Maximize data-to-ink (drop frames and zebra striping), size
  columns to their content, left-align text and right/decimal-align numbers, and group with white
  space rather than borders.

## Review — what to look for

*Weight these against the stated intent (see [`../SKILL.md`](../SKILL.md) → Tradeoffs & intent): floor breaches (accessibility, contrast, color-only meaning, focus, safety) are defects regardless of goal; tunable choices are judged as fit or misfit to the intent.*

- Is type drawn from a finite, tokenized scale, or ad-hoc sizes/weights?
- Is there impactful contrast between adjacent sizes — any near-duplicate steps?
- Is body text at or above a legible minimum, and does it scale with user preference (no locked px)?
- Is running text neutral/high-contrast, with accent color reserved for emphasis?
- Is the typeface legible at its smallest used size (x-height, open counters)?
- Are line-height and measure comfortable (~45–75 characters), and re-tuned together?
- Is content chunked and scannable, or walls of text?
- Are numerals and glyphs correct for context (old-style / lining / tabular; true small-caps)?
- Are data tables readable (high data-to-ink, content-sized columns, text vs number alignment)?

## Values

See [platform-values.md → Type scale](platform-values.md#type-scale).
