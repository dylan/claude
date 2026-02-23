# Codebase Architecture: dylan/claude

A Claude Code plugin marketplace distributing reusable plugins, currently hosting the `map` plugin for codebase architecture doc generation. Pure config/markdown — no runtime code beyond a single bash hook script.

**Stack:** Claude Code plugin system (marketplace.json, plugin.json, SKILL.md, hooks.json), Bash
**Persistence:** None — all files are static config and documentation

## Commands

All commands run from the repo root (`/Users/dylan/Github/claude` or wherever cloned).

| Command | Purpose |
| ------- | ------- |
| `claude plugin validate .` | Validate marketplace.json and plugin manifests |
| `/plugin marketplace add ./` | Add this marketplace locally for testing |
| `/plugin install map@dylan` | Install the map plugin from this marketplace |

## File Inventory

### Marketplace Registry

| File | Role |
| ---- | ---- |
| `.claude-plugin/marketplace.json:1` | Marketplace catalog — lists all plugins with names, sources, descriptions, versions, and keywords |
| `README.md:1` | User-facing docs: how to add the marketplace and install plugins |
| `CHANGELOG.md:1` | Version history across all plugins and marketplace changes |

**Convention:** Marketplace name is `dylan`. Plugins install as `<plugin-name>@dylan`.

### Map Plugin

| File | Role |
| ---- | ---- |
| `plugins/map/.claude-plugin/plugin.json:1` | Plugin manifest — name, description, version, author, keywords |
| `plugins/map/skills/map/SKILL.md:1` | `/map` skill definition — the full prompt that drives architecture doc generation |
| `plugins/map/hooks/hooks.json:1` | Hook config — binds `UserPromptSubmit`, `SubagentStart`, `SessionStart`, and `Stop` to architecture doc hooks |
| `plugins/map/hooks/check-architecture-doc.sh:1` | Bash hook — checks for `docs/codebase-architecture.md`, reminds Claude (or subagents) to consult it or suggests `/map`. Handles UserPromptSubmit, SubagentStart, and SessionStart events with appropriate output format (plain text vs JSON `additionalContext`) |
| `plugins/map/hooks/check-arch-doc-updated.sh:1` | Bash hook (Stop) — checks if source files were modified without updating the architecture doc. Exits with code 2 and a reminder if enforcement triggers |

**Convention:** Each plugin lives in `plugins/<plugin-name>/` with its own `.claude-plugin/plugin.json`.

### Root-Level Skills

| File | Role |
| ---- | ---- |
| `skills/marketplace-dev/SKILL.md:1` | Development guide — conventions, hard rules, and safety for working in this marketplace repo |

**Convention:** Root-level skills are for the marketplace itself, not distributable plugin features.

### Project Config

| File | Role |
| ---- | ---- |
| `.gitignore:1` | Ignores `.DS_Store` and `.claude` |
| `.gitattributes:1` | Enforces LF line endings, especially for `.sh` files |
| `.claude/settings.local.json:1` | Local Claude Code permissions (allows `gh api:*`) |

## Common Task Guide

### Add a New Plugin

Follow the `map` plugin as the canonical example.

1. Create directory: `plugins/<plugin-name>/.claude-plugin/`
2. Create `plugins/<plugin-name>/.claude-plugin/plugin.json` with required fields: `name`, `description`, `version`, `author`, `keywords` — follow schema at `plugins/map/.claude-plugin/plugin.json:1`
3. Add plugin components (skills in `skills/`, hooks in `hooks/`, etc.)
4. Register in `.claude-plugin/marketplace.json:7` — add entry to the `plugins` array with `name`, `source` (relative path starting with `./`), `description`, `version`, `author`, `keywords`
5. Update `README.md` with install instructions for the new plugin
6. Update `CHANGELOG.md` with the new version entry

**Verify:** `claude plugin validate .`

### Update an Existing Plugin

1. Make changes to the plugin files under `plugins/<plugin-name>/`
2. Bump `version` in **both** `plugins/<plugin-name>/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` — these must stay in sync
3. Add entry to `CHANGELOG.md`

**Verify:** `claude plugin validate .`

**Gotcha:** Version lives in two places. If they drift, the plugin manifest (`plugin.json`) wins silently and the marketplace version is ignored. Always update both.

### Bump Versions Across the Marketplace

When releasing a new version of any plugin:

1. Update version in `plugins/<plugin-name>/.claude-plugin/plugin.json:4` (the `version` field)
2. Update the matching version in `.claude-plugin/marketplace.json` (the plugin entry's `version` field)
3. Add a new section to `CHANGELOG.md` describing changes
4. Commit with message format: `chore: sync plugin versions to X.Y.Z and update changelog`

**Canonical example:** See commit `67f06f4` which synced versions to 1.0.2.

### Test a Plugin Locally

1. Add this marketplace locally: `/plugin marketplace add ./`
2. Install the plugin: `/plugin install <plugin-name>@dylan`
3. Exercise the plugin's skills/hooks in a test project
4. Uninstall when done: `/plugin uninstall <plugin-name>@dylan`
