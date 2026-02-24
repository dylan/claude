#!/usr/bin/env bash
# Shared utility: detect uncommitted source file changes
# Source this file, then call has_source_changes
# Returns 0 if source files changed, 1 if not

has_source_changes() {
  local changed_files
  changed_files=$(git diff --name-only 2>/dev/null; git diff --name-only --cached 2>/dev/null)

  [ -z "$changed_files" ] && return 1

  while IFS= read -r file; do
    [ -z "$file" ] && continue
    case "$file" in
      docs/*) continue ;;
      *.md) continue ;;
      .claude/*) continue ;;
      .gitignore) continue ;;
      .gitattributes) continue ;;
    esac
    return 0
  done <<< "$changed_files"

  return 1
}
