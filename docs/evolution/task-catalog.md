# Continuous Evolution Task Catalog

Generated: 2026-05-25

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
| EVOL-STEADY-STATE | P3 | maintenance | No structural evolution tasks detected. | main-agent | - | Repository-local task scope from title and evidence. | `small` | summary, evidence paths, validation status, residual risk, next action | `false` | `catalog-only` | no | `bash scripts/healthcheck.sh --strict` |

## Evidence

### EVOL-STEADY-STATE

Manifest, inventory, profiles, and overlap checks found no immediate gaps.
