# Continuous Evolution

Last reviewed: 2026-05-19

This repository supports governed continuous evolution: agents may catalog tasks, segment work, update repository-local skills or agents when criteria are met, delegate bounded work to subagents, validate results, and record decisions. It is not permission for unbounded runtime-global mutation.

## Autonomy Levels

| Level | Meaning | Example |
| --- | --- | --- |
| `catalog-only` | Record state without editing behavior. | Refresh `docs/evolution/task-catalog.md`. |
| `auto-fix-proposal` | Draft or recommend a change, then review before persistence. | Propose merging overlapping skills. |
| `auto-edit-allowed` | Apply narrow repository-local edits when validation is clear. | Add missing manifest, inventory, or provenance entries for a new skill. |
| `human-gated` | Require explicit user approval before applying or merging. | Change core capability status, global runtime behavior, security policy, or installer behavior. |
| `forbidden` | Do not automate. | Commit secrets, delete user work, push without requested final validation, or change repository visibility. |

## Execution Model

Continuous evolution follows `observe -> propose -> apply`.

- `observe`: automatic catalog generation, validation, and read-only analysis.
- `propose`: generate task entries, plans, or patches for review.
- `apply`: modify repository-local files only when the user has authorized implementation and the task is not human-gated.

Runtime-global paths are manual-only. Automation must not write to `~/.codex`, install profiles into a live runtime, run installer live mode, or use `migrate-to-codex` against a global target unless the user gives a separate explicit approval for that operation.

Forbidden inputs for automatic lesson, skill, or agent generation include `~/.codex/auth.json`, `~/.codex/sessions/`, `~/.codex/cache/`, `logs_*.sqlite`, `state_*.sqlite`, `.env`, browser cookies, tokens, private keys, and private corporate data.

## Task Segmentation

Evolution work should be cataloged into these segments:

| Segment | Typical owner | Subagent candidates | Human gate |
| --- | --- | --- | --- |
| Manifest integrity | Main agent | `code_reviewer` | No, unless core profile behavior changes. |
| Inventory integrity | Main agent | `agents_md_maintainer` | No, unless risk classification changes materially. |
| Skill provenance | Main agent | `security_auditor` | Yes for core skills, external licenses, or redistribution claims. |
| Profile safety | Main agent | `security_auditor` | Yes. |
| Duplication review | Main agent | `explorer`, `code_reviewer` | Yes when deleting, archiving, or merging. |
| Skill evolution | `local_skill_builder` or main agent | `local_skill_builder`, `security_auditor` | Yes for global/public promotion. |
| Agent evolution | Main agent | `agents_md_maintainer`, `security_auditor` | Yes for new persistent agents or permission changes. |
| Validation | Main agent | `code_reviewer`, `security_auditor` | No, unless validation changes policy. |
| Pruning | Main agent | `code_reviewer` | Yes when removing reusable capabilities. |

## Orchestrator Protocol

Before delegation, the main agent sends a compact brief:

```text
Objective:
Why delegation:
Read scope:
Write scope:
Out of scope:
Constraints:
Expected output:
Validation signal:
Risk:
Stopping criteria:
```

Subagents return:

```text
Result:
Evidence:
Files changed:
Residual risk:
Recommended next action:
```

The main agent integrates outputs, resolves conflicts, runs validation, and decides what reaches the user.

## Anti-Duplication Rules

- Prefer modifying existing skills or agents over creating new ones.
- Create a new skill only when the workflow is recurring, reusable, and not already covered by existing skills, docs, runbooks, system skills, or plugins.
- Create a new agent only when the responsibility is a stable role with independent ownership and permission posture.
- If two capabilities overlap, record the decision: merge, keep both with clear boundaries, reclassify, or archive one.
- Run `python scripts/evolve-workspace.py --strict` before claiming the workspace is structurally ready.

## Installer Safety

Profile installers are allowed in automation only as dry-run or `-WhatIf` previews. Live runtime adoption remains a consumer operation until installers provide conflict summaries and explicit overwrite controls such as diff/hash reporting, backup, and no-clobber behavior.

## Commit And Push Cadence

When the user asks for commits during evolution:

- commit coherent validated batches;
- do not mix unrelated user changes with the evolution batch unless they are already part of the requested workspace update;
- run full validation before the final push;
- push only after all required validation passes.
