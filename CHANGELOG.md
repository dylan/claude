# Changelog

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
