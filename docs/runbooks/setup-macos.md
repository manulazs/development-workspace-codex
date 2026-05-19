# macOS Setup And Validation

Use this runbook for macOS or Linux shells.

## Requirements

- Git.
- Bash 4+.
- Python 3.
- Codex installed and configured separately.
- Optional: `PyYAML` in the active Python environment for full system skill validation.

On macOS, install missing basics with Homebrew when needed:

```bash
brew install git python
```

## Inspect

```bash
git status --short --branch
scripts/healthcheck.sh
```

If the script is not executable after checkout, run:

```bash
chmod +x scripts/healthcheck.sh scripts/install-workspace.sh
```

## Preview Install

```bash
scripts/install-workspace.sh --dry-run
```

The dry run prints planned copies without modifying `~/.codex`.

## Install Repo Skills And Agents

```bash
scripts/install-workspace.sh
```

This copies:

- `skills/*` to `~/.codex/skills/*`.
- `.codex/agents/*.toml` to `~/.codex/agents/*.toml`.

It does not delete extra files from `~/.codex`.

## Validate After Install

```bash
scripts/healthcheck.sh
python skills/migrate-to-codex/scripts/cli.py --validate-target .
```

Restart Codex after installing or updating skills or agents.

## Troubleshooting

- If `python` is missing, install Python 3 and confirm `python --version`.
- If `PyYAML` is missing, install it in the active Python environment or treat full skill validation as unavailable.
- If `permission denied` appears, run `chmod +x scripts/*.sh`.
- If Codex runtime drift is reported, run `scripts/install-workspace.sh --dry-run` before installing.
