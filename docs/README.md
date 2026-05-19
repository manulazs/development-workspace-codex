# Documentation Index

This directory contains operating documentation for the Codex development workspace.

## Start Here

- `runbooks/setup-windows.md`: Windows setup and validation.
- `runbooks/setup-macos.md`: macOS/Linux setup and validation.
- `operations/workspace-health.md`: current health state and known gaps.
- `capability-inventory.md`: tracked skills, agents, status, risk, and overlap.
- `subagents-policy.md`: subagent orchestration rules.
- `subagents-lifecycle.md`: creation, reuse, validation, and retirement of custom agents.
- `self-improvement-lifecycle.md`: lesson, pattern, skill, agent, rule, audit, and inventory promotion flow.

## Governance

- `decisions/`: structural decisions and ADRs.
- `audits/`: periodic and post-change audits.
- `lessons/`: recurring errors, fixes, and learnings.
- `patterns/`: approved reusable workflows and rejected patterns.
- `patterns/rejected/`: rejected workflows that should not be revived without new evidence.

## Maintenance

Use the platform-specific healthcheck before and after workspace changes:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
```

```bash
scripts/healthcheck.sh
```
