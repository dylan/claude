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
