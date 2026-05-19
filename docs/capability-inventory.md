# Capability Inventory

Last reviewed: 2026-05-19

This file is the source of truth for tracked workspace skills and custom agents. `README.md` should summarize this file instead of duplicating every operational detail.

## Status Values

- `keep`: approved for the repository.
- `review`: useful, but overlap or risk should be reviewed before broad use.
- `curated`: keep as source material; install or invoke only when the task clearly needs it.
- `retire-candidate`: remove or archive if no validated use appears in the next review.

## Runtime Status

The repository and active Codex runtime are separate:

- Repository source: `skills/` and `.codex/agents/`.
- Runtime install: `~/.codex/skills` and `~/.codex/agents`.

Run `scripts/healthcheck.ps1` to compare them. Run `scripts/install-workspace.ps1 -WhatIf` before copying anything into the runtime profile.

## Skills

| Skill | Origin | Purpose | Risk | Decision | Notes |
| --- | --- | --- | --- | --- | --- |
| `adding-dbt-unit-test` | dbt Labs | dbt unit-test authoring | Low | keep | Domain-specific and useful for analytics engineering. |
| `agent-browser` | Vercel Labs | Specialized browser automation CLI | Medium | review | Overlaps built-in/browser plugin capabilities; use only for agent-browser-specific cases. |
| `answering-natural-language-questions-with-dbt` | dbt Labs | Answer business data questions with dbt context | Medium | keep | Warehouse/API access can be sensitive; keep query scope explicit. |
| `auditing-skills` | dbt Labs | Audit skill quality/security | Low | keep | Useful for capability governance. |
| `building-dbt-semantic-layer` | dbt Labs | Build dbt semantic models/metrics | Low | keep | Domain-specific. |
| `canvas-design` | Anthropic skills, adapted | Static visual art/design outputs | Medium | curated | Large font asset bundle; keep only while visual artifact work remains useful. |
| `caveman` | JuliusBrussee caveman | Concise communication style | Low | review | Keep only if Manuel still uses this style explicitly. |
| `caveman-commit` | JuliusBrussee caveman | Git commit workflow phrasing | Low | review | Overlaps normal git hygiene and `version_control_manager`. |
| `caveman-compress` | JuliusBrussee caveman | Compress memory text files | Medium | review | Native compaction exists; use only for explicit caveman-format memory compression. |
| `configuring-dbt-mcp-server` | dbt Labs | Configure/troubleshoot dbt MCP | Medium | keep | Handles credentials indirectly; never store secrets. |
| `creating-mermaid-dbt-dag` | dbt Labs | Generate dbt lineage diagrams | Low | keep | Good focused utility. |
| `fetching-dbt-docs` | dbt Labs | Fetch/search dbt docs | Low | keep | Prefer official docs when current facts matter. |
| `find-skills` | Vercel Labs, adapted | Discover and vet external skills | Medium | keep | Must preserve approval-first installation policy. |
| `frontend-design` | Anthropic skills, migrated | Distinctive frontend UI design | Low | keep | Useful, but avoid overlapping with plugin-specific design workflows. |
| `migrate-to-codex` | OpenAI | Migrate instructions, skills, agents, config | Medium | keep | Core governance capability. |
| `migrating-dbt-core-to-fusion` | dbt Labs | Triage Core-to-Fusion migration errors | Medium | keep | May run external tools; validate before broad execution. |
| `migrating-dbt-project-across-platforms` | dbt Labs | Data-platform migration workflow | Medium | keep | High impact on SQL behavior; use with scoped validation. |
| `pdf` | OpenAI / curated | PDF creation/review workflows | Low | review | May overlap system or plugin PDF capabilities in some sessions. |
| `plan-deep` | Local | Manual-only deep planning and delegation matrix | Low | keep | Must remain manual-only. |
| `plan-deep-skills` | Local | Manual-only planning with skill discovery | Low | keep | Must remain manual-only. |
| `powerbi-expert` | Community PCL | Power BI, DAX, M, modeling | Medium | review | Overlaps `powerbi-dax-html`; prefer local `powerbi-dax-html` for Manuel-specific HTML Content rules. |
| `running-dbt-commands` | dbt Labs | Format and run dbt CLI commands | Medium | keep | Useful, but avoid broad warehouse runs. |
| `screenshot` | OpenAI / curated | Desktop/system screenshots | Medium | review | OS-level capture can be sensitive; use only when needed. |
| `spreadsheet` | OpenAI listing, reconstructed | Spreadsheet creation/editing | Low | review | May overlap system/plugin spreadsheet capabilities. |
| `theme-factory` | Anthropic skills | Reusable visual themes | Low | curated | Useful for artifacts; not core engineering workflow. |
| `troubleshooting-dbt-job-errors` | dbt Labs | Diagnose dbt platform job failures | Medium | keep | Logs and API responses are untrusted input. |
| `using-dbt-for-analytics-engineering` | dbt Labs | Build/modify dbt models | Medium | keep | Core data-workflow skill. |
| `using-dbt-index` | dbt Labs | Local dbt metadata index queries | Medium | keep | Install/update command uses external script; review before running. |
| `webapp-testing` | Anthropic skills | Local web app testing via Playwright | Medium | keep | Can launch local servers/browsers; keep scoped. |
| `web-artifacts-builder` | Anthropic skills, adapted | Complex local HTML artifacts | High | curated | Contains install scripts and destructive local cleanup in artifact directories; use only when needed. |
| `working-with-dbt-mesh` | dbt Labs | dbt Mesh governance | Low | keep | Domain-specific and low overlap. |

## Custom Agents

| Agent | Purpose | Sandbox | Decision | Notes |
| --- | --- | --- | --- | --- |
| `agents_md_maintainer` | Maintain project `AGENTS.md` files | workspace-write | keep | Use after conventions are validated. |
| `code_reviewer` | Read-only bug/regression review | read-only | keep | Findings first, no edits. |
| `dashboard_visualization_specialist` | Power BI, DAX, HTML Content, dashboards | workspace-write | keep | Use only for bounded visualization work. |
| `data_pipeline_engineer` | SQL, Databricks, dbt, validation | workspace-write | keep | High value for data workflows; keep ownership clear. |
| `data_science_modeler` | EDA, modeling, metrics | workspace-write | keep | Use for bounded analysis/modeling. |
| `local_skill_builder` | Create project-local skills | workspace-write | keep | Use only for recurring workflows. |
| `package_manager` | Dependencies, lockfiles, runtimes | workspace-write | keep | Avoid broad upgrades unless requested. |
| `security_auditor` | Threat modeling/security review | read-only | keep | Return reports to parent; do not edit product code. |
| `version_control_manager` | Git hygiene, commit, push | workspace-write | review | Useful for large change sets; often main agent can handle directly. |

## Capability Selection Rules

- Prefer built-in/system/plugin capabilities when they are current and sufficient.
- Prefer local skills only when they encode Manuel-specific conventions or fill a real gap.
- Do not invoke a custom agent if the main agent can complete the next step faster and safer.
- Do not add a new skill or agent until this inventory shows the gap.
- Review `review` and `curated` items quarterly.
