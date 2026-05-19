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
scripts/healthcheck.sh
```

The healthcheck validates repository structure, docs, manifest coverage, skill frontmatter, agent TOML, installer safety, basic secret patterns, and repository validators. It does not compare against the local Codex runtime.

## Inspect Adoption Profiles

```bash
scripts/install-workspace.sh --list-profiles
```

Profiles are reusable recommendations:

- `minimal`: docs and governance only.
- `governed-codex`: core governed Codex capabilities.
- `data-bi`: analytics engineering and BI capabilities.
- `frontend-artifacts`: frontend and artifact validation capabilities.
- `full-reviewed`: all broad-use core and optional capabilities.

## Preview Optional Runtime Adoption

```bash
scripts/install-workspace.sh --profile governed-codex --dry-run
```

Use a custom target when testing:

```bash
scripts/install-workspace.sh --profile governed-codex --codex-home ./.tmp/codex-home --dry-run
```

The installer copies only selected profile capabilities. It never deletes files from the target runtime and never installs `curated`, `review`, `deprecated`, or `archived` capabilities automatically.

## Install Into A Runtime

Only run this when you explicitly want to copy a profile into your local Codex home:

```bash
scripts/install-workspace.sh --profile governed-codex
```

Restart Codex after changing runtime skills or agents.

## Troubleshooting

- If `permission denied` appears, run `chmod +x scripts/*.sh`.
- If Python is missing, install Python 3 and confirm `python3 --version`.
- If `migrate-to-codex` validation is skipped, confirm Python is available and rerun the healthcheck.
- If a profile fails to install, inspect `workspace-manifest.json` and ensure the profile does not reference `curated`, `review`, `deprecated`, or `archived` capabilities.
