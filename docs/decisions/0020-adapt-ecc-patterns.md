# 0020 Adapt ECC Patterns Without Importing The Harness

Date: 2026-05-25

Status: accepted

## Context

The Affaan Mustafa ECC repository is a large cross-harness development environment with agents, skills, commands, MCP configuration, hooks, installers, doctor/repair flows, and continuous learning concepts. This workspace is a public Codex template with profile-based adoption, explicit runtime boundaries, Caveman LITE, governed self-improvement, and validation-first portability.

The goal is to adopt useful patterns without turning this repository into an ECC fork or importing Claude-specific control surfaces.

## Decision

Adapt only these ECC-compatible patterns:

- context and token budget auditing as a read-only repository analyzer;
- doctor/readiness drift checks as read-only validation;
- verification loops as orchestration over local evidence and existing healthchecks;
- MCP governance as a review policy and catalog pattern, not installation;
- surface-audit pressure to avoid capability bloat.

Do not import ECC hooks, command shims, default MCP configs, install/merge scripts, runtime state stores, continuous-learning hook loops, or large skill/agent catalogs.

`context-budget-audit` and `verification-loop` are locally authored skills with conceptual ECC attribution. `docs_researcher` overlaps with ECC's docs researcher surface but is a local Codex subagent template. `test_automation_engineer` is a local workspace capability created for this repository's testing/validation routing needs, not an ECC import.

## Consequences

- ECC attribution stays in `docs/skills-provenance.md` for adapted skill concepts.
- Runtime-global writes, MCP installs, hooks, and repair flows remain human-gated.
- `scripts/analyze-context-budget.py` and `scripts/workspace-doctor.py` must remain read-only unless a later ADR approves safe repair semantics.
- Future ECC-derived changes must state whether they are conceptual adaptations, substantial copies, or rejected surfaces.

## Rejected

- `continuous-learning-v2` hook-based observation as an import.
- `.mcp.json`, `.codex/config.toml`, MCP merge scripts, and token bootstrap scripts.
- Full ECC skill, agent, or command catalog import.
- Automatic repair or runtime synchronization as part of repository health.
