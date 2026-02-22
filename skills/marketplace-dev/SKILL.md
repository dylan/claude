---
name: marketplace-dev
description: Use when working in this plugin marketplace repository — adding plugins, updating skills or hooks, editing marketplace config, syncing versions, or making any code changes.
---

# Marketplace Development

## Architecture Reference

Consult `docs/codebase-architecture.md` before grepping. It has file inventory, common task recipes (add plugin, update plugin, bump versions, test locally), and `file:line` refs.

## Hard Rules

1. **Version sync** — Plugin versions live in two files that must match: `plugins/<name>/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`. The plugin manifest wins silently if they differ.
2. **Relative paths** — Plugin sources in `marketplace.json` must start with `./`.
3. **Marketplace name** — `dylan`. Users install plugins as `<plugin-name>@dylan`.
4. **Line endings** — LF everywhere. Enforced by `.gitattributes`.
5. **CHANGELOG** — Every version bump gets a `CHANGELOG.md` entry.

## Plugin Conventions

**Directory structure:** `plugins/<plugin-name>/` with `.claude-plugin/plugin.json` inside.

**plugin.json required fields:** `name`, `description`, `version`, `author` (object with `name`), `keywords` (array).

**marketplace.json entry required fields:** `name`, `source` (relative path), `description`, `version`, `author`, `keywords`.

**Skills** go in `plugins/<name>/skills/<skill-name>/SKILL.md`. **Hooks** go in `plugins/<name>/hooks/hooks.json`.

## Public Repo Safety

This repository is public. Never commit:

- API keys, tokens, or credentials
- `.env` files or environment configurations
- Personal information or private data
- Internal URLs or private endpoints

## Validation

Always run before committing:

```sh
claude plugin validate .
```

After changes, update `docs/codebase-architecture.md` if you added, renamed, or removed source files.
