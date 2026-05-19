# Windows Setup And Validation Runbook

Status: compatibility redirect.

The canonical Windows setup runbook is `docs/runbooks/setup-windows.md`.

Use this file only as a stable legacy link for readers who know the old path. The current policy is:

- validate repository health with `scripts/healthcheck.ps1`;
- keep repository validation separate from local `~/.codex` runtime state;
- preview optional runtime adoption with an explicit profile and `-WhatIf`;
- never copy all skills and agents by default.

Current commands:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -ListProfiles
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -WhatIf
```
