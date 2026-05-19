# Development Workspace Codex

This repository is a public, portable Codex workspace template. Treat it as a source repository for reusable skills, subagent templates, policies, runbooks, and validation scripts.

It must not reflect the private state of any local Codex runtime.

## Operating Rules

- Keep repository health separate from `~/.codex` or any other local runtime.
- Validate repository changes with the platform healthcheck when practical.
- Use `workspace-manifest.json` as the source of adoption profiles.
- Use `docs/capability-inventory.md` as the source of capability status, risk, and intended use.
- Preserve source attribution and license notes when adapting third-party skills.
- Do not commit secrets, tokens, private logs, local databases, authentication files, cache files, sessions, or corporate data.
- Do not auto-commit, push, publish, or change repository visibility unless the user explicitly asks for that operation.
- Keep edits scoped to the requested repository change; do not copy files into a local runtime unless explicitly requested.

## Scope

Track:

- Skill sources under `skills/`.
- Custom subagent templates under `.codex/agents/`.
- Global instruction templates under `codex-global/`.
- Adoption profiles in `workspace-manifest.json`.
- Governance, setup, audits, lessons, patterns, and decisions under `docs/`.
- Repository validation and optional profile installers under `scripts/`.

Do not track:

- `~/.codex/auth.json`.
- `~/.codex/logs_*.sqlite`.
- `~/.codex/state_*.sqlite`.
- `~/.codex/cache/`.
- `~/.codex/sessions/`.
- Any machine-specific runtime inventory.
- Any private data export, credential, token, or sensitive value.

## Skill Policy

Before adding or changing a skill:

- Check existing skills, agents, runbooks, patterns, docs, system skills, and plugin capabilities.
- Prefer a runbook or short policy when the workflow is not reusable enough to justify a skill.
- Do not promote personal preference or one-off behavior into a public default.
- Classify the skill in `workspace-manifest.json` as `core`, `optional`, `curated`, `review`, `deprecated`, or `archived`.
- Update `docs/capability-inventory.md` with purpose, risk, overlap, supported platforms, when to use, and when not to use.
- Validate changed skills through the repository healthcheck and relevant local validator.

Core skills should be small, generally useful, and low ambiguity. Domain skills should remain optional unless they are required for broad workspace governance.

## Subagent Policy

Delegation is an operational decision, not a default.

- Use 0 subagents for simple, linear, tightly coupled, or low-risk work.
- Use 1 subagent for an independent audit, review, or bounded side task.
- Use multiple subagents only when scopes are genuinely independent and integration cost is justified.
- The main agent remains responsible for synthesis, final judgment, and user-facing output.
- Every subagent template should define objective, scope, suggested model class, reasoning level, sandbox, required inputs, expected output, risks, when to use, when not to use, and exit criteria.

The detailed policy is `docs/subagents-policy.md`. Agent creation, reuse, validation, and retirement are governed by `docs/subagents-lifecycle.md`.

## Model Policy

Model guidance must be generic and revisable. Prefer criteria by risk and task complexity over hard requirements for one specific model.

- Critical security, review, migration, and destructive-operation tasks need a strong model class and explicit confirmation gates.
- Complex implementation or architecture work should use a strong Codex-oriented model when available.
- Mechanical documentation or inventory work can use a smaller model when risk is low.
- Consumer workspaces may substitute available models when the suggested model is unavailable.

## Self-Improvement

Use the public lifecycle:

```text
use -> observe -> lesson -> pattern -> skill/agent/doc -> validate -> review -> prune
```

Do not create a new skill or agent for a single occurrence. Capture lessons only when they are reusable, and remove stale or redundant content during review.
