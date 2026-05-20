# 0010 - Adopt Caveman Lite Global Style

Status: superseded by `0012-make-caveman-lite-mandatory.md`.

## Decision

Use `caveman lite` as the default communication style in the global Codex instruction template, while keeping the `caveman` skill optional rather than core.

This decision was superseded on 2026-05-20. `caveman lite` is now mandatory for the repository and `caveman` is a core capability.

## Reason

Manuel wants the active global runtime to default to concise, direct responses without losing technical precision. The repository should record this preference as an explicit, portable template choice instead of relying on an untracked local runtime change.

The original boundary treated the style as optional for third-party adopters because it is opinionated and may conflict with a team's desired tone. That boundary no longer applies to this repository's default profile.

## Changes

- Added a `Communication Style` section to `codex-global/AGENTS.md`.
- Reclassified `caveman` from `review` to `optional` in `workspace-manifest.json`.
- Added `caveman` to the `full-reviewed` profile so explicit full adoption includes the communication-style skill.
- Updated capability inventory, provenance, README, and changelog to explain the adoption boundary.

## Consequences

- Manuel's local global runtime can use `caveman lite` consistently.
- Third-party consumers can remove or adapt the communication-style section before copying the template into their own runtime.
- Superseded: `caveman` is now core and provenance is informational, not a use/import blocker.
