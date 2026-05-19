# Development Workspace Codex

This repository stores Manuel's reproducible Codex development workspace: global instructions, custom skills, and setup documentation.

## Operating Rules

- Keep this repository private unless Manuel explicitly decides otherwise.
- Version custom skills and global instruction templates here before copying them into `~/.codex`.
- Preserve source attribution when adapting third-party skills.
- Do not commit secrets, tokens, private logs, local database files, authentication files, or Codex internal state.
- Use clear commits that describe one coherent environment change at a time.
- By default, every workspace modification must be recorded in this repository without waiting for an explicit request.
- After completing a coherent change set, stage, commit, and push to `origin/main` when network/permissions allow.
- Only skip commit/push when Manuel explicitly asks to hold changes, or when a technical blocker prevents it.

## Scope

Track:

- Custom or adapted skills under `skills/`.
- Custom Codex subagents under `.codex/agents/`.
- Global Codex instruction templates under `codex-global/`.
- Reproduction notes and decisions under `docs/`.

Do not track:

- `~/.codex/auth.json`.
- `~/.codex/logs_*.sqlite`.
- `~/.codex/state_*.sqlite`.
- `~/.codex/cache/`.
- `~/.codex/sessions/`.
- Any corporate data, credentials, exports, or sensitive values.

## Skill Policy

Before adding external skills, check whether an existing local, global, project, or built-in skill already fits the purpose.

Avoid maintaining user-level duplicates for capabilities already covered by Codex system skills or enabled plugins unless the local version has a clear, documented advantage. Prefer the system/plugin version for broad capabilities such as OpenAI docs, presentations, spreadsheets, documents, or browser automation.

External skills should be reviewed before installation. Avoid silent installation flags unless Manuel explicitly approves unattended installation for a low-risk case.

If an external skill is useful but not directly compatible with Codex, use `migrate-to-codex` to migrate or adapt it before installation. Do not install a Claude Code or other agent-specific skill unchanged unless Manuel explicitly accepts the compatibility risk.

When `skill-installer` is invoked directly for an external skill, still perform the compatibility check first. If the source is from another agent ecosystem or unknown format, route through `migrate-to-codex` before installing.

Validate every changed skill with `skill-creator/scripts/quick_validate.py` before copying it into `~/.codex/skills` or committing it to this repository.

Validate changed custom agents with `migrate-to-codex --validate-target .` before copying them into `~/.codex/agents` or committing them to this repository.
