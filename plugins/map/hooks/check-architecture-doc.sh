#!/usr/bin/env bash
# Hook: check for docs/codebase-architecture.md and remind or suggest /map

ARCH_DOC="docs/codebase-architecture.md"
CONFIG_DIR="${CLAUDE_PLUGIN_ROOT}/config"
EXCLUDED_FILE="${CONFIG_DIR}/excluded-projects"
PROJECT_PATH="$(pwd)"

# Check if this project has been excluded by the user
if [ -f "$EXCLUDED_FILE" ]; then
  while IFS= read -r line; do
    if [ "$line" = "$PROJECT_PATH" ]; then
      exit 0
    fi
  done < "$EXCLUDED_FILE"
fi

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
  cat <<EOF
**No architecture doc found.** This project has no \`docs/codebase-architecture.md\`.

Ask the user: "Would you like me to run \`/map\` to generate a codebase architecture doc, or skip it for this project?"

- If they want to run it: invoke the \`/map\` skill
- If they want to skip: add their project path to the exclusion list by running:
  \`mkdir -p '${CONFIG_DIR}' && echo '${PROJECT_PATH}' >> '${EXCLUDED_FILE}'\`
  Then confirm: "Got it — I won't ask again for this project."
EOF
fi
