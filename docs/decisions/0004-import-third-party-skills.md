# 0004 - Import Third-Party Skills

Status: superseded by `workspace-manifest.json` adoption profiles and the current public-template policy. This ADR records historical import context; it no longer means third-party skills should be copied into a local runtime by default.

## Decision

Import a batch of third-party skill sources from Anthropic `skills`, Vercel Labs `agent-browser`, and JuliusBrussee `caveman` into this repository for review, attribution, and selective reuse.

## Reason

These skills add reusable workflows for spreadsheets, web app testing, web artifact generation, presentation authoring, theme generation, canvas design, browser automation, and git-oriented helpers.

Keeping the imported copies here makes the workspace reproducible and auditable. If a skill later needs Codex-specific adaptation, `migrate-to-codex` can be applied on a per-skill basis without losing the original source provenance.

## Imported Skills

- Anthropic: `xlsx`, `webapp-testing`, `web-artifacts-builder`, `pptx`, `theme-factory`, `canvas-design`
- Vercel Labs: `agent-browser`
- JuliusBrussee: `caveman`, `caveman-compress`, `caveman-commit`, `caveman-help`

## Historical Installation Note

These sources were originally installed with `skill-installer` and then mirrored into the repository. Current profile installers do not install `curated` or `review` capabilities by default.
