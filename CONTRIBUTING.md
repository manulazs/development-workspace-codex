# Contributing

This repository is a public, portable Codex workspace template. Contributions should improve reliability, portability, governance, or capability quality without adding avoidable complexity or local runtime assumptions.

## Before You Start

- Read `README.md` and `docs/README.md`.
- Run the healthcheck for your platform.
- Inspect `workspace-manifest.json` before changing adoption behavior.
- Check `docs/capability-inventory.md` before adding skills or agents.
- Check `docs/self-improvement-lifecycle.md` before adding permanent rules.

## Development Flow

1. Create a focused branch or local change set.
2. Keep each change scoped to one logical purpose.
3. Update documentation with behavior changes.
4. Run relevant validations.
5. Commit with a clear, specific message.

## Validation

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
```

macOS/Linux:

```bash
scripts/healthcheck.sh
scripts/install-workspace.sh --profile governed-codex --dry-run
```

Windows install preview:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -WhatIf
```

Agent validation:

```bash
python skills/migrate-to-codex/scripts/cli.py --validate-target .
```

## Adding Skills

- Use `docs/skill-template.md`.
- Prove the capability is not already covered by an existing skill, agent, runbook, system skill, or plugin.
- Document external commands, network use, destructive actions, and secret risk.
- Update `workspace-manifest.json`.
- Update `docs/capability-inventory.md`.
- Validate before committing.

## Adding Subagents

- Use `docs/agent-template.md`.
- Compare against `.codex/agents/` and `docs/capability-inventory.md`.
- Keep ownership, permissions, and outputs narrow.
- Prefer read-only for audit and review roles.
- Update `workspace-manifest.json`.
- Update `docs/capability-inventory.md`.

## Self-Improvement

- Record recurring operational fixes in `docs/lessons/`.
- Promote repeated workflows to `docs/patterns/` or `docs/runbooks/`.
- Use ADRs only for structural decisions.
- Record rejected practices under `docs/patterns/rejected/` when useful.

## Pull Requests

Every pull request should explain:

- What changed.
- Why it changed.
- What validations were run.
- Whether skills, agents, inventory, or instructions were affected.
- Whether adoption profiles or local-runtime boundaries were affected.
