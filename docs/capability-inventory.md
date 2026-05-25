# Capability Inventory

Last reviewed: 2026-05-24

This inventory describes repository capabilities: skills, subagent templates, docs, and scripts that a consumer workspace may choose to adopt. It does not describe what is installed in any local Codex runtime.

`workspace-manifest.json` is the machine-readable source for adoption profiles and status classification. This document is the human-readable source for purpose, risk, overlap, and usage guidance. `docs/skills-provenance.md` records skill source, license, attribution, and script or asset risk as informational provenance.

## Status Values

| Status | Meaning | Default adoption |
| --- | --- | --- |
| `core` | Broadly useful governance capability with low ambiguity. | Included in governed profiles. |
| `optional` | Useful for specific domains or workflows. | Included only by relevant profiles. |
| `curated` | Kept as reference/source material or examples. | Never installed by default. |
| `review` | Potentially useful but overlapping, risky, personal, or insufficiently generalized. | Requires explicit review before adoption. |
| `deprecated` | Superseded and retained only for migration context. | Do not adopt. |
| `archived` | Retired from runtime-loadable paths. | Do not adopt. |

There is intentionally no `installed locally` field. Local runtime state belongs to the consumer workspace, not this public repository.

## Adoption Profiles

| Profile | Intended consumer | Includes | Excludes | Validation |
| --- | --- | --- | --- | --- |
| `minimal` | Evaluators, forks, and docs-only consumers | Policies, templates, docs, healthchecks | Runtime skill/agent copying | Repository healthcheck |
| `governed-codex` | General governed Codex workspace | Core planning, audit, migration, caveman-lite communication, review agents | Domain-specific and review capabilities | Repository healthcheck plus install preview |
| `data-bi` | Data discovery, analytics engineering, dbt, BI, dashboard, and data science workspaces | Governed base plus data/BI skills and agents covering discovery, engineering, cataloging, science, analysis, and visualization | UI artifact and review capabilities | Repository healthcheck plus domain validation |
| `frontend-artifacts` | Frontend app and artifact workflows | Governed base plus frontend testing/design skills | Curated art-heavy builders | Repository healthcheck plus browser/app tests |
| `full-reviewed` | Broad adoption after capability review | Core and optional capabilities | `curated`, `review`, `deprecated`, `archived` | Repository healthcheck plus profile preview |

## Skill Inventory

| Capability | Status | Origin | Purpose | Risk | Platforms | Use when | Do not use when |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `adding-dbt-unit-test` | `optional` | dbt Labs | Author dbt unit tests. | Low | Cross-platform | A workspace actively maintains dbt models and needs test coverage. | The project does not use dbt. |
| `agent-browser` | `review` | Vercel Labs | Specialized browser automation CLI workflows. | Medium | Cross-platform with tool dependencies | A task specifically requires this CLI behavior. | Built-in browser tooling or Playwright already covers the need. |
| `answering-natural-language-questions-with-dbt` | `optional` | dbt Labs | Answer data questions using dbt project context. | Medium | Cross-platform | The workspace has dbt metadata and safe query access. | The request needs current facts but no validated data source is available. |
| `auditing-skills` | `core` | dbt Labs | Audit skill quality, overlap, and security posture. | Low | Cross-platform | Reviewing skill changes or public readiness. | A simple docs typo is being fixed. |
| `building-dbt-semantic-layer` | `optional` | dbt Labs | Build dbt semantic models and metrics. | Low | Cross-platform | The workspace uses dbt semantic layer concepts. | Metrics are owned by a different semantic layer. |
| `canvas-design` | `curated` | Anthropic skill, adapted | Static visual design/artifact references. | Medium | Cross-platform | Mining examples or adapting visual workflows after review. | Installing default public governance capabilities. |
| `caveman` | `core` | JuliusBrussee caveman | Mandatory concise communication standard using `caveman lite`; active-by-default behavior requires the global `AGENTS.md` template in addition to the skill. | Low | Cross-platform | Normal workspace communication should be direct, concise, and technically precise. | Safety, legal, destructive-operation, or complex multi-step clarity requires temporarily fuller prose. |
| `caveman-commit` | `review` | JuliusBrussee caveman | Commit-message helper with opinionated style. | Low | Cross-platform | A consumer explicitly adopts the style. | Normal git hygiene or templates are enough. |
| `caveman-compress` | `review` | JuliusBrussee caveman | Compress memory-like text in a specific style. | Medium | Cross-platform | A consumer explicitly uses that memory format. | Native context compaction or normal summaries are sufficient. |
| `configuring-dbt-mcp-server` | `optional` | dbt Labs | Configure and troubleshoot dbt MCP setup. | Medium | Cross-platform | The workspace uses dbt MCP and has safe credential handling. | Credentials would need to be stored in repo. |
| `continuous-evolution` | `core` | Local template | Governed task cataloging, anti-duplication, subagent routing, validation, and human-gated workspace evolution. | Medium | Cross-platform | The workspace is being maintained as a self-improving Codex environment. | A one-off repo edit is enough or the user forbids automation. |
| `creating-mermaid-dbt-dag` | `optional` | dbt Labs | Generate Mermaid lineage diagrams from dbt context. | Low | Cross-platform | A dbt lineage diagram is useful for review or docs. | The project has no dbt lineage source. |
| `fetching-dbt-docs` | `optional` | dbt Labs | Fetch or search dbt documentation. | Low | Cross-platform | Current dbt documentation is relevant. | Offline-only operation is required and docs are unavailable. |
| `find-skills` | `core` | Vercel Labs, adapted | Discover, compare, and vet external skills. | Medium | Cross-platform | Considering a new skill or overlap review. | The task is already covered by existing repo capabilities. |
| `frontend-design` | `optional` | Anthropic skill, migrated | Frontend UI design guidance. | Low | Cross-platform | Building or reviewing frontend experiences. | A plugin-specific Figma/Canva workflow is the actual target. |
| `migrate-to-codex` | `core` | OpenAI | Migrate instructions, skills, agents, and config to Codex-compatible form. | Medium; can write selected target artifacts after explicit target selection | Cross-platform | Adapting non-Codex capability sources with plan, dry-run, doctor, and validation steps. | Installing an unreviewed external skill unchanged or writing to a global runtime without explicit approval. |
| `migrating-dbt-core-to-fusion` | `optional` | dbt Labs | Triage dbt Core to Fusion migration issues. | Medium | Cross-platform | A dbt Fusion migration is in scope. | No migration is being attempted. |
| `migrating-dbt-project-across-platforms` | `optional` | dbt Labs | Guide dbt project migration across data platforms. | Medium | Cross-platform | SQL/platform behavior changes need structured review. | The project is not changing platforms. |
| `pdf` | `optional` | OpenAI/curated | PDF creation and review workflows. | Low | Cross-platform | PDF handling is a recurring workspace need. | Built-in or plugin PDF capability is sufficient. |
| `plan-deep` | `core` | Local template | Manual deep planning, delegation matrix, and implementation-time subagent execution plan. | Low | Cross-platform | A user explicitly asks for deep planning before edits. | The user asked for direct implementation without a planning phase. |
| `plan-deep-skills` | `core` | Local template | Planning workflow that includes skill discovery and implementation-time subagent execution planning. | Low | Cross-platform | A plan needs capability selection, skill evaluation, or delegation planning. | No skill or subagent decision is involved. |
| `powerbi-expert` | `optional` | Community PCL | Power BI, DAX, M, modeling, and dashboard guidance. | Medium | Cross-platform | The consumer workspace does Power BI work. | A private local skill not versioned here is being assumed. |
| `running-dbt-commands` | `optional` | dbt Labs | Prepare and run dbt CLI commands safely. | Medium | Cross-platform | dbt commands are part of the requested work. | Broad warehouse or destructive operations lack approval. |
| `screenshot` | `review` | OpenAI/curated | OS screenshot workflows. | Medium | OS-sensitive | A task requires screenshots and privacy is acceptable. | A repository-only validation is enough. |
| `spreadsheet` | `optional` | OpenAI listing, reconstructed | Spreadsheet creation and editing workflows. | Low | Cross-platform | Spreadsheet artifacts are recurring outputs. | Native app/plugin workflow is better. |
| `theme-factory` | `curated` | Anthropic skill | Reusable visual theme source material. | Low | Cross-platform | Reviewing visual theme examples. | Installing default engineering governance profiles. |
| `troubleshooting-dbt-job-errors` | `optional` | dbt Labs | Diagnose dbt platform job failures. | Medium | Cross-platform | dbt job logs and metadata are available. | Logs contain sensitive values that cannot be safely redacted. |
| `using-dbt-for-analytics-engineering` | `optional` | dbt Labs | Build and modify dbt analytics engineering workflows. | Medium | Cross-platform | A workspace actively uses dbt. | The task is plain SQL or BI-only. |
| `using-dbt-index` | `optional` | dbt Labs | Query a local dbt metadata index. | Medium | Cross-platform | A dbt index exists or can be safely generated. | The setup command would fetch or write without approval. |
| `web-artifacts-builder` | `curated` | Anthropic skill, adapted | Build complex local HTML artifacts. | High | Cross-platform with dependencies | Reviewing or selectively adapting artifact workflows. | Default public profile installation. |
| `webapp-testing` | `optional` | Anthropic skill | Test local web apps with browser validation. | Medium | Cross-platform with browser tooling | A frontend app needs runtime verification. | No app server or browser validation is needed. |
| `working-with-dbt-mesh` | `optional` | dbt Labs | dbt Mesh governance workflows. | Low | Cross-platform | The workspace uses dbt Mesh. | Mesh is not part of the architecture. |

## Subagent Template Inventory

| Capability | Status | Purpose | Suggested model policy | Sandbox | Risk | Use when | Do not use when |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `agents_md_maintainer` | `core` | Maintain project `AGENTS.md` files. | Strong general/coding model when policy changes are subtle. | `workspace-write` | Medium | Project instructions need consistent updates. | A one-line docs edit is enough. |
| `code_reviewer` | `core` | Read-only bug, regression, and missing-test review. | Strong model with deeper reasoning for risky diffs. | `read-only` | Low | Independent review improves quality. | The main task is still blocked on implementation. |
| `dashboard_visualization_specialist` | `optional` | Dashboard, BI, DAX, HTML Content, and analytical UI support. | Strong visual/analytical model. | `workspace-write` | Medium | Visualization work is bounded and separate. | The change is pure backend or data modeling. |
| `data_catalog_taxonomist` | `optional` | Data catalog structure, entity hierarchy, glossary, metadata standards, lineage organization, stewardship, and discovery-ready documentation. | Strong analytical model for metadata architecture. | `workspace-write` | Medium | Catalog, hierarchy, glossary, lineage, ownership, or metadata organization needs a bounded owner. | The task is transformation implementation, modeling, or dashboard design. |
| `data_discovery_researcher` | `optional` | Read-only data source discovery, upstream research, schema reconnaissance, ownership, constraints, and evidence-backed handoff questions. | Strong analytical model for source research. | `read-only` | Low | Source systems, grain, ownership, freshness, access, or lineage are unclear before implementation. | The source contract is already known and implementation can start. |
| `data_pipeline_engineer` | `optional` | SQL, Databricks, dbt, joins, deduplication, validation. | Strong Codex-oriented model for implementation. | `workspace-write` | Medium | Data pipeline work has clear file ownership. | Validation requires credentials unavailable to the agent. |
| `data_science_modeler` | `optional` | EDA, modeling, metrics, reproducible analysis, and evidence-backed insight synthesis. | Strong analytical model. | `workspace-write` | Medium | Modeling, statistical validation, KPI interpretation, segmentation, anomaly analysis, or insight synthesis is independently scoped. | The task is deterministic transformation only. |
| `local_skill_builder` | `optional` | Create project-local skills from recurring workflows. | Strong model for instruction design. | `workspace-write` | Medium | A repeated pattern deserves a reusable skill. | A runbook or short policy is sufficient. |
| `markdown_writer` | `optional` | README, technical docs, executive summaries, changelogs, runbooks, and concise Markdown cleanup. | Smaller or mid-size model for bounded documentation work. | `workspace-write` | Medium | Documentation work is isolated and can be derived from evidence. | Product behavior or commands are not yet validated. |
| `package_manager` | `optional` | Dependencies, lockfiles, package upgrades, runtimes. | Strong Codex-oriented model for risky upgrades. | `workspace-write` | Medium | Dependency work is isolated and testable. | Broad upgrades are not requested. |
| `qa_reviewer` | `core` | Read-only acceptance criteria, test coverage, validation gap, release readiness, and residual-risk review. | Strong model with deeper reasoning for quality risks. | `read-only` | Low | Independent QA review can catch missed acceptance, test, or validation gaps. | No implementation or acceptance criteria exists yet. |
| `security_auditor` | `core` | Security review, threat modeling, and secret-risk analysis. | Strong model with high reasoning. | `read-only` | Low | Independent security review is needed. | The task is simple and no security-sensitive surface changed. |
| `version_control_manager` | `review` | Git hygiene, commit preparation, push coordination. | Strong enough for repo-state reasoning. | `workspace-write` | Medium | A consumer explicitly wants delegated git operations. | Commit/push would happen without explicit user request. |

## Capability Selection Rules

- Prefer `core` capabilities only when they reduce ambiguity or improve governance.
- Prefer `optional` capabilities only when the workspace domain justifies them.
- Do not install `curated`, `review`, `deprecated`, or `archived` capabilities through default profiles.
- Do not create a skill for a one-off task.
- Do not create a subagent when a skill, runbook, or main-agent workflow is enough.
- Treat provenance as informational evidence for source, attribution, license notes, and script or asset risk; do not use provenance rows to block authorized repository skills.
- Use `docs/agentic-controls.md` before moving from recommending a skill or subagent to spawning, creating, persisting, or installing it.
- Define precedence when two capabilities overlap; otherwise review, merge, or archive one.
- Keep private or machine-specific runtime state out of this inventory.

## Deprecation And Pruning

A capability should be deprecated, archived, or removed when:

- it duplicates a better native, plugin, skill, or agent capability;
- it has no demonstrated recurring use;
- its risk exceeds its operational value;
- its workflow is better represented as a runbook, pattern, or short instruction;
- it depends on personal preference that should not be public default policy.

Pruning should reduce complexity. Reviews that only add new capabilities without removing stale ones are incomplete.
