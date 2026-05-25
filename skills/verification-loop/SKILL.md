---
name: verification-loop
description: Orchestrate repository or consumer-project validation as a repeatable readiness loop without replacing project-specific healthchecks.
metadata:
  short-description: Repeatable validation readiness loop
  origin: Adapted from ECC verification-loop and eval-harness concepts.
---

# Verification Loop

Use this skill after meaningful implementation, before commits, before push, or when a workspace needs a readiness check.

This skill coordinates validation. It does not replace the repository healthcheck and does not invent commands when the project has no evidence for them.

## Workspace Template Validation

For this workspace repository, prefer:

```bash
python3 scripts/workspace-doctor.py --repo . --profile full-reviewed
python3 scripts/analyze-context-budget.py --repo . --profile full-reviewed
python3 scripts/evolve-workspace.py --strict
python3 scripts/validate-skills.py --strict
python3 scripts/validate-observations.py --repo . --strict
python3 skills/migrate-to-codex/scripts/cli.py --validate-target .
python3 scripts/validate-caveman-lite.py --repo . --codex-home /Users/manuel/.codex
bash scripts/healthcheck.sh --strict
bash scripts/install-workspace.sh --profile full-reviewed --dry-run
```

Use PowerShell equivalents on Windows when available:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1 -Strict
python scripts/workspace-doctor.py --repo . --profile full-reviewed
python scripts/analyze-context-budget.py --repo . --profile full-reviewed
```

## Consumer Project Validation

For other repositories:

1. Read project `AGENTS.md`, README, package files, CI config, and docs for validation commands.
2. Prefer documented commands over guessed commands.
3. Run cheap checks first, then build/test/security checks.
4. Summarize failures with the command, exit status, and short failure tail.
5. Do not run destructive, deployment, migration, or broad network commands without explicit approval.

## Output

Return:

```text
Verification Report:
Commands run:
Pass/fail:
Blocked/skipped:
Residual risks:
Ready for commit/push:
```

If validation is incomplete, state the exact missing runtime, tool, credential, or platform.
