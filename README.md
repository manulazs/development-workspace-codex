# Development Workspace Codex

Private, reproducible workspace for Manuel's Codex configuration, custom skills, and agentic workflow conventions.

## Contents

- `skills/`: custom or adapted Codex skills.
- `.codex/agents/`: custom Codex subagents.
- `codex-global/`: templates for global Codex instructions.
- `docs/decisions/`: short technical decisions explaining why the workspace is structured this way.

## Current Skills

- `find-skills`: adapted from Vercel Labs' `find-skills` skill with two local rules:
  - check already-available skills before searching externally;
  - never install skills silently or with automatic confirmation unless explicitly approved.
- `migrate-to-codex`: official OpenAI skill for migrating supported instruction files, skills, agents, and MCP config into Codex project and global files.
- `plan-deep`: manual-only Plan Mode add-on for deep planning, insights, task cataloging, and subagent delegation recommendations.
- `plan-deep-skills`: manual-only Plan Mode add-on that extends `plan-deep` with local/external skill evaluation through `find-skills` and `migrate-to-codex`.
- `frontend-design`: migrated from Anthropic's frontend design skill through OpenAI's `migrate-to-codex` workflow.
- `pdf`: official OpenAI skill for reading, creating, and reviewing PDFs with layout fidelity.
- `screenshot`: official OpenAI skill for desktop and system screenshot capture.
- `spreadsheet`: OpenAI spreadsheet workflow reconstructed from the published `skills.sh` listing after the GitHub tree path was unavailable.
- `powerbi-expert`: community Power BI, DAX, Power Query, and report design skill from `personamanagmentlayer/pcl`, with Codex-valid frontmatter.
- `using-dbt-for-analytics-engineering`: dbt Labs skill for analytics engineering workflows.
- `adding-dbt-unit-test`: dbt Labs skill for dbt unit tests.
- `answering-natural-language-questions-with-dbt`: dbt Labs skill for semantic-layer business questions.
- `building-dbt-semantic-layer`: dbt Labs skill for semantic models, metrics, and dimensions.
- `configuring-dbt-mcp-server`: dbt Labs skill for dbt MCP setup and troubleshooting.
- `creating-mermaid-dbt-dag`: dbt Labs skill for Mermaid lineage diagrams.
- `fetching-dbt-docs`: dbt Labs skill for dbt documentation lookup.
- `running-dbt-commands`: dbt Labs skill for dbt CLI command usage.
- `troubleshooting-dbt-job-errors`: dbt Labs skill for dbt job failures.
- `working-with-dbt-mesh`: dbt Labs skill for dbt Mesh.
- `migrating-dbt-core-to-fusion`: dbt Labs migration skill for dbt Core to Fusion.
- `migrating-dbt-project-across-platforms`: dbt Labs migration skill for warehouse/platform migrations.
- `using-dbt-index`: dbt Labs extras skill for dbt index usage.
- `auditing-skills`: dbt Labs skill-auditing helper.
- `webapp-testing`: imported from Anthropic `skills`.
- `web-artifacts-builder`: imported from Anthropic `skills` and adapted to Codex/local HTML artifact wording.
- `theme-factory`: imported from Anthropic `skills`.
- `canvas-design`: imported from Anthropic `skills` and adapted to Codex wording.
- `agent-browser`: imported from Vercel Labs `agent-browser`, with Codex-valid frontmatter and non-overriding browser-tool guidance.
- `caveman`: imported from JuliusBrussee `caveman`.
- `caveman-compress`: imported from JuliusBrussee `caveman`.
- `caveman-commit`: imported from JuliusBrussee `caveman`.

## Current Custom Agents

- `agents_md_maintainer`: creates and maintains project `AGENTS.md` files.
- `dashboard_visualization_specialist`: supports dashboards, Power BI, DAX, HTML Content visuals, and analytical UI.
- `data_pipeline_engineer`: supports SQL, Databricks, dbt, joins, deduplication, validation, and analytics engineering.
- `data_science_modeler`: supports EDA, modeling, metrics, statistical validation, and reproducible analysis.
- `code_reviewer`: read-only reviewer that uses `codex review` when possible.
- `security_auditor`: security scan and threat-modeling specialist.
- `package_manager`: dependency, lockfile, version, and environment specialist.
- `local_skill_builder`: creates project-local skills for recurring workflows and asks before global promotion.
- `version_control_manager`: Git hygiene, commit, push, and repository state specialist.

## Reproduce Locally

From this repository root:

```bash
mkdir -p ~/.codex/skills
for skill in \
  find-skills \
  migrate-to-codex \
  plan-deep \
  plan-deep-skills \
  frontend-design \
  pdf \
  screenshot \
  spreadsheet \
  powerbi-expert \
  using-dbt-for-analytics-engineering \
  adding-dbt-unit-test \
  answering-natural-language-questions-with-dbt \
  building-dbt-semantic-layer \
  configuring-dbt-mcp-server \
  creating-mermaid-dbt-dag \
  fetching-dbt-docs \
  running-dbt-commands \
  troubleshooting-dbt-job-errors \
  working-with-dbt-mesh \
  migrating-dbt-core-to-fusion \
  migrating-dbt-project-across-platforms \
  using-dbt-index \
  auditing-skills \
  webapp-testing \
  web-artifacts-builder \
  theme-factory \
  canvas-design \
  agent-browser \
  caveman \
  caveman-compress \
  caveman-commit
do
  cp -R "skills/$skill" ~/.codex/skills/
done

mkdir -p ~/.codex/agents
cp .codex/agents/*.toml ~/.codex/agents/
```

Restart Codex after installing or updating skills so the new skill metadata is picked up.

## Repository Policy

This repository should remain private. It may contain workflow preferences and local environment conventions, but it must not contain credentials, tokens, logs, private data exports, or Codex internal state files.
