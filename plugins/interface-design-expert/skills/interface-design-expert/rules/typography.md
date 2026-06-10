# Typography — interface-design-expert lens
**Impact: CRITICAL**

Drive type from a **system, not ad-hoc choices**. Resolve numbers via the value-resolution rule in
[`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles

- **Use a tokenized type scale.** *(grouping, fluency)* Define a finite set of roles (display →
  body → label/caption), each a token bundling size + weight + line-height + tracking, stepped by a
  ratio resolved via [platform-values.md](platform-values.md). Select only the roles the content
  needs; keep adjacent steps visibly distinct — near-duplicates read as noise, not hierarchy.
- **Minimize typefaces; give brand type the display roles.** *(fluency)* Pair a required brand face
  (headlines, display) with a workhorse text face (often the platform's own) for body and captions.
  A brand font must still clear the legibility bar at every size used and honor user text scaling —
  brand never excuses either.
- **Enforce legible minimums — a floor.** *(fluency)* Set a minimum size appropriate to viewing
  distance and device; never ship body text below it.
- **Respect user text-size preferences — a floor.** *(agency-trust)* Use scalable units (sp, rem)
  so type reflows when users enlarge it; never lock pixel sizes.
- **Color type for legibility.** *(attention, fluency)* Running text neutral and high-contrast;
  accent reserved for emphasis and primary actions — an attention **budget**, judged in aggregate.
- **Choose for legibility at size.** *(fluency)* Prefer generous x-height and open counters for
  body and UI text — they hold up at small sizes and lower contrast.
- **Treat weight as a legibility variable.** *(fluency)* Avoid hairline/thin weights for interface
  text — thin strokes vanish at small sizes and low contrast. Weight and contrast trade off: if a
  light face is required (e.g. brand display), compensate with larger size or more contrast.
- **Constrain the measure; set line-height with it.** *(fluency)* Line length is a first-class
  choice alongside face and size; longer lines and denser text need more leading. Re-tune measure
  and line-height *together* whenever face or size changes — interdependent, not separate knobs.
- **Make it scannable.** *(memory, grouping)* Short, labeled chunks rather than walls of text.
- **Make type conditional, not fixed.** *(convention)* Size, measure, and spacing are ranges
  adapting to viewport and context; match fallback-font metrics so substitutes don't shift layout.
- **Align by reading direction, not left/right.** *(convention)* Specify alignment logically
  (start/end) so text tracks the interface's reading direction in RTL locales. Short labels follow
  the surrounding context's direction; longer paragraphs align to their *own* language's — a
  paragraph end-aligned against its script makes the start of each line hard to find.
- **Use the right numerals and real glyphs.** *(convention)* Old-style figures in running prose,
  lining in headings/caps, tabular in data columns; true small-caps and super/subscripts, not faux.
- **Design tables as text to be read.** *(convention)* Maximize data-to-ink: drop frames and zebra
  striping, size columns to content, left-align text and right/decimal-align numbers, group with
  white space rather than borders.

## Checks beyond the principles

*Weight per [SKILL.md → operating loop](../SKILL.md): floors and budget overdrafts are defects regardless of intent; dials are fit-to-thesis; an elective move's absence is never a finding.*

- Render key screens at the largest text-scale setting and verify the hierarchy survives — the
  relative weight/size/color distinctions between roles must still read, not just at the default.
- Load with the primary font blocked and verify fallback-font metrics don't shift the layout.

## Values

See [platform-values.md → Type scale](platform-values.md#type-scale).
