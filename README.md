# claude

A Claude Code plugin marketplace by Dylan.

## Add this marketplace

```sh
/plugin marketplace add dylan/claude
```

## map

Generates codebase architecture docs and enforces architecture-doc-first development.

```sh
/plugin install map@dylan
```

**`/map` skill** — Explores your codebase and generates two files:

- `docs/codebase-architecture.md` — File inventory, data flow, state shape, event/API surface, and common task recipes, all with `file:line` references to actual source
- `.claude/CLAUDE.md` — Scaffold with project context and empty wisdom sections that fill in as you work

**Prompt hook** — On any code-change prompt (add, fix, refactor, etc.), reminds Claude to consult and update the architecture doc. If no doc exists, suggests running `/map` first.

### What `/map` does

1. Detects existing docs (offers audit if found, bootstraps if missing)
2. Auto-detects your stack from config files
3. Explores codebase via subagents
4. Asks 3-5 targeted questions about things code can't answer
5. Generates architecture doc and CLAUDE.md scaffold
6. Presents for your review

### Architecture doc sections

| Section | When included |
|---------|--------------|
| Header | Always — one-sentence description + key tech |
| Commands | Always — build, test, lint, format |
| File Inventory | Always — tables grouped by domain concern |
| Data Flow | Layered processing (web apps, pipelines, event systems) |
| State Shape | Non-trivial state (game servers, real-time, complex frontend) |
| Event/API Surface | External-to-internal mapping (endpoints, events, CLI) |
| Module Relationships | Composition roots, dependency graphs |
| Common Task Guide | Repeatable extension patterns with step-by-step recipes |

### Design principles

- **Reference source, don't duplicate it** — `file:line` pointers over inline code
- **Tables over prose** — scannable, dense
- **Project vocabulary** — uses your project's own names
- **ASCII diagrams** — no Mermaid, no images
- **Conditional sections** — includes what's relevant, skips what isn't

## gpu-expert

GPU & Metal expert consultant — researches topics, reviews shader code, and maintains a NotebookLM knowledge base.

```sh
/plugin install gpu-expert@dylan
```

Combines Apple documentation (via [sosumi MCP](https://github.com/nichochar/sosumi)), a persistent [NotebookLM](https://notebooklm.google.com/) knowledge base, and codebase analysis to answer GPU/Metal questions, review Metal code, and research GPU topics — all through the lens of Apple Silicon.

**Requirements:** sosumi MCP server, `notebooklm` CLI (authenticated), and the [notebooklm-skill](https://github.com/PleasePrompto/notebooklm-skill) Claude Code skill. The skill degrades gracefully if sosumi or NotebookLM is unavailable.

## swift-api-design

Swift API Design Guidelines enforcer — active whenever you're writing, reviewing, or designing Swift code.

```sh
/plugin install swift-api-design@dylan
```

Enforces the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) at every scope level — public APIs, internal helpers, local functions, closures, tuple members. Calls out violations with the specific guideline broken and a concrete rewrite. No hedging.

**What it covers:**
- Naming: clarity at the call site, role vs. type names, fluency, Boolean readability
- Argument labels: prepositional phrases, grammatical phrases, value-preserving conversions
- Conventions: casing, factory methods, mutating/nonmutating pairs, protocol naming
- Documentation: presence and quality of doc comments
- Overloads: ambiguous overload sets with `Any` or unconstrained generics

**What it doesn't cover:** Protocol-oriented design choices, generics architecture, performance, memory management. Guidelines scope only.

## interface-design-expert

General-purpose interface design & review expert — designs or critiques any UI, on any platform, across nine design dimensions at once.

```sh
/plugin install interface-design-expert@dylan
```

A multi-lens instrument for **designing** and **reviewing** interfaces — web, native desktop (macOS, Windows, Linux), mobile, games, terminal/TUI, voice, and beyond. Give it a screenshot, a described concept, or live UI code and it surveys across nine independent lenses, each a self-contained file loaded on demand, all resting on shared cognitive & perceptual foundations. Built to hand off to review agents — one lens per agent, in parallel.

**The nine dimensions:** layout & visual hierarchy · typography · color & theming · accessibility · interaction, states & motion · content & voice · navigation & information architecture · consistency · aesthetics & visual composition.

**How it thinks:**
- **Principles are universal, values are resolved** — never invents a number; resolves it by user override → platform default → most-inclusive fallback.
- **Floors vs. dials** — weights the lenses by the design's stated intent; holds accessibility/safety/performance *floors* while judging tunable *dials* as fit-or-misfit to the goal (so a deliberately dense expert tool isn't dinged for being spartan).
- **Two modes** — multi-dimensional review (findings with severity + tensions) and intent-first design (spec + rationale).
- **First-principles foundations** — derives novel solutions from human invariants (working memory, Fitts/Hick, Gestalt, the aesthetic-usability effect) rather than copying conventions.

When the work targets exactly one Apple or web platform, defer to that platform's specific skill instead.

## nato-name

Placeholder project namer — picks an unused NATO reporting name so you can start building before you've named the thing.

```sh
/plugin install nato-name@dylan
```

**`/nato-name` skill** — Lists every NATO reporting name (Flanker, Akula, Atoll, Kitchen, ...) not already used in the current directory and offers the first one. The list is alphabetical, so A-names go first and the letter advances as you use them up. Ask for a letter to filter.

## c64

Commodore 64 demoscene optimizer and hardware reference, for any C64 project and toolchain: hand-written assembly (ca65, ACME, KickAssembler, 64tass, DASM), C through cc65 or llvm-mos, or Zig through zig-mos.

```sh
/plugin install c64@dylan
```

**`c64` agent** — Plans and reviews 6502/6510 code the way a demo group reviews a routine before the party deadline. Before you write a hot routine, a raster or interrupt scheme, a memory map or an effect, it chooses the approach within a cycle and byte budget. After a change, it reviews the code for cycle counts, raster timing, memory layout and real-hardware resilience, and returns findings with concrete rewrites. It learns each project's toolchain and memory map from the project's own briefing, and it is read-only.

**`c64-hardware` skill** — Exact numbers instead of recalled ones, preloaded by the agent and available to any session:

| Reference | Covers |
|-----------|--------|
| `6510.md` | All 256 opcodes with cycle counts, grouped by stability; NMOS quirks |
| `vic-ii.md` | Registers, banks, display modes, raster-line cycle timing, badlines, sprites, border tricks |
| `cia.md`, `sid.md` | Timers, interrupts, keyboard and joysticks; SID registers, pitch and chip differences |
| `memory-map.md` | Banking, vectors, KERNAL interrupt costs, zero-page use, decruncher footprints |
| `interrupts.md` | Raster interrupt setup, acknowledging, missed lines, NMI ownership, stable-raster methods |
| `patterns.md` | Raster chains written as one routine, protothreads, long work inside interrupts |
| `algorithms.md` | Measured crunchers, loaders, multiply, random numbers, multiplexer sorts, and open opportunities |
| `llvm-mos.md` | llvm-mos and zig-mos: zero page, static stack, calling convention, interrupts, start-up, what compiles badly |
| `modern-practice.md` | Host-side cycle tests, headless VICE, a VICE test harness, Ultimate 64 REST API, build-time assertions |

