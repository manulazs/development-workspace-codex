# macOS/Linux Setup And Validation

Use this runbook to validate the public repository and optionally preview adoption into a macOS or Linux Codex runtime.

## Requirements

- Git.
- Bash compatible with macOS default Bash 3.2 or newer.
- Python 3 preferred; `python` is accepted when it points to Python 3.
- Codex installed separately only if you plan to adopt a profile into a local runtime.

On macOS, install missing basics with Homebrew when needed:

```bash
brew install git python
```

The repository itself does not require any preexisting `~/.codex` state.

## Clone And Inspect

```bash
git clone https://github.com/manulazs/development-workspace-codex.git
cd development-workspace-codex
git status --short --branch
```

If shell scripts are not executable after checkout:

```bash
chmod +x scripts/healthcheck.sh scripts/install-workspace.sh
```

## Validate Repository Health

```bash
scripts/healthcheck.sh --strict
python scripts/validate-caveman-lite.py --repo .
python scripts/validate-skills.py --strict
python scripts/evolve-workspace.py --strict
python scripts/validate-observations.py --repo . --strict
```

The healthcheck validates repository structure, docs, manifest coverage, skill frontmatter, agent TOML, installer safety, basic secret patterns, continuous-evolution drift, Caveman LITE activation contract, and repository validators. It does not compare against the local Codex runtime.

## Inspect Adoption Profiles

```bash
scripts/install-workspace.sh --list-profiles
```

Profiles are reusable recommendations:

- `minimal`: docs and governance only.
- `governed-codex`: core governed Codex capabilities.
- `data-bi`: data discovery, engineering, cataloging, science, analysis, BI, and visualization capabilities.
- `frontend-artifacts`: frontend and artifact validation capabilities.
- `full-reviewed`: all broad-use core and optional capabilities.

## Preview Optional Runtime Adoption

```bash
scripts/install-workspace.sh --profile governed-codex --dry-run
scripts/install-workspace.sh --profile governed-codex --install-global-instructions --dry-run
scripts/install-workspace.sh --profile full-reviewed --dry-run
```

Live adoption skips existing runtime files by default. Use `--force` only after reviewing the dry-run output.

Use a custom target when testing:

```bash
scripts/install-workspace.sh --profile governed-codex --codex-home ./.tmp/codex-home --dry-run
```

The installer copies only selected profile capabilities. It never deletes files from the target runtime and never installs `curated`, `review`, `deprecated`, or `archived` capabilities automatically.

The original Caveman Codex path is per-session. To make `caveman lite` active by default in a Codex runtime, install both the `caveman` skill and the global instruction template with `--install-global-instructions`.

Before publishing a fork for broad reuse, inspect `docs/skills-provenance.md` for source, license, attribution, and script-risk notes. These notes are informational and do not block authorized repository skills.

## Install Into A Runtime

Only run this when you explicitly want to copy a profile into your local Codex home:

```bash
scripts/install-workspace.sh --profile governed-codex
```

To install the global instruction template at the same time:

```bash
scripts/install-workspace.sh --profile governed-codex --install-global-instructions
python scripts/validate-caveman-lite.py --repo . --codex-home ~/.codex
```

Restart Codex after changing runtime skills or agents.

## Troubleshooting

- If `permission denied` appears, run `chmod +x scripts/*.sh`.
- If Python is missing, install Python 3 and confirm `python3 --version`.
- If `migrate-to-codex` validation is skipped, confirm Python is available and rerun the healthcheck.
- If a profile fails to install, inspect `workspace-manifest.json` and ensure the profile does not reference `curated`, `review`, `deprecated`, or `archived` capabilities.
