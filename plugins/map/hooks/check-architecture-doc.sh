#!/usr/bin/env bash
# Hook: check for docs/codebase-architecture.md and remind or suggest /map

ARCH_DOC="docs/codebase-architecture.md"

if [ -f "$ARCH_DOC" ]; then
  cat <<'EOF'
**Architecture doc check required.**

Before making changes, consult `docs/codebase-architecture.md`:
- Review the **File Inventory** to understand where this change fits
- Check the **Common Task Guide** for existing recipes
- Check the **Event/API Surface** if adding or modifying events

**After making changes**, update the architecture doc if you:
- Added, renamed, or removed any source files
- Changed event names, state shape, or data flow
- Added new endpoints or handler events
- Modified module relationships or dependencies
- Learned anything new about this project that warrants documentation.

Update `file:line` references when edits shift them.
EOF
else
  cat <<'EOF'
**No architecture doc found.**

This project has no `docs/codebase-architecture.md`. Run `/map` to generate one.

An architecture doc gives you:
- File inventory with one-line roles
- Data flow and state shape documentation
- Event/API surface mapping
- Common task recipes with `file:line` references

Without it, you're navigating blind. Run `/map` first.
EOF
fi
