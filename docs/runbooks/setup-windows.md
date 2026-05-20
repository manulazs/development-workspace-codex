# Windows Setup And Validation

Use this runbook to validate the public repository and optionally preview adoption into a Windows Codex runtime.

## Requirements

- Git for Windows.
- Windows PowerShell 5+ or PowerShell 7+.
- Python 3 for manifest and migration validation.
- Codex installed separately only if you plan to adopt a profile into a local runtime.

The repository itself does not require any preexisting `~/.codex` state.

## Clone And Inspect

```powershell
git clone https://github.com/manulazs/development-workspace-codex.git
cd development-workspace-codex
git status --short --branch
```

## Validate Repository Health

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1 -Strict
python scripts/validate-skills.py --strict
python scripts/evolve-workspace.py --strict
```

The healthcheck validates repository structure, docs, manifest coverage, skill frontmatter, agent TOML, installer safety, basic secret patterns, continuous-evolution drift, and repository validators. It does not compare against the local Codex runtime.

## Inspect Adoption Profiles

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -ListProfiles
```

Profiles are reusable recommendations:

- `minimal`: docs and governance only.
- `governed-codex`: core governed Codex capabilities.
- `data-bi`: analytics engineering and BI capabilities.
- `frontend-artifacts`: frontend and artifact validation capabilities.
- `full-reviewed`: all broad-use core and optional capabilities.

## Preview Optional Runtime Adoption

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -WhatIf
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile full-reviewed -WhatIf
```

Live adoption skips existing runtime files by default. Use `-Force` only after reviewing the `-WhatIf` output.

Use a custom target when testing:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -CodexHome .\.tmp\codex-home -WhatIf
```

The installer copies only selected profile capabilities. It never deletes files from the target runtime and never installs `curated`, `review`, `deprecated`, or `archived` capabilities automatically.

Before publishing a fork for broad reuse, inspect `docs/skills-provenance.md` and resolve any `needs-source-review` skills that the fork intends to distribute.

## Install Into A Runtime

Only run this when you explicitly want to copy a profile into your local Codex home:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex
```

Restart Codex after changing runtime skills or agents.

## Troubleshooting

- If Git commands fail with `index.lock: Permission denied`, wait for OneDrive or editor processes to release `.git` files, then retry.
- If Python is missing, install Python 3 and confirm `python --version`.
- If `migrate-to-codex` validation is skipped, confirm Python is available and rerun the healthcheck.
- If a profile fails to install, inspect `workspace-manifest.json` and ensure the profile does not reference `curated`, `review`, `deprecated`, or `archived` capabilities.
