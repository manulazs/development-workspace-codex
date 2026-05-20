# Data Agent Pipeline

Last reviewed: 2026-05-20

This document maps the data-development pipeline to custom subagent templates. It is a routing aid for the main orchestrator, not permission to spawn every agent on every task.

## Pipeline Coverage

| Stage | Primary subagent | Purpose | Handoff signal |
| --- | --- | --- | --- |
| Discovery and research | `data_discovery_researcher` | Find and assess source systems, schemas, grain, owners, constraints, lineage evidence, and open questions. | Source inventory, evidence paths, blockers, and clear implementation questions. |
| Engineering and treatment | `data_pipeline_engineer` | Build or review SQL, dbt, Databricks, joins, deduplication, data quality, and transformation validation. | Validated dataset, known grain, quality checks, and impact notes. |
| Catalog, hierarchy, and organization | `data_catalog_taxonomist` | Structure catalog metadata, entity hierarchy, glossary, ownership, lineage docs, classifications, and discovery-ready docs. | Catalog updates or taxonomy proposal with owner decisions and validation notes. |
| Data science | `data_science_modeler` | Run EDA, feature reasoning, baselines, modeling, leakage checks, metrics, and reproducible statistical validation. | Reproducible analysis, model/metric validation, and interpretation limits. |
| Analysis and insight synthesis | `data_science_modeler` | Interpret validated datasets, explain segments/anomalies/KPIs, separate evidence from hypothesis, and produce decision-ready narratives. | Insight summary with caveats, confidence, and recommended visualization or action. |
| Visualization | `dashboard_visualization_specialist` | Build or review BI dashboards, Power BI/DAX, HTML analytical visuals, KPI layout, and analytical UI quality. | Validated visual changes, measure logic, screenshots/tests when available, and residual risks. |

## Routing Rules

- Use one agent when one stage is clearly dominant.
- Use multiple agents only when stages are independent and handoffs are explicit.
- Do not use a downstream agent before upstream grain, ownership, or validation blockers are clear.
- Do not create a generic analyst agent unless analysis work proves recurring and materially distinct from `data_science_modeler` and `dashboard_visualization_specialist`.
- Keep the main agent responsible for task framing, conflict resolution, final synthesis, commits, pushes, and user-facing decisions.
