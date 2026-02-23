#!/usr/bin/env bash
# Hook: check for docs/codebase-architecture.md and remind or suggest /map
# Handles both UserPromptSubmit (plain text) and SubagentStart (JSON additionalContext)

# Read stdin JSON
INPUT=$(cat)
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // empty')

# For UserPromptSubmit: filter to action-oriented prompts only
# (UserPromptSubmit doesn't support matchers, so we filter here)
if [ "$HOOK_EVENT" = "UserPromptSubmit" ]; then
  ACTION_PATTERN='add|fix|implement|refactor|create|build|update|change|modify|remove|delete|rename|move|extract|replace|rewrite|migrate|convert|introduce|wire|connect|integrate|feat|bug|chore|write'
  PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')
  if [ -n "$PROMPT" ] && ! echo "$PROMPT" | grep -qiE "(^|[^a-z])($ACTION_PATTERN)([^a-z]|$)"; then
    exit 0
  fi
fi

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

# Build the reminder message
if [ -f "$ARCH_DOC" ]; then
  MESSAGE="**Architecture doc check required.**

Before making changes, consult \`docs/codebase-architecture.md\`:
- Review the **File Inventory** to understand where this change fits
- Check the **Common Task Guide** for existing recipes
- Check the **Event/API Surface** if adding or modifying events

**After making changes**, update the architecture doc if you:
- Added, renamed, or removed any source files
- Changed event names, state shape, or data flow
- Added new endpoints or handler events
- Modified module relationships or dependencies
- Learned anything new about this project that warrants documentation.

Update \`file:line\` references when edits shift them."
else
  MESSAGE="**No architecture doc found.** This project has no \`docs/codebase-architecture.md\`.

Ask the user: \"Would you like me to run \`/map\` to generate a codebase architecture doc, or skip it for this project?\"

- If they want to run it: invoke the \`/map\` skill
- If they want to skip: add their project path to the exclusion list by running:
  \`mkdir -p '${CONFIG_DIR}' && echo '${PROJECT_PATH}' >> '${EXCLUDED_FILE}'\`
  Then confirm: \"Got it — I won't ask again for this project.\""
fi

# SubagentStart requires JSON output with additionalContext
if [ "$HOOK_EVENT" = "SubagentStart" ]; then
  jq -n --arg ctx "$MESSAGE" '{
    hookSpecificOutput: {
      hookEventName: "SubagentStart",
      additionalContext: $ctx
    }
  }'
else
  # UserPromptSubmit: plain text stdout is added as context
  echo "$MESSAGE"
fi
