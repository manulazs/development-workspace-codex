# Summary

What changed?

## Why

Why is this change needed?

## Scope

- Scripts:
- Documentation:
- Skills:
- Agents:
- CI:
- Inventory:

## Validation

- [ ] `scripts/healthcheck.ps1`
- [ ] `scripts/healthcheck.sh`
- [ ] `python scripts/validate-skills.py --strict`
- [ ] `python scripts/evolve-workspace.py --strict`
- [ ] `scripts/install-workspace.ps1 -Profile full-reviewed -WhatIf` or `scripts/install-workspace.sh --profile full-reviewed --dry-run`
- [ ] `python skills/migrate-to-codex/scripts/cli.py --validate-target .`
- [ ] `git diff --check`
- [ ] Other:

## Governance Checklist

- [ ] Updated `workspace-manifest.json` if adoption profiles or capability status changed.
- [ ] Updated `docs/capability-inventory.md` if a skill or agent changed.
- [ ] Updated `docs/skills-provenance.md` if a skill changed.
- [ ] Updated `docs/agentic-controls.md` if skill/subagent automation boundaries changed.
- [ ] Updated `docs/self-improvement-lifecycle.md`, lessons, patterns, or runbooks if behavior changed.
- [ ] Updated `AGENTS.md` only for short permanent behavior rules.
- [ ] No secrets, tokens, private logs, cache files, sessions, auth files, or local Codex runtime state included.

## Notes

Residual risks or follow-up work.
