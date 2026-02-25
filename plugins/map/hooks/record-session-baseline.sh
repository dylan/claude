#!/usr/bin/env bash
# Hook: SessionStart(startup) — record HEAD so the Stop hook can detect committed changes

# Only act inside a git repo
git rev-parse --git-dir &>/dev/null || exit 0

STATE_DIR="${CLAUDE_PLUGIN_ROOT}/session-state"
mkdir -p "$STATE_DIR"

# Project-scoped state file (hash of working directory)
PROJECT_HASH=$(printf '%s' "$(pwd)" | shasum -a 256 | cut -d' ' -f1)
STATE_FILE="${STATE_DIR}/${PROJECT_HASH}.baseline"

git rev-parse HEAD > "$STATE_FILE" 2>/dev/null
