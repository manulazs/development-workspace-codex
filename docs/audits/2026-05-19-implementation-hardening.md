# Implementation Hardening Audit - 2026-05-19

Status: current and open.

## Scope

This audit records the hardening pass that followed the public-template technical audit. It focuses on provenance, validation, agentic controls, public adoption clarity, and runtime separation.

## Changes Captured

- Added `docs/skills-provenance.md` as the canonical skill provenance and publication-gate matrix.
- Added `docs/agentic-controls.md` to distinguish recommending, spawning, creating, persisting, and retiring skills or subagents.
- Added repository-local skill validation through `scripts/validate-skills.py`.
- Strengthened CI and healthchecks to include strict repository validation, skill metadata validation, and `full-reviewed` install previews.
- Updated public-facing docs to explain that self-improvement is governed process, not autonomous mutation.

## Validation Requirements

- `python scripts/validate-skills.py --strict`
- `bash scripts/healthcheck.sh --strict`
- `python skills/migrate-to-codex/scripts/cli.py --validate-target .`
- `bash scripts/install-workspace.sh --profile full-reviewed --dry-run`
- `git diff --check`

## Open Follow-Ups

- Resolve every `needs-source-review` entry in `docs/skills-provenance.md` before claiming full public redistribution readiness.
- Capture fresh Windows evidence from CI or a Windows host with PowerShell available.
- Decide whether `migrate-to-codex` remains `core` after documenting its target-write behavior.
- Review `review` and `curated` capabilities on the published cadence and prune stale items rather than only adding more capabilities.
