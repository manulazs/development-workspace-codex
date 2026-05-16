# Development Workspace Codex

This repository stores Manuel's reproducible Codex development workspace: global instructions, custom skills, and setup documentation.

## Operating Rules

- Keep this repository private unless Manuel explicitly decides otherwise.
- Version custom skills and global instruction templates here before copying them into `~/.codex`.
- Preserve source attribution when adapting third-party skills.
- Do not commit secrets, tokens, private logs, local database files, authentication files, or Codex internal state.
- Use clear commits that describe one coherent environment change at a time.

## Scope

Track:

- Custom or adapted skills under `skills/`.
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

External skills should be reviewed before installation. Avoid silent installation flags unless Manuel explicitly approves unattended installation for a low-risk case.

If an external skill is useful but not directly compatible with Codex, use `convert-skill-to-codex` to adapt it before installation. Do not install a Claude Code or other agent-specific skill unchanged unless Manuel explicitly accepts the compatibility risk.

When `skill-installer` is invoked directly for an external skill, still perform the compatibility check first. If the source is from another agent ecosystem or unknown format, route through `convert-skill-to-codex` before installing.
