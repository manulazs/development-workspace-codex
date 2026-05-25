# Documentation Index

This directory contains the operating documentation for the public Codex workspace template.

## Daily Path

1. Read `../README.md` for the repository model and quickstart.
2. Read `executive-summary.md` for the full operating model.
3. Inspect `../workspace-manifest.json` to choose an adoption profile.
4. Use `capability-inventory.md` to understand capability status, risk, overlap, and selection rules.
5. Use `skills-provenance.md` before publishing, importing, or reclassifying skills.
6. Use `agentic-controls.md` before treating a recommendation as an action.
7. Use `continuous-evolution.md` before automating task cataloging, private observation review, skill evolution, agent evolution, or subagent routing.
8. Use `mcp-governance.md` before adding, recommending, or installing MCP servers.
9. Use `subagents-policy.md` before delegating work to subagents.
10. Use `subagent-context-protocol.md` to keep delegated context, returns, and handoffs compact.
11. Use `self-improvement-lifecycle.md` before turning lessons into rules, skills, agents, or docs.
12. Use the platform runbook for setup and optional runtime adoption.
13. Record structural decisions in `decisions/`.

## Canonical Docs

- `../README.md`: public overview, architecture, quickstart, and governance summary.
- `executive-summary.md`: full explanation of what the workspace is, how it works, what changed, and how each major capability is used.
- `../workspace-manifest.json`: reusable adoption profiles; not local runtime state.
- `capability-inventory.md`: inventory of skills and agents with status, risk, overlap, and usage guidance.
- `skills-provenance.md`: informational skill source, license, attribution, and script-risk matrix.
- `agentic-controls.md`: distinction between recommending, spawning, creating, persisting, and installing capabilities.
- `continuous-evolution.md`: governed automation model for task cataloging, private observation review, anti-duplication, subagent routing, validation, and human gates.
- `mcp-governance.md`: MCP adoption policy, risk checklist, and review-only catalog pattern.
- `data-agent-pipeline.md`: data-development pipeline routing across discovery, engineering, cataloging, science, analysis, and visualization agents.
- `subagents-policy.md`: policy for 0, 1, or multiple subagents.
- `subagent-context-protocol.md`: context budgets, return budgets, fork-context guidance, and integration rules for efficient subagent use.
- `subagents-lifecycle.md`: lifecycle for creating, changing, merging, or retiring subagent templates.
- `self-improvement-lifecycle.md`: public improvement loop and pruning rules.
- `skill-template.md`: proposal template for new or changed skills.
- `agent-template.md`: proposal template for new or changed subagents.
- `runbooks/setup-windows.md`: Windows setup and optional adoption preview.
- `runbooks/setup-macos.md`: macOS/Linux setup and optional adoption preview.
- `operations/workspace-health.md`: what repository health means and what it excludes.
- `evolution/`: generated task catalogs, reports, proposals, and public templates for private observation logs.
- `../scripts/scaffold-capability.py`: governed skill/agent proposal and scaffold helper with duplicate checks.

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
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1 -Strict
python scripts/validate-skills.py --strict
```

macOS/Linux:

```bash
scripts/healthcheck.sh --strict
python scripts/evolve-workspace.py --strict
python scripts/validate-skills.py --strict
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
