# Capability Proposal: frontend_ui_engineer

Date: 2026-05-25
Kind: `agent`
Status: `optional`

## Purpose

Specialist for frontend web interfaces, HTML artifacts, responsive UI implementation, browser validation, and user-facing interaction quality.

## Existing Capability Check

- No material overlap detected by token similarity.

## Automation Decision

- `proposal`: safe to review without runtime effects.
- `apply`: allowed only when overlap is resolved and human gates are satisfied.

## Required Follow-Up

- Validate with `python scripts/scaffold-capability.py --help` for command syntax.
- Run `python scripts/evolve-workspace.py --write-catalog --strict` after applying.
- Run `python scripts/validate-skills.py --strict` and `bash scripts/healthcheck.sh --strict`.
