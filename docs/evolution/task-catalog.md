# Continuous Evolution Task Catalog

Generated: 2026-05-24

This catalog is generated from repository-visible metadata. It guides the main agent; it does not authorize runtime-global writes, commits, pushes, or destructive actions by itself.

## Automation Levels

| Level | Meaning |
| --- | --- |
| `catalog-only` | Record status; no edit implied. |
| `auto-fix-proposal` | Automation may draft a change, but review is expected before persistence. |
| `auto-edit-allowed` | Repository-local edits are allowed when scope is narrow and validation passes. |
| `human-gated` | Human approval is required before applying or merging the change. |

## Tasks

| ID | Priority | Segment | Title | Owner | Subagents | Owner scope | Context budget | Return budget | Fork context | Automation | Human approval | Validation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| EVOL-OVERLAP-SKILL-plan-deep-plan-deep-skills | P2 | duplication-review | Review overlap between `plan-deep` and `plan-deep-skills`. | main-agent | code_reviewer | Repository-local task scope from title and evidence. | `small` | summary, evidence paths, validation status, residual risk, next action | `false` | `auto-fix-proposal` | no | `python scripts/evolve-workspace.py --strict` |

## Evidence

### EVOL-OVERLAP-SKILL-plan-deep-plan-deep-skills

Token similarity score 0.60 from names/descriptions.
