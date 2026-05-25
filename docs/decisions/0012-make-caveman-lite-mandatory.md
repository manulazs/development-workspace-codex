# 0012 - Make Caveman Lite Mandatory

Status: accepted.

## Decision

Make `caveman lite` the mandatory default communication standard for this repository and exported global instruction template.

## Reason

The maintainer wants the workspace to optimize for direct, low-filler, technically precise communication by default. Keeping the style optional made the repository policy ambiguous and let consumer profiles omit the behavior that this workspace is meant to enforce.

## Changes

- Reclassify `caveman` as `core` in `workspace-manifest.json`.
- Include `caveman` in the `governed-codex` profile so `full-reviewed` inherits it.
- Add explicit communication-standard rules to `AGENTS.md` and `codex-global/AGENTS.md`.
- Document that upstream Codex Caveman is per-session and this workspace makes LITE active by default through the global instruction template.
- Add installer support and validation for copying `codex-global/AGENTS.md` into a consumer Codex home.
- Update inventory, README, changelog, and provenance docs to reflect that provenance is informational and not a blocker for authorized skills.

## Consequences

- Any workspace adopting `governed-codex` gets the concise communication standard.
- A runtime must install both `skills/caveman/SKILL.md` and a global `AGENTS.md` rule to make LITE active by default.
- Agents may temporarily use fuller prose for safety warnings, destructive-action confirmations, legal clarity, complex multi-step instructions, or explicit user preference.
- Provenance notes remain useful for attribution, license preservation, and risk review, but they do not block use of repository skills.
