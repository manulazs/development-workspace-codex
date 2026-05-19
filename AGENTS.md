# Development Workspace Codex

This repository stores Manuel's reproducible Codex development workspace: global instructions, custom skills, and setup documentation.

## Operating Rules

- Keep this repository private unless Manuel explicitly decides otherwise.
- Version custom skills and global instruction templates here before copying them into `~/.codex`.
- Treat this repository as the source of truth and `~/.codex` as the active runtime install. Never assume they are synchronized.
- Before changing this workspace, run `scripts/healthcheck.ps1` or state why it could not be run.
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
- Operational runbooks, audits, lessons, patterns, and capability inventory under `docs/`.

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

When adding or updating model assignments for custom agents, prefer `gpt-5.3-codex` with high reasoning for implementation-heavy coding, SQL, dbt, package, or environment work where Codex-specific efficiency matters; prefer `gpt-5.4` for visual, analytical, review, security, and ambiguous reasoning tasks.

## Subagent Policy

Use 0 subagents by default. Use 1 subagent only when Manuel explicitly allows subagent work, the task has a clear independent scope, and the output can be reviewed without redoing the work.

Use multiple subagents only for independent workstreams with disjoint ownership. The default limit is 3 subagents per round; more requires explicit justification.

Never delegate the next critical-path blocker, never ask multiple similar agents the same question, and always record objective, owner, read/write scope, input, output, dependency, and risk before spawning.

The detailed policy is `docs/subagents-policy.md`.

## Self-Improvement

Record recurring errors and validated fixes in `docs/lessons/`. Promote stable repeatable workflows to `docs/patterns/` or `docs/runbooks/`. Record structural decisions in `docs/decisions/`.

Update `docs/capability-inventory.md` whenever skills or agents are added, removed, reclassified, or materially changed.

Prefer PowerShell scripts for repository automation because Manuel's active environment is Windows/PowerShell.
