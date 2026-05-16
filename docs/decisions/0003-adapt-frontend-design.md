# 0003 - Migrate Anthropic `frontend-design`

## Decision

Install a Codex-compatible version of Anthropic's `frontend-design` skill generated through OpenAI's official `migrate-to-codex` workflow instead of installing the original unchanged.

## Reason

The source skill has a valid `SKILL.md`, but it comes from another agent ecosystem and includes Claude-specific wording. The local policy requires external skills from other agent ecosystems to be checked and migrated when needed.

The migrated version preserves the purpose of the original skill while resolving the `license` manual-review item, replacing the direct Claude reference with Codex-compatible wording, preserving the Apache-2.0 license, and adding OpenAI-style `agents/openai.yaml` metadata.

## Migration

- Migrator: `migrate-to-codex`
- Source shape: `.claude/skills/frontend-design`
- Source commit: `anthropics/skills@f458cee`
- Migration checks run: `--scan-only`, `--plan`, `--doctor`, `--dry-run`, real migration, and `--validate-target`

## Source

- Original: https://github.com/anthropics/skills/tree/main/skills/frontend-design
- License: Apache-2.0, preserved in `skills/frontend-design/LICENSE.txt`
