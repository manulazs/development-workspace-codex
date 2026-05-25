# 0017 - Adapt Task Observer Methodology For Codex

Status: accepted.

## Decision

Adapt the task-observer methodology into the existing `continuous-evolution` workflow instead of importing the external skill directly.

The public repository provides templates and validation. Real observations live in the consumer workspace under `.codex-local/evolution/` and are ignored by Git.

## Reason

The external task-observer pattern is useful because it captures corrections, gaps, recurring workflows, and cross-cutting principles as reviewable evidence. Direct import is not appropriate because the original workflow includes Claude/Cowork-specific storage, presentation, and scheduling concepts.

This repository needs a Codex-native version that preserves privacy, public-template portability, manifest/inventory governance, human gates, and repository validation.

## Changes

- Add public observation templates under `docs/evolution/templates/`.
- Add `.codex-local/`, `skill-observations/`, and `skill-updates/` to `.gitignore`.
- Add `scripts/validate-observations.py` to validate templates, status values, private-path guards, optional local logs, and cross-cutting principle evidence.
- Integrate observation validation into healthchecks and CI.
- Update `continuous-evolution` docs and skill instructions with the `observe -> log -> review -> stage -> validate -> apply/decline -> archive` protocol.

## Consequences

- The workspace can capture recurring learning without committing private session data.
- Cross-cutting principles require at least two observations or one ADR before becoming durable guidance.
- Staged updates remain review artifacts, not automatic live changes.
- Core capability changes, new skills, new agents, runtime-global writes, security posture, licensing, removals, and reclassification remain human-gated.
- Future scheduler support should be added through Codex automations only after separate review.
