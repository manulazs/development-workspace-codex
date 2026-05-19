# Workspace Health

Last reviewed: 2026-05-19

## Current State

- Repository path: `C:\Users\c36647b\OneDrive - CNH Industrial\Documentos\github\development-workspace-codex`
- Branch: `main`
- Remote: `origin`
- Repository capabilities: 31 skills, 9 custom agents.
- Runtime skills observed before implementation: `.system`, `powerbi-dax-html`.
- Runtime agents observed before implementation: no `~/.codex/agents` directory.

## Operational Gap

The repository is the source of truth for reproducible workspace configuration. The active Codex profile under `~/.codex` is the runtime install. They can drift.

Use `scripts/healthcheck.ps1` to detect drift and `scripts/install-workspace.ps1 -WhatIf` to preview synchronization.

## Health Signals

Green:

- Git worktree exists.
- Required directories exist.
- Skill frontmatter is present.
- Custom agents validate structurally.
- Capability inventory mentions all tracked skills and agents.
- No obvious tracked secret pattern is detected.

Yellow:

- Repo skills or agents are not installed in `~/.codex`.
- `quick_validate.py` cannot run because Python dependencies are missing.
- README contains a manual capability list that differs from the repo.
- Files over 5 MB are tracked without explicit justification.

Red:

- Agent TOML required fields are missing.
- Skill frontmatter is missing required fields.
- Potential secret patterns appear in tracked files.
- `migrate-to-codex --validate-target .` fails.
- Required governance directories are missing.

## Maintenance Cadence

- Run healthcheck before and after workspace changes.
- Review `docs/capability-inventory.md` whenever skills or agents change.
- Add a monthly audit note under `docs/audits/`.
- Promote repeated lessons into `docs/patterns/` or a local skill only after recurrence is proven.
