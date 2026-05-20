---
name: continuous-evolution
description: Governed workspace evolution workflow for cataloging tasks, improving skills and agents, preventing duplicates, routing subagents, validating quality, and preserving human approval gates for core or sensitive changes.
metadata:
  short-description: Governed continuous workspace evolution
---

# Continuous Evolution

Use this skill when the user asks the workspace to keep improving itself, evolve skills or agents, catalog improvement tasks, reduce duplication, or orchestrate subagents for repository maintenance.

This skill enables governed automation, not unbounded self-mutation. Repository-local edits are allowed when the user has asked for implementation, scope is clear, and validation can run. Human approval remains required for core or sensitive changes.

## Operating Loop

1. Ground in repository policy.
   - Read `AGENTS.md`, `workspace-manifest.json`, `docs/capability-inventory.md`, `docs/skills-provenance.md`, `docs/agentic-controls.md`, and `docs/self-improvement-lifecycle.md`.
   - Respect dirty worktrees. Do not revert unrelated changes.

2. Build the task catalog.
   - Run `python scripts/evolve-workspace.py --write-catalog`.
   - Treat `docs/evolution/task-catalog.md` as the current task map.
   - Segment tasks by manifest integrity, inventory integrity, provenance, profile safety, duplication review, validation, docs, and pruning.
   - Treat installer safety and runtime-global boundaries as human-gated.

3. Decide automation level.
   - `catalog-only`: record status only.
   - `auto-fix-proposal`: draft the change, then review before persistence.
   - `auto-edit-allowed`: edit repository files when the scope is narrow and validation is available.
   - `human-gated`: stop before applying or merging until the user approves.

4. Follow `observe -> propose -> apply`.
   - `observe` can run automatically against repository files.
   - `propose` can create task catalog entries, plans, or reviewable patches.
   - `apply` can modify repository-local files only when the user authorized implementation and the task is not human-gated.
   - Never write to `~/.codex`, install profiles live, or run migration writes against a global runtime as an implied side effect.
   - Use `python scripts/scaffold-capability.py ... --mode proposal` before creating a new skill or agent.
   - Use `--mode apply` only when duplicate checks pass and required human gates are satisfied.

5. Avoid duplication before creating anything.
   - Check existing skills, agents, runbooks, patterns, docs, system skills, and plugin capabilities.
   - Modify an existing skill or agent when the responsibility already exists.
   - Create a new skill only for a recurring reusable workflow not covered elsewhere.
   - Create a new subagent only for a recurring role with independent ownership, permission posture, and exit criteria.

6. Route work to subagents only when useful.
   - Keep the immediate critical path in the main thread.
   - Use `explorer` for bounded read-only repository questions.
   - Use `local_skill_builder` for narrow local skill creation or updates.
   - Use `agents_md_maintainer` for instruction-file maintenance.
   - Use `code_reviewer` after implementation diffs exist.
   - Use `security_auditor` for provenance, secret, runtime, installer, or automation-risk review.
   - Do not ask similar agents to solve the same task.

7. Maintain the handoff protocol.
   - Send objective, justification, read scope, write scope, out-of-scope items, constraints, expected output, validation signal, risks, and stopping criteria.
   - Require subagents to cite changed files when they edit, or evidence paths when read-only.
   - The main agent integrates outputs and owns final decisions.

8. Validate and commit in batches when requested.
   - Run targeted validation after each material batch.
   - Run full validation before final push: `python scripts/evolve-workspace.py --strict`, `python scripts/validate-skills.py --strict`, `bash scripts/healthcheck.sh --strict`, install dry-run, and relevant skill validators.
   - Commit coherent validated batches when the user has explicitly asked for commits.
   - Push only after final validation and only when the user asked for push.

## Human Gates

Require explicit human approval before:

- writing to `~/.codex` or another runtime-global path;
- running profile installers in live mode against a real runtime;
- using `migrate-to-codex` to write into a global target;
- committing or pushing when the user did not explicitly request it;
- changing repository visibility, remotes, licenses, or security policy;
- deleting, archiving, or demoting core capabilities;
- adding external network execution, credential handling, or destructive scripts;
- creating a new subagent when an existing agent can reasonably be modified;
- promoting a local skill into global or public adoption.

## Required Updates

When a skill changes, update:

- `workspace-manifest.json`;
- `docs/capability-inventory.md`;
- `docs/skills-provenance.md`;
- `docs/evolution/task-catalog.md` through the evolution script;
- validation docs or runbooks when commands change.

For new skills, prefer `scripts/scaffold-capability.py` so creation, duplicate checks, manifest updates, inventory rows, and provenance rows stay aligned.

When an agent changes, update:

- `workspace-manifest.json`;
- `docs/capability-inventory.md`;
- `docs/subagents-policy.md` or `docs/subagents-lifecycle.md` when the policy changes;
- `docs/evolution/task-catalog.md` through the evolution script.

For new agents, prefer `scripts/scaffold-capability.py` so creation, duplicate checks, manifest updates, and inventory rows stay aligned.
