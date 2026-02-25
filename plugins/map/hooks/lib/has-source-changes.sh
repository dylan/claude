#!/usr/bin/env bash
# Shared utility: detect source file changes
# Source this file, then call has_source_changes or has_source_changes_since
# Returns 0 if source files changed, 1 if not

# Filter a newline-delimited list of file paths, returning 0 if any are source files
_has_source_file() {
  local file_list="$1"
  [ -z "$file_list" ] && return 1

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
  done <<< "$file_list"

  return 1
}

# Detect uncommitted source file changes (staged + unstaged)
has_source_changes() {
  local changed_files
  changed_files=$(git diff --name-only 2>/dev/null; git diff --name-only --cached 2>/dev/null)
  _has_source_file "$changed_files"
}

# Detect source file changes since a base commit (committed + uncommitted)
# Usage: has_source_changes_since [BASE_COMMIT]
has_source_changes_since() {
  local base="$1"
  local changed_files

  if [ -n "$base" ]; then
    # Committed changes since baseline + uncommitted changes, deduplicated
    changed_files=$( (git diff --name-only "$base" HEAD 2>/dev/null; git diff --name-only 2>/dev/null; git diff --name-only --cached 2>/dev/null) | sort -u )
  else
    # No baseline — fall back to uncommitted only
    changed_files=$(git diff --name-only 2>/dev/null; git diff --name-only --cached 2>/dev/null)
  fi

  _has_source_file "$changed_files"
}
