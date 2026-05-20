# 0010 - Adopt Caveman Lite Global Style

Status: accepted.

## Decision

Use `caveman lite` as the default communication style in the global Codex instruction template, while keeping the `caveman` skill optional rather than core.

## Reason

Manuel wants the active global runtime to default to concise, direct responses without losing technical precision. The repository should record this preference as an explicit, portable template choice instead of relying on an untracked local runtime change.

The style remains optional for third-party adopters because it is opinionated and may conflict with a team's desired tone. The upstream provenance also still needs source/license review before claiming broad public redistribution readiness.

## Changes

- Added a `Communication Style` section to `codex-global/AGENTS.md`.
- Reclassified `caveman` from `review` to `optional` in `workspace-manifest.json`.
- Added `caveman` to the `full-reviewed` profile so explicit full adoption includes the communication-style skill.
- Updated capability inventory, provenance, README, and changelog to explain the adoption boundary.

## Consequences

- Manuel's local global runtime can use `caveman lite` consistently.
- Third-party consumers can remove or adapt the communication-style section before copying the template into their own runtime.
- `caveman` is installable through reviewed profiles, but it remains marked `needs-source-review` until upstream license/provenance evidence is complete.
