# Changelog

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
