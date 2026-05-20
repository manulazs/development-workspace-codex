# Capability Proposal: data_catalog_taxonomist

Date: 2026-05-20
Kind: `agent`
Status: `optional`

## Purpose

Specialist for data catalog structure, entity hierarchy, glossary terms, metadata standards, lineage organization, stewardship, and discovery-ready documentation.

## Existing Capability Check

- Existing agents reviewed: `data_pipeline_engineer`, `data_science_modeler`, `dashboard_visualization_specialist`.
- Existing skills reviewed: dbt semantic layer, Mermaid DAG, Power BI, and continuous-evolution skills.
- Why reuse is insufficient: existing data agents validate transformations, model data, or build visualizations. None owns taxonomy, glossary, ownership metadata, catalog hierarchy, and lineage documentation as a bounded role.

## Automation Decision

- `proposal`: safe to review without runtime effects.
- `apply`: allowed because the role is optional, evidence-backed, and non-duplicative.

## Required Follow-Up

- Include the agent in the `data-bi` profile.
- Validate with `python3 skills/migrate-to-codex/scripts/cli.py --validate-target .`.
- Validate with `python3 scripts/evolve-workspace.py --strict`, `python3 scripts/validate-skills.py --strict`, and `bash scripts/healthcheck.sh --strict`.
