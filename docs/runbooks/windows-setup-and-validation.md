# Windows Setup And Validation Runbook

This repository is Windows-first. Use PowerShell from the repository root.

## 1. Inspect

```powershell
git status --short --branch
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
```

The healthcheck validates repository shape, skill frontmatter, custom-agent TOML, basic secret patterns, capability inventory coverage, and repo-to-`~/.codex` drift.

Warnings are actionable but do not fail the default run. Use `-Strict` when you want warnings to fail the command.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1 -Strict
```

## 2. Preview Install

Never copy repo capabilities into the active Codex profile blindly. Preview first:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -WhatIf
```

## 3. Install Repo Skills And Agents

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1
```

This copies:

- `skills/*` to `~/.codex/skills/*`.
- `.codex/agents/*.toml` to `~/.codex/agents/*.toml`.

It does not delete extra files from `~/.codex`.

## 4. Validate After Install

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
```

Restart Codex after installing or updating skills or agents.

## 5. Skill Validator Dependency

`skill-creator/scripts/quick_validate.py` may require `PyYAML` in the active Python environment. If the healthcheck reports that `PyYAML` is missing, either:

- install `PyYAML` in the Python environment used by Codex validation; or
- rely on the built-in lightweight healthcheck for frontmatter checks until the validator environment is fixed.

Do not claim full skill validation passed when `quick_validate.py` cannot run.

## 6. Before Commit

```powershell
git status --short
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
python skills/migrate-to-codex/scripts/cli.py --validate-target .
```

Commit only one coherent workspace change at a time.
