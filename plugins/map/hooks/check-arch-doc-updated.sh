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

# Get all uncommitted changed files (staged + unstaged)
CHANGED_FILES=$(git diff --name-only 2>/dev/null; git diff --name-only --cached 2>/dev/null)

# Exit if no changes
if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

# Check if arch doc itself was modified
ARCH_DOC_CHANGED=false
echo "$CHANGED_FILES" | grep -qx "$ARCH_DOC" && ARCH_DOC_CHANGED=true

# Check if any source files were modified
# Source files = anything NOT docs/*, *.md, .claude/*, .gitignore, .gitattributes
SOURCE_CHANGED=false
while IFS= read -r file; do
  [ -z "$file" ] && continue
  case "$file" in
    docs/*) continue ;;
    *.md) continue ;;
    .claude/*) continue ;;
    .gitignore) continue ;;
    .gitattributes) continue ;;
  esac
  SOURCE_CHANGED=true
  break
done <<< "$CHANGED_FILES"

# If source files changed but arch doc didn't, remind
if [ "$SOURCE_CHANGED" = "true" ] && [ "$ARCH_DOC_CHANGED" = "false" ]; then
  echo "**Reminder:** Source files were modified but \`docs/codebase-architecture.md\` was not updated. Please review and update the architecture doc if needed." >&2
  exit 2
fi

exit 0
