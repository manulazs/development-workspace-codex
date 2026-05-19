# Documentation Index

This directory contains the operating documentation for the public Codex workspace template.

## Daily Path

1. Read `../README.md` for the repository model and quickstart.
2. Inspect `../workspace-manifest.json` to choose an adoption profile.
3. Use `capability-inventory.md` to understand capability status, risk, overlap, and selection rules.
4. Use `subagents-policy.md` before delegating work to subagents.
5. Use `self-improvement-lifecycle.md` before turning lessons into rules, skills, agents, or docs.
6. Use the platform runbook for setup and optional runtime adoption.
7. Record structural decisions in `decisions/`.

## Canonical Docs

- `../README.md`: public overview, architecture, quickstart, and governance summary.
- `../workspace-manifest.json`: reusable adoption profiles; not local runtime state.
- `capability-inventory.md`: inventory of skills and agents with status, risk, overlap, and usage guidance.
- `subagents-policy.md`: policy for 0, 1, or multiple subagents.
- `subagents-lifecycle.md`: lifecycle for creating, changing, merging, or retiring subagent templates.
- `self-improvement-lifecycle.md`: public improvement loop and pruning rules.
- `skill-template.md`: proposal template for new or changed skills.
- `agent-template.md`: proposal template for new or changed subagents.
- `runbooks/setup-windows.md`: Windows setup and optional adoption preview.
- `runbooks/setup-macos.md`: macOS/Linux setup and optional adoption preview.
- `operations/workspace-health.md`: what repository health means and what it excludes.

## Governance Areas

- `decisions/`: structural decisions and ADRs.
- `audits/`: historical or current audits. Each audit should state whether it is open, superseded, or actioned.
- `lessons/`: reusable lessons from repeated work.
- `patterns/`: approved reusable workflows.
- `patterns/rejected/`: rejected workflows that should not be revived without new evidence.
- `archive/`: retired content kept outside runtime-loadable paths.

## Repository Validation

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
```

macOS/Linux:

```bash
scripts/healthcheck.sh
```

The healthcheck validates this repository. It intentionally does not compare repository contents with `~/.codex`.

## Optional Runtime Adoption

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -WhatIf
```

macOS/Linux:

```bash
scripts/install-workspace.sh --profile governed-codex --dry-run
```

Runtime adoption is opt-in, profile-based, and consumer-controlled.
