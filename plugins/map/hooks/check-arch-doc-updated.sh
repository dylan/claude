#!/usr/bin/env bash
# Hook: Stop — check if source files changed but architecture doc wasn't updated

# Read stdin JSON
INPUT=$(cat)

# Prevent infinite loops (per Claude Code hooks docs)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

ARCH_DOC="docs/codebase-architecture.md"

# Nothing to enforce if no arch doc exists
if [ ! -f "$ARCH_DOC" ]; then
  exit 0
fi

# Check for source changes using shared utility
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/has-source-changes.sh
source "${SCRIPT_DIR}/lib/has-source-changes.sh"

if ! has_source_changes; then
  exit 0
fi

# Check if arch doc itself was modified
CHANGED_FILES=$(git diff --name-only 2>/dev/null; git diff --name-only --cached 2>/dev/null)
ARCH_DOC_CHANGED=false
echo "$CHANGED_FILES" | grep -qx "$ARCH_DOC" && ARCH_DOC_CHANGED=true

# If source files changed but arch doc didn't, remind
if [ "$ARCH_DOC_CHANGED" = "false" ]; then
  echo "**Reminder:** Source files were modified but \`docs/codebase-architecture.md\` was not updated. Please review and update the architecture doc if needed." >&2
  exit 2
fi

exit 0
