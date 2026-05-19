# Post-Governance Baseline Audit - 2026-05-19

Status: historical and superseded by the public-template rewrite.

## Scope

This audit captured a Windows-governed baseline before the repository had the current public, portable, profile-based structure.

## Historical Strengths

- Required governance directories existed.
- Repository healthcheck existed.
- Capability inventory existed.
- Custom agent TOML files validated structurally.
- Repository and runtime state were recognized as separate concepts.

## Superseded Gaps

- The repository now has macOS/Linux scripts and CI.
- Public repository files now exist.
- Runtime installation state is no longer a repository health gap.
- Current installation is profile-based and optional.
- Current improvement lifecycle includes promotion, rejection, retirement, audit, and inventory-update rules.

## Current Reference

Use these current sources instead of this historical baseline:

- `README.md`
- `workspace-manifest.json`
- `docs/capability-inventory.md`
- `docs/operations/workspace-health.md`
- `docs/runbooks/setup-windows.md`
- `docs/runbooks/setup-macos.md`
