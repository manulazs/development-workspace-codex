# 0004 - Import Third-Party Skills

## Decision

Install a batch of third-party skills from Anthropic `skills`, Vercel Labs `agent-browser`, and JuliusBrussee `caveman` into both `~/.codex/skills` and this repository.

## Reason

These skills add reusable workflows for spreadsheets, web app testing, web artifact generation, presentation authoring, theme generation, canvas design, browser automation, and git-oriented helpers.

Keeping the imported copies here makes the workspace reproducible and auditable. If a skill later needs Codex-specific adaptation, `migrate-to-codex` can be applied on a per-skill basis without losing the original source provenance.

## Imported Skills

- Anthropic: `xlsx`, `webapp-testing`, `web-artifacts-builder`, `pptx`, `theme-factory`, `canvas-design`
- Vercel Labs: `agent-browser`
- JuliusBrussee: `caveman`, `caveman-compress`, `caveman-commit`, `caveman-help`

## Installation

Installed with `skill-installer` using the GitHub source repositories and the `git` transport method, then mirrored into the workspace repository for version control.
