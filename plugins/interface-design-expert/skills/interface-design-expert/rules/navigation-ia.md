# Navigation & Information Architecture — interface-design-expert lens
**Impact: HIGH**

Structure determines whether people can find anything. Information architecture is four interlocking
systems — **organization, labeling, navigation, and search** (with metadata underneath). It is
*structural*, so it stays consistent across platforms even though each platform presents it with its
own affordances (tabs, drawers, gestures). Resolve numbers via the value-resolution rule in
[`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles — structure

- **Model the structure on the user's mental model, not your org chart or database.** Identify the
  real objects users think in (an order, a recipe, a chef), give each consistent content and
  metadata, and let the relationships between objects generate contextual links.
- **Choose breadth vs depth deliberately.** Flat structures expose more at once but can overwhelm;
  deep ones bury things behind clicks. There is no magic number — set category counts by content
  scope and findability ("7±2" does not apply to visible menus) and tune with tree testing and
  analytics.
- **Order items by a principle users can predict** — importance or frequency where one exists;
  reserve alphabetical for long lists (~20+) where people already know the exact label.

## Principles — navigation & wayfinding

- **Navigation does wayfinding, not just routing.** Always answer "where am I?" — show the current
  location, because people often land on interior pages from search or deep links. Missing
  location cues is the single most common navigation mistake.
- **Expose primary categories at the top level.** Don't bury the catalog under one generic
  "Products" item — hiding the main nav roughly halves discoverability and markedly slows desktop
  tasks. A mega menu that reveals first-level categories at a glance is fine.
- **Hidden navigation is a small-screen compromise, not a default.** A hamburger/drawer strips the
  context cues visible nav provides and lowers engagement and accessibility; prefer visible nav
  (e.g. a tab/bottom bar) wherever space allows.
- **Cap interactive menu and disclosure depth at two tiers.** Cascading dropdowns get error-prone
  past two levels; use mega menus or landing/routing pages for deeper hierarchies.
- **Keep local (section) nav subordinate to global nav** and visible — it acts as a "you are here"
  aid and surfaces related pages at no interaction cost.
- **Breadcrumbs supplement, never replace, primary nav,** and reflect the content hierarchy
  (location), not the user's click history.
- **Plan inward and forward paths for every key page** — how people arrive (search, deep links,
  contextual links) and where they go next. No primary destination should be a dead end.

## Principles — labels & findability

- **Keep the link label, the page heading, and the title in agreement** — a mismatch between the
  words that lead to a page and the words on it is a findability bug. Use plain task language, not
  brand names or jargon; keep labels short and scannable (strip leading verbs; avoid many siblings
  starting with the same word).
- **Design findability and discoverability separately.** Findability (locating known content) is
  tested with tree testing / card sorting; discoverability (encountering the unknown) with
  click/usability testing — different patterns, different research.
- **Navigation and search are complementary, not substitutes.** Navigation teaches the structure
  and replaces recall with recognition; provide both rather than leaning on search alone.

## Principles — managing complexity

- **Use progressive disclosure:** show the few most important options first and reveal advanced
  ones on request; it improves learnability, efficiency, and error rate. Keep it to two levels —
  beyond that people get lost moving between them.

## Review — what to look for

*Weight these against the stated intent (see [`../SKILL.md`](../SKILL.md) → Tradeoffs & intent): floor breaches (accessibility, contrast, color-only meaning, focus, safety) are defects regardless of goal; dials are judged fit-or-misfit to the intent; opportunities (optional techniques) are judged "would this help here?" — their absence is not a finding.*

- Does the structure mirror the user's mental model / objects, or the org chart / database?
- Is breadth-vs-depth deliberate; are category counts set by scope and findability (not a magic number)?
- Is ordering predictable (importance / frequency / alphabetical only where apt)?
- Are there "you are here" cues; is the current location shown (interior pages are common entry points)?
- Are primary categories exposed at the top level, not buried under a generic item?
- Is hidden nav used only where space forces it, with visible nav where it fits?
- Are menus and disclosure capped at two tiers?
- Is local nav subordinate and visible; are breadcrumbs location-based (not history)?
- Are inward and forward paths planned, with no dead-end destinations?
- Do the link label, page heading, and title agree, in plain language?
- Are findability and discoverability both addressed; are nav *and* search present?
- Is progressive disclosure used for complexity (two levels)?

## Values

See [platform-values.md → Navigation & IA](platform-values.md#navigation--information-architecture).
