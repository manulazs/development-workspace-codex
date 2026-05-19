# 0006 - Add Planning Skills And Subagents

Status: updated by the current public-template subagent policy. The reusable outcome remains valid; personal/runtime-specific wording is superseded.

## Decision

Add two manual-only planning skills and a first set of reusable custom Codex subagent templates.

## Changes

- Added `plan-deep` for context-grounded Plan Mode analysis and delegation planning.
- Added `plan-deep-skills` for the same workflow plus skill inventory, `$find-skills`, and `$migrate-to-codex` routing.
- Added custom agents under `.codex/agents/` for AGENTS.md maintenance, dashboards, data pipelines, data science, review, security, package management, and version control.
- Kept orchestration in the main Plan Mode model instead of creating a separate orchestrator agent.
- Added a global instruction to create or update project `AGENTS.md` when starting new projects or substantial work.

## Notes

The planning skills are manual-only by design. Normal planning requests should not trigger them unless the user explicitly invokes `$plan-deep` or `$plan-deep-skills`.

The specific model names recorded here are historical. Current guidance should choose models by task risk, complexity, and consumer availability.
