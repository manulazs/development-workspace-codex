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
python scripts/validate-python-syntax.py scripts/validate-skills.py scripts/evolve-workspace.py scripts/scaffold-capability.py scripts/validate-caveman-lite.py scripts/validate-observations.py scripts/validate-python-syntax.py
python scripts/validate-caveman-lite.py --repo .
python scripts/validate-skills.py --strict
python scripts/evolve-workspace.py --strict
python scripts/validate-observations.py --repo . --strict
```

The healthcheck validates repository structure, docs, manifest coverage, skill frontmatter, agent TOML, installer safety, basic secret patterns, continuous-evolution drift, Caveman LITE activation contract, and repository validators. It does not compare against the local Codex runtime.

## Inspect Adoption Profiles

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -ListProfiles
```

Profiles are reusable recommendations:

- `minimal`: docs and governance only.
- `governed-codex`: core governed Codex capabilities.
- `data-bi`: data discovery, engineering, cataloging, science, analysis, BI, and visualization capabilities.
- `frontend-artifacts`: frontend and artifact validation capabilities.
- `full-reviewed`: all broad-use core and optional capabilities.

## Preview Optional Runtime Adoption

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -WhatIf
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -InstallGlobalInstructions -WhatIf
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile full-reviewed -WhatIf
```

Live adoption skips existing runtime files by default. Use `-Force` only after reviewing the `-WhatIf` output.

Use a custom target when testing:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -CodexHome .\.tmp\codex-home -WhatIf
```

The installer copies only selected profile capabilities. It never deletes files from the target runtime and never installs `curated`, `review`, `deprecated`, or `archived` capabilities automatically.

The original Caveman Codex path is per-session. To make `caveman lite` active by default in a Codex runtime, install both the `caveman` skill and the global instruction template with `-InstallGlobalInstructions`.

Before publishing a fork for broad reuse, inspect `docs/skills-provenance.md` for source, license, attribution, and script-risk notes. These notes are informational and do not block authorized repository skills.

## Install Into A Runtime

Only run this when you explicitly want to copy a profile into your local Codex home:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex
```

To install the global instruction template at the same time:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -InstallGlobalInstructions
python scripts/validate-caveman-lite.py --repo . --codex-home $env:USERPROFILE\.codex
```

Restart Codex after changing runtime skills or agents.

## Troubleshooting

- If Git commands fail with `index.lock: Permission denied`, stop Git write operations first. Check `.git/index.lock` age and size, run `Get-Process git -ErrorAction SilentlyContinue`, and confirm no editor, terminal, or Git operation is active. If command-line inspection is blocked by Windows permissions, use Task Manager or Process Explorer. Remove `.git/index.lock` only after confirming it is stale and only through an explicit maintainer-approved command.
- If Python is missing, install Python 3 and confirm `python --version`.
- If `migrate-to-codex` validation is skipped, confirm Python is available and rerun the healthcheck.
- If a profile fails to install, inspect `workspace-manifest.json` and ensure the profile does not reference `curated`, `review`, `deprecated`, or `archived` capabilities.
