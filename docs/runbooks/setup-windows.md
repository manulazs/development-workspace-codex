# Windows Setup And Validation

Use this runbook for Windows PowerShell.

## Requirements

- Git for Windows.
- Windows PowerShell 5+.
- Python 3.
- Codex installed and configured separately.
- Optional: `PyYAML` in the active Python environment for full system skill validation.

## Inspect

```powershell
git status --short --branch
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
```

## Preview Install

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -WhatIf
```

The preview prints planned copies without modifying `~/.codex`.

## Install Repo Skills And Agents

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1
```

This copies:

- `skills/*` to `~/.codex/skills/*`.
- `.codex/agents/*.toml` to `~/.codex/agents/*.toml`.

It does not delete extra files from `~/.codex`.

## Validate After Install

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
python skills/migrate-to-codex/scripts/cli.py --validate-target .
```

Restart Codex after installing or updating skills or agents.

## Troubleshooting

- If Git commands fail with `index.lock: Permission denied`, OneDrive or sandboxing may be blocking `.git` writes. Retry after processes exit or run the Git action with explicit approval.
- If `PyYAML` is missing, install it in the active Python environment or treat full skill validation as unavailable.
- If runtime drift is reported, run `scripts/install-workspace.ps1 -WhatIf` before installing.
