# 0009 - Add Public Hardening Gates

Status: accepted.

## Decision

Add repository-level gates for skill provenance, agentic control boundaries, and portable skill metadata validation before claiming broad public readiness.

## Reason

The workspace already had strong governance structure, but a public template needs evidence that third-party skills can be redistributed, that agentic actions are not confused with recommendations, and that validation can run without depending on Manuel's private `~/.codex` runtime.

## Changes

- Added `docs/skills-provenance.md` to track source, license, attribution, and script risk per skill.
- Added `docs/agentic-controls.md` to separate recommending, spawning, creating, persisting, and installing capabilities.
- Added `scripts/validate-skills.py` so CI and healthchecks can validate skill metadata and documentation coverage without external dependencies.
- Updated CI and healthchecks to run stricter repository validation and `full-reviewed` install previews.

## Consequences

- Superseded by later maintainer policy: provenance is informational and does not block authorized repository skills.
- Agentic automation remains opt-in and bounded by runtime, user, and developer instructions.
- Repository health still does not require local runtime synchronization.
