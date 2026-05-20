# 0011 - Add Continuous Evolution Automation

Status: accepted.

## Decision

Add a governed continuous-evolution capability made of a reusable skill, a deterministic task-catalog script, documentation, and validation hooks.

## Reason

The workspace already documented self-improvement, but task cataloging, segmentation, anti-duplication review, and subagent routing were mostly manual. A reusable workspace needs a repeatable mechanism that can identify evolution work without depending on private runtime state.

## Changes

- Added `skills/continuous-evolution` as the orchestrator workflow.
- Added `scripts/evolve-workspace.py` to generate repository-visible task catalogs and detect structural evolution gaps.
- Added `docs/continuous-evolution.md` and `docs/evolution/`.
- Added validation hooks so CI and healthchecks can detect unsafe structural drift.

## Consequences

- Repository-local skill and agent evolution can be automated when the scope is narrow and validation passes.
- Core, security-sensitive, runtime-global, destructive, or public-distribution changes remain human-gated.
- Subagent use becomes structured through explicit briefs, evidence, validation, and main-agent integration.
