# Documentation Index

This directory contains operating documentation for the Codex development workspace.

## Start Here

- `runbooks/setup-windows.md`: Windows setup and validation.
- `runbooks/setup-macos.md`: macOS/Linux setup and validation.
- `operations/workspace-health.md`: current health state and known gaps.
- `capability-inventory.md`: tracked skills, agents, status, risk, and overlap.
- `subagents-policy.md`: subagent orchestration rules.

## Governance

- `decisions/`: structural decisions and ADRs.
- `audits/`: periodic and post-change audits.
- `lessons/`: recurring errors, fixes, and learnings.
- `patterns/`: approved reusable workflows and rejected patterns.

## Maintenance

Use the platform-specific healthcheck before and after workspace changes:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
```

```bash
scripts/healthcheck.sh
```
