# Continuous Evolution

Last reviewed: 2026-05-24

This repository supports governed continuous evolution: agents may catalog tasks, segment work, write evolution reports, update repository-local skills or agents when criteria are met, delegate bounded work to subagents, validate results, and record decisions. It is not permission for unbounded runtime-global mutation.

Use `docs/subagent-context-protocol.md` whenever evolution work routes to subagents. The default optimization target is lower net context load, not maximum delegation count.

## Autonomy Levels

| Level | Meaning | Example |
| --- | --- | --- |
| `catalog-only` | Record state without editing behavior. | Refresh `docs/evolution/task-catalog.md` and an evolution report. |
| `auto-fix-proposal` | Draft or recommend a change, then review before persistence. | Propose merging overlapping skills. |
| `auto-edit-allowed` | Apply narrow repository-local edits when validation is clear. | Add missing manifest, inventory, or provenance entries for a new skill. |
| `human-gated` | Require explicit user approval before applying or merging. | Change core capability status, global runtime behavior, security policy, or installer behavior. |
| `forbidden` | Do not automate. | Commit secrets, delete user work, push without requested final validation, or change repository visibility. |

## Execution Model

Continuous evolution follows `observe -> propose -> apply`.

- `observe`: automatic catalog generation, optional validation snapshots, generated reports, and read-only analysis.
- `propose`: generate task entries, plans, capability proposals, or patches for review.
- `apply`: modify repository-local files only when the user has authorized implementation, duplicate checks pass, and the task is not human-gated.

Runtime-global paths are manual-only. Automation must not write to `~/.codex`, install profiles into a live runtime, run installer live mode, or use `migrate-to-codex` against a global target unless the user gives a separate explicit approval for that operation.

Forbidden inputs for automatic lesson, skill, or agent generation include `~/.codex/auth.json`, `~/.codex/sessions/`, `~/.codex/cache/`, `logs_*.sqlite`, `state_*.sqlite`, `.env`, browser cookies, tokens, private keys, and private corporate data.

## Task Segmentation

Evolution work should be cataloged into these segments:

| Segment | Typical owner | Subagent candidates | Human gate |
| --- | --- | --- | --- |
| Manifest integrity | Main agent | `code_reviewer` | No, unless core profile behavior changes. |
| Inventory integrity | Main agent | `agents_md_maintainer` | No, unless risk classification changes materially. |
| Skill provenance | Main agent | `security_auditor` | No for repository skill use; yes for external redistribution claims or license changes. |
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
Context budget:
Read scope:
Write scope:
Out of scope:
Inputs:
Constraints:
Expected output:
Validation signal:
Risk:
Stopping criteria:
Return budget:
```

Subagents return:

```text
Result:
Evidence:
Files changed:
Validation:
Residual risk:
Recommended next action:
```

The main agent integrates outputs, resolves conflicts, runs validation, and decides what reaches the user. Subagents should summarize large logs or reads instead of returning raw dumps. If the parent only needs a decision, the subagent should return the decision, evidence paths, and residual risk.

## Context Efficiency Rules

- Prefer `fork_context: false` unless the full conversation is essential.
- Send bounded file lists, command outputs, acceptance criteria, and policy snippets instead of the whole repo or thread.
- Give each subagent one owner scope and one output format.
- Keep implementation subagents on disjoint write scopes.
- Use read-only review subagents after a diff or acceptance criteria exists.
- Close subagents after their output is integrated or rejected.
- Treat repeated verbose handoffs as a signal to update a skill, runbook, or policy.

## Anti-Duplication Rules

- Prefer modifying existing skills or agents over creating new ones.
- Create a new skill only when the workflow is recurring, reusable, and not already covered by existing skills, docs, runbooks, system skills, or plugins.
- Create a new agent only when the responsibility is a stable role with independent ownership and permission posture.
- If two capabilities overlap, record the decision: merge, keep both with clear boundaries, reclassify, or archive one.
- Run `python scripts/evolve-workspace.py --strict` before claiming the workspace is structurally ready.
- Run `python scripts/evolve-workspace.py --write-catalog --write-report` during recurring maintenance to leave a current task map and report.
- Add `--run-validation` only when a report should capture a bounded validation snapshot. Healthchecks call `evolve-workspace.py --strict` without validation recursion.

## Capability Scaffolding

Use `scripts/scaffold-capability.py` when a recurring workflow or role may deserve a new skill or agent.

Proposal mode is safe and non-runtime-loadable:

```bash
python scripts/scaffold-capability.py skill --name example-skill --purpose "Reusable example workflow." --mode proposal --dry-run
```

Apply mode creates repository-local files and updates baseline metadata, but it is blocked by default when a capability already exists, overlap is detected, or `core` status lacks explicit human approval:

```bash
python scripts/scaffold-capability.py skill --name example-skill --purpose "Reusable example workflow." --status optional --mode apply --dry-run
```

Do not use scaffolding to bypass the inventory, provenance, manifest, validation, or human-gate requirements.

## Installer Safety

Profile installers are allowed in automation only as dry-run or `-WhatIf` previews. Live runtime adoption remains a consumer operation until installers provide conflict summaries and explicit overwrite controls such as diff/hash reporting, backup, and no-clobber behavior.

## Commit And Push Cadence

When a project has an initialized Git repository and implementation work is authorized:

- create coherent commits as meaningful milestones emerge, instead of leaving all work in one final commit;
- do not mix unrelated user changes with the evolution batch unless they are already part of the requested workspace update;
- run full validation before the final push;
- push only after required validation/review passes and the user explicitly confirms that final push.
