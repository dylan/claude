# Navigation & Information Architecture — interface-design-expert lens
**Impact: HIGH**

Structure determines whether people can find anything. Information architecture is four
interlocking systems — **organization, labeling, navigation, and search** (with metadata
underneath) — and it is structural, so it stays consistent across platforms even as each presents
it through its own affordances. Resolve numbers via [`../SKILL.md`](../SKILL.md) and [`platform-values.md`](platform-values.md).

## Principles — organization

- **Model the structure on the user's mental model, not your org chart or database.** *(models)*
  Identify the real objects users think in; their relationships generate the contextual links.
- **Choose breadth vs depth deliberately — it is a dial.** *(complexity, memory)* No magic number:
  "7±2" does not apply to visible menus; set category counts by content scope and findability.
- **Order items by a principle users can predict** *(fluency)* — importance or frequency where one
  exists; reserve alphabetical for long lists where people already know the exact label.

## Principles — navigation & wayfinding

- **Navigation does wayfinding, not just routing.** *(models, memory)* Always answer "where am
  I?" — interior pages are common entry points (search, deep links), and missing location cues is
  the single most common navigation mistake.
- **Keep primary navigation visible, with primary categories exposed at the top level.**
  *(recognition, memory)* Hiding the main nav roughly halves discoverability and markedly slows
  desktop tasks; burying the catalog under one generic "Products" item does similar damage. A
  hamburger/drawer strips context cues and lowers engagement and accessibility — a small-screen
  compromise, not a default. A mega menu that reveals first-level categories at a glance is fine.
- **Keep interactive menu and disclosure depth shallow** *(motor, memory)* — cascading dropdowns
  get error-prone with depth (cap per [`platform-values.md`](platform-values.md)); use mega menus
  or landing/routing pages for deeper hierarchies.
- **Keep local (section) nav subordinate to global nav and visible** *(models, recognition)* — a
  "you are here" aid that surfaces related pages at no interaction cost.
- **Breadcrumbs supplement, never replace, primary nav** *(convention)* and reflect the content
  hierarchy (location), not the user's click history.
- **Plan inward and forward paths for every key page** *(models, agency-trust)* — no primary
  destination is a dead end. Honor arrival intent: when an external entry point names specific
  content, go straight to it — no splash, interstitial, or detail screen first. Exits from
  immersive or focused states land somewhere oriented and relevant, with a way back in.

## Principles — labeling, findability & search

- **Keep the link label, the page heading, and the title in agreement** *(recognition)* — mismatch
  between the words that lead to a page and the words on it is a findability bug. Plain task
  language, not brand names or jargon; short scannable labels — strip leading verbs, vary sibling openings.
- **Design findability and discoverability separately** *(memory, attention)* — locating known
  content and encountering the unknown fail differently and need different research (see Checks).
- **Navigation and search are complementary, not substitutes** *(recognition, memory)* — navigation
  teaches the structure and replaces recall with recognition; provide both. Give search one
  trusted, global home, prominent in proportion to its importance; clearly scoped local search
  that filters the current view is a complement, never a replacement.
- **Findability extends beyond your own interface** *(recognition)* — supply rich previews and
  metadata for custom content and file types so external surfaces (system search, link unfurls,
  embeds) can show recognizable representations.

## Principles — complexity, entry & where options live

- **Use progressive disclosure** *(complexity, signifiers)* — the few most important options first,
  advanced ones on request, kept shallow (cap per platform-values). Whatever is hidden must
  advertise its own existence — a disclosure control, an item peeking at an edge — or it is lost.
- **Don't gate entry — deliver value before commitment.** *(agency-trust)* Let people experience
  the real product before sign-in, configuration, or instruction; require authentication only at
  the moment of need — forced sign-in before any value is a leading cause of abandonment. Launch
  ends when the first screen is usable; orientation and brand moments never block readiness.
  Onboarding: skippable, never recurring uninvited, reachable later; defaults make setup optional.
- **Place every option at the altitude of its use.** *(memory, complexity)* Task-specific options
  (show/hide, reorder, filter) live in the context they affect — settings burial disconnects them
  from their effect. Reserve settings for general, rarely changed options (split from per-use
  choices); push only the rarest to the system/OS level, deep-linked from your interface. Option
  count is a **budget** judged on the aggregate: every added setting makes the others harder to find.
- **Keep the settings area itself a stable map** *(memory)* — not customizable, active section
  always indicated; people find settings by spatial memory and a clear "you are here".

## Checks beyond the principles

*Weight per [SKILL.md → operating loop](../SKILL.md): floors and budget overdrafts are defects regardless of intent; dials are fit-to-thesis; an elective move's absence is never a finding.*

- Tree-test/card-sort findability of known items; click/usability-test discoverability — they fail differently.
- Check link label ↔ page heading ↔ page title agreement across primary destinations.
- Walk one deep-link entry (search result, shared link); verify "where am I" cues and a forward path.

## Values

See [platform-values.md → Navigation & IA](platform-values.md#navigation--information-architecture).
