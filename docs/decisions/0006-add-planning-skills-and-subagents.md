# 0006 - Add Planning Skills And Subagents

## Decision

Add two manual-only planning skills and a first set of custom Codex subagents for Manuel's development workspace.

## Changes

- Added `plan-deep` for context-grounded Plan Mode analysis and delegation planning.
- Added `plan-deep-skills` for the same workflow plus skill inventory, `$find-skills`, and `$migrate-to-codex` routing.
- Added custom agents under `.codex/agents/` for AGENTS.md maintenance, dashboards, data pipelines, data science, review, security, package management, and version control.
- Kept orchestration in the main Plan Mode model instead of creating a separate orchestrator agent.
- Added a global instruction to create or update project `AGENTS.md` when starting new projects or substantial work.

## Notes

The planning skills are manual-only by design. Normal planning requests should not trigger them unless Manuel invokes `$plan-deep` or `$plan-deep-skills`.

The custom agents use a quality-balanced policy: `gpt-5.4` for critical analytical/review/security work and `gpt-5.4-mini` with `xhigh` reasoning for documentation, package management, and version control support.
