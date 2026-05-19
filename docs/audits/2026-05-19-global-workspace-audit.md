# Global Workspace Audit - 2026-05-19

## Summary

The workspace has a strong conceptual base but needed operational controls to become a reliable continuous development environment.

## Findings

- Repository structure is clear: `skills/`, `.codex/agents/`, `codex-global/`, and `docs/decisions/`.
- Runtime installation can drift from the repo. Before this audit, repo skills and agents were not fully reflected in `~/.codex`.
- There was no Windows-first install script, healthcheck script, operational health document, lessons directory, patterns directory, or subagent policy document.
- Custom agents validated structurally with `migrate-to-codex --validate-target .`.
- Skill validation through system `quick_validate.py` was blocked by missing `PyYAML` in the active Python environment.
- Existing subagent guidance was mostly inside manual-only planning skills, not permanent global policy.

## Actions Implemented

- Added PowerShell healthcheck and install scripts.
- Added permanent subagent policy and capability inventory.
- Added operational health, Windows setup, lessons, patterns, and audit documentation.
- Added GitHub Actions validation.
- Updated permanent instructions to include healthcheck, repo/runtime distinction, subagent control, and self-improvement rules.
- Changed `security_auditor` to read-only.

## Remaining Watch Items

- Decide whether all repo skills should be installed into `~/.codex` or kept as a curated source catalog.
- Fix the Python validator environment if full `quick_validate.py` validation is required locally.
- Review high-risk skills with external install commands before enabling them broadly.
- Run quarterly inventory pruning to avoid skill sprawl.
