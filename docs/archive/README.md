# Archive

This directory stores retired or superseded workspace capabilities and governance artifacts that should remain visible but must not be loaded by Codex automatically.

## Rules

- Move archived agents outside `.codex/agents/`.
- Move archived skills outside `skills/`.
- Keep a short reason for archival in `docs/capability-inventory.md`.
- Do not reinstall archived capabilities without a fresh capability review.
- Prefer deletion when the artifact has no historical or diagnostic value.

## Subdirectories

- `agents/`: archived custom agent definitions or notes.
- `skills/`: archived skills or migration notes.
