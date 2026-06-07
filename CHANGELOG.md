# Changelog

## interface-design-expert v1.0.0 — 2026-06-07

- **New plugin:** general-purpose interface design & review expert
- Nine design dimensions as self-contained, independently-loadable lens files, plus a cognitive & perceptual foundations file; the orchestrator SKILL.md stays lean and loads lenses on demand
- Works on any interface — web, native desktop (macOS/Windows/Linux), mobile, games, terminal/TUI, voice, spatial — with per-surface value guidance
- Two modes: multi-dimensional **review** (of a screenshot, concept, or live code) and intent-first **design** (spec + rationale)
- **Floors-vs-dials** tradeoff model: weight dimensions by the design's intent, hold accessibility/safety/performance floors, tune the rest
- Built to **hand off to review agents** — one lens per agent in parallel — with a paste-ready briefing template
- **Value-resolution rule:** never invent a number; resolve by user override → platform default → most-inclusive fallback
- Aesthetics & visual composition lens with evidence-vs-craft tagging and an anti-masking discipline

## swift-api-design v1.1.0 — 2026-03-19

- Added full Guidelines Reference with good/bad code examples from the official source
- Added worked example showing three findings end-to-end in the finding format
- Added two-mode behavior: proactive when writing new code, checklist-based when reviewing
- Added guidance for weighing guideline feedback against the user's primary request
- Added accepted exception recognition (sin(x), Array over List, fluency after first two args)
- Added framework API awareness — don't flag UIKit/SwiftUI/Combine patterns the user can't change
- Added enum case conventions to the checklist (was in scope but missing)
- Trimmed checklist parenthetical examples now covered by the reference section

## swift-api-design v1.0.0 — 2026-03-19

- **New plugin:** Swift API Design Guidelines enforcer
- Always-on during any Swift work — writing, reviewing, or designing at any scope level
- Full checklist covering naming, argument labels, fluency, conventions, documentation, and overloads
- Every finding cites the specific guideline broken with a concrete suggested rewrite
- Guidelines-scoped only: naming and API surface, not language features or architecture opinions

## gpu-expert v1.0.0 — 2026-03-15

- **New plugin:** GPU & Metal expert consultant
- Researches GPU/Metal topics via Apple docs (sosumi MCP) and NotebookLM knowledge base
- Reviews `.metal` shaders and Metal API usage in Swift/ObjC
- Confidence/citation system: T1 (Apple official), T2 (well-supported external), T3 (external opinion), Novel (own reasoning)
- Hybrid NotebookLM strategy: discovers existing notebooks, creates focused ones for deep dives
- Agent team patterns for parallel research and review
- Graceful degradation when sosumi or NotebookLM unavailable

## 1.1.1

- Added CLAUDE.md scaffold guidance: auto-memory usage, keeping architecture doc lean, update frequency
- Added authoring guidelines section to architecture doc catalog (lean doc, use `file:line` refs)

## 1.1.0

- Removed all hooks (PreToolUse Grep gate, UserPromptSubmit, SubagentStart, SessionStart, Stop)
- Removed all enforcement shell scripts (check-architecture-doc.sh, check-arch-doc-updated.sh, record-session-baseline.sh, lib/has-source-changes.sh)
- Plugin is now generation-only — no runtime enforcement overhead
- Architecture doc guidance now lives in auto-memory instead of hooks

## 1.0.10

- Fixed Stop hook firing 3x per turn — added `stop_hook_active` guard and proper `$ARGUMENTS` input
- Fixed PreToolUse Grep hook parse error caused by stray `}` in prompt string
- Both agent hooks now use correct `{"ok": true/false}` response format per docs

## 1.0.9

- Removed `docs/codebase-architecture.md` from version control (generated file, now gitignored)
- Added `statusMessage` to Stop agent hook for visible progress feedback

## 1.0.8

- Added PreToolUse agent hook for Grep — checks architecture doc before grepping to avoid redundant searches
- Replaced Stop shell hook (`check-arch-doc-updated.sh`) with agent-based hook for contextual architecture doc verification

## 1.0.7

- Removed `has_source_changes` gate from UserPromptSubmit — reminder now fires before changes, not only after
- Added `record-session-baseline.sh` to record HEAD on SessionStart(startup) for committed change tracking
- Stop hook now detects committed changes across the session (not just uncommitted) using baseline comparison
- Added `has_source_changes_since()` function to shared utility for baseline-aware change detection

## 1.0.6

- Added git change detection gate to UserPromptSubmit hook (no reminder in clean repos)
- Extracted shared `has-source-changes.sh` utility for consistent change detection
- Added SessionStart(startup) hook for one-time reminder at session start
- Refactored Stop hook to use shared change detection utility

## 1.0.5

- Widened SubagentStart matcher to include Explore and Plan agents
- Added SessionStart compact hook to re-inject arch doc context after compaction
- Added Stop hook to check if arch doc was updated when source files change
- New script: `check-arch-doc-updated.sh`

## 1.0.4

- Fixed UserPromptSubmit hook matcher (matchers are silently ignored for this event per docs)
- Moved action-verb regex filtering into the shell script itself
- Added SubagentStart hook so general-purpose subagents also get the architecture doc reminder
- Hook script now detects event type and outputs appropriate format (plain text vs JSON additionalContext)

## 1.0.3

- Trimmed map skill from 210 to 89 lines for lower token cost with same output quality
- Added `docs/codebase-architecture.md` for this repo

## 1.0.2

- Simplified CLAUDE.md scaffold to avoid duplicating hook reminders
- Added purpose note to architecture reference so Claude checks it before grepping
- Added `.gitattributes` for consistent LF line endings
- Added `CHANGELOG.md`
- Added `.claude` to `.gitignore`
- Improved markdown formatting in map skill

## 1.0.1

- Fixed map hook to use yes/no prompt instead of nagging on every submit
- Added per-project opt-out for architecture doc reminders

## 1.0.0

- Initial marketplace with plugin registry
- Added map plugin for generating codebase architecture docs
- Added `/map` skill with auto-detection of project tech stack
- Added prompt hook to remind Claude to consult architecture docs
