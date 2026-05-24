# Agent Template

Use this template before creating or materially changing a custom agent under `.codex/agents/`.

## Metadata

- Proposed name:
- Owner or maintainer:
- Created:
- Review date:
- Status: `core` | `optional` | `curated` | `review` | `deprecated` | `archived`

## Purpose

What recurring role this agent owns.

## Existing Capability Check

- Existing agents reviewed:
- Existing skills reviewed:
- Existing runbooks/patterns reviewed:
- Native/system/plugin capabilities reviewed:
- Why reuse is insufficient:

## Scope

- Read scope:
- Write scope:
- Explicitly out of scope:
- Consumer workspace assumptions:

## Model And Permissions

- Suggested model class:
- Fallback if unavailable:
- Suggested reasoning level:
- Sandbox mode:
- Network need:
- Escalation risk:
- Fast-mode policy: never use `/fast`; use normal 1:1 subagent execution only.
- Sensitive data risk:

## Inputs And Outputs

- Required input context:
- Expected output:
- Validation signal:
- Handoff back to orchestrator:
- Exit criteria:

## Use Rules

- Good use cases:
- Bad use cases:
- Required preconditions:
- When the main agent should keep the work local:
- Whether this role may be recommended only, spawned, created, persisted, or installed:

## Risks

- Overlap risk:
- Safety risk:
- Maintenance risk:
- Over-delegation risk:
- Retirement trigger:

## Manifest And Inventory Update

- Manifest status:
- Adoption profiles:
- Inventory row:
- Agentic controls affected:
- Last validation:
