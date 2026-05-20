# Windows Setup And Validation Runbook

Status: compatibility redirect.

The canonical Windows setup runbook is `docs/runbooks/setup-windows.md`.

Use this file only as a stable legacy link for readers who know the old path. The current policy is:

- validate repository health with `scripts/healthcheck.ps1`;
- validate skill metadata and provenance coverage with `scripts/validate-skills.py`;
- validate continuous-evolution drift with `scripts/evolve-workspace.py`;
- keep repository validation separate from local `~/.codex` runtime state;
- preview optional runtime adoption with an explicit profile and `-WhatIf`;
- skip existing runtime files by default unless `-Force` is explicitly used;
- never copy all skills and agents by default.

Current commands:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
python scripts/validate-python-syntax.py scripts/validate-skills.py scripts/evolve-workspace.py scripts/scaffold-capability.py scripts/validate-python-syntax.py
python scripts/validate-skills.py --strict
python scripts/evolve-workspace.py --strict
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -ListProfiles
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -WhatIf
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile full-reviewed -WhatIf
```
