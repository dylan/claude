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

# Load shared utility
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/has-source-changes.sh
source "${SCRIPT_DIR}/lib/has-source-changes.sh"

# Read session baseline if available
STATE_DIR="${CLAUDE_PLUGIN_ROOT}/session-state"
PROJECT_HASH=$(printf '%s' "$(pwd)" | shasum -a 256 | cut -d' ' -f1)
STATE_FILE="${STATE_DIR}/${PROJECT_HASH}.baseline"
BASELINE=""
if [ -f "$STATE_FILE" ]; then
  BASELINE=$(cat "$STATE_FILE")
fi

# Check for source changes (committed since baseline + uncommitted)
if ! has_source_changes_since "$BASELINE"; then
  # Clean up state file — no source changes to enforce
  rm -f "$STATE_FILE"
  exit 0
fi

# Check if arch doc itself was modified (committed since baseline + uncommitted)
ARCH_DOC_CHANGED=false
if [ -n "$BASELINE" ]; then
  git diff --name-only "$BASELINE" HEAD 2>/dev/null | grep -qx "$ARCH_DOC" && ARCH_DOC_CHANGED=true
fi
if [ "$ARCH_DOC_CHANGED" = "false" ]; then
  git diff --name-only 2>/dev/null | grep -qx "$ARCH_DOC" && ARCH_DOC_CHANGED=true
fi
if [ "$ARCH_DOC_CHANGED" = "false" ]; then
  git diff --name-only --cached 2>/dev/null | grep -qx "$ARCH_DOC" && ARCH_DOC_CHANGED=true
fi

# Clean up state file
rm -f "$STATE_FILE"

# If source files changed but arch doc didn't, remind
if [ "$ARCH_DOC_CHANGED" = "false" ]; then
  echo "**Reminder:** Source files were modified but \`docs/codebase-architecture.md\` was not updated. Please review and update the architecture doc if needed." >&2
  exit 2
fi

exit 0
