# Executive Summary

## Positioning

Development Workspace Codex is a public, portable Codex workspace template. It is designed for people who want Codex to work with more structure than a loose prompt folder: reusable skills, governed subagents, profile-based installation, cross-platform setup, validation scripts, provenance notes, and a continuous-improvement process.

The repository is not a private runtime dump. It is the source of truth for what a consumer may adopt. Local runtime state such as `~/.codex`, sessions, caches, logs, credentials, private observations, and local machine drift stay outside repository scope.

## What The Workspace Solves

This project addresses five recurring problems in agentic development:

1. Workspace drift: skills, instructions, and agents get copied manually and stop matching each other.
2. Unsafe automation: agents can be useful, but unrestricted writes, installs, MCPs, and runtime changes create risk.
3. Token waste: large instructions, repeated context, and unfocused subagent handoffs consume budget without improving output.
4. Poor reuse: recurring fixes stay trapped in chat history instead of becoming skills, runbooks, policies, or validation.
5. Weak public portability: many local agent setups cannot be safely cloned by another user because they depend on private runtime state.

This repository turns those problems into explicit architecture: profiles, inventory, provenance, validation, lifecycle docs, context budgets, and human gates.

## Current Operating Model

The workspace has three separate layers:

| Layer | Role | Owned by |
| --- | --- | --- |
| Public repository | Versioned template with skills, agents, docs, scripts, decisions, and install profiles. | Git |
| Consumer workspace | A project or fork that selects what to adopt. | Consumer |
| Local runtime | `~/.codex` skills, agents, sessions, auth, caches, and private state. | Local user |

Repository health is measured only against the public template. A missing or different local runtime is not a repository failure.

## Core Assets

The repository currently provides:

- Skills under `skills/` for planning, migration, auditing, continuous evolution, Caveman LITE, context budget review, verification, dbt workflows, Power BI, frontend design, PDF/spreadsheet work, and browser/app testing.
- Subagent templates under `.codex/agents/` for code review, QA, security, documentation, project instructions, dependency work, version-control work, general implementation, frontend UI, API/backend, test automation, data discovery, data engineering, cataloging, data science, and dashboard/BI work.
- Adoption profiles in `workspace-manifest.json` that define which skills and agents a consumer may install.
- Public governance docs under `docs/` for self-improvement, agentic controls, subagent routing, lifecycle management, provenance, MCP policy, runbooks, audits, lessons, patterns, and decisions.
- Validation scripts under `scripts/` for repository health, skill validation, observation validation, Caveman LITE validation, context-budget analysis, workspace doctor checks, and profile install previews.

## Adoption Profiles

Profiles make adoption explicit and reversible:

| Profile | Purpose |
| --- | --- |
| `minimal` | Evaluate or fork the public template without copying runtime-loadable skills or agents. |
| `governed-codex` | Core governed Codex workspace: planning, audit, migration, Caveman LITE, validation, review, QA, security, and implementation fallback. |
| `data-bi` | Data discovery, analytics engineering, dbt, BI, dashboard, catalog, and data science workflows. |
| `frontend-artifacts` | Frontend UI, local artifacts, browser validation, and webapp testing. |
| `full-reviewed` | All core and optional capabilities approved for broad adoption. |

Statuses keep risky or non-general capabilities out of default installs:

- `core`: broad governance capability.
- `optional`: domain-specific or workflow-specific capability.
- `curated`: source material only, not default install.
- `review`: useful but requires explicit review.
- `deprecated` or `archived`: not adopted.

## How It Works In Practice

Typical evaluation flow:

```bash
git clone https://github.com/manulazs/development-workspace-codex.git
cd development-workspace-codex
scripts/healthcheck.sh --strict
scripts/install-workspace.sh --list-profiles
scripts/install-workspace.sh --profile governed-codex --dry-run
```

Typical maintenance flow:

```bash
python scripts/evolve-workspace.py --write-catalog --write-report
python scripts/analyze-context-budget.py --repo . --profile full-reviewed
python scripts/workspace-doctor.py --repo . --profile full-reviewed
python scripts/validate-skills.py --strict
bash scripts/healthcheck.sh --strict
```

The installer is preview-first. It copies only the selected profile, skips existing runtime files unless forced, and never installs `curated`, `review`, `deprecated`, or `archived` capabilities by default.

## Agentic Model

The main Codex agent remains the orchestrator. It plans, decides, integrates, validates, and owns user-facing output.

Subagents are used when they reduce context load, improve independent validation, isolate domain work, or safely parallelize bounded tasks. They are not used just because they exist.

Routing precedence:

1. Use the main agent for simple, low-context, tightly coupled work.
2. Use a specialist subagent when the task fits a stable domain: security, QA, docs, packages, Git, frontend, API/backend, data, BI, tests, or project instructions.
3. Use `workspace_implementer` for scoped practical implementation only when no specialist is a better fit and delegation saves context or tokens.
4. Use multiple subagents only for disjoint workstreams with clear scopes and low conflict risk.

Subagents must not use `/fast`. They receive compact context packages and return concise evidence, changed files, validation status, residual risk, and next action.

## Planning Model

`plan-deep` and `plan-deep-skills` separate planning from implementation:

- In planning mode, they do not edit files, install packages, or spawn subagents.
- They may recommend implementation-time subagents when tasks are separable.
- Final plans can include a `Task Delegation Matrix` and a `Subagent Execution Plan`.
- During later implementation, the main agent may spawn recommended subagents according to tools, permissions, and active instructions.

This avoids treating "owner" labels as vague roles. Plans become operational handoffs without bypassing runtime authorization.

## Continuous Improvement Model

The improvement loop is:

```text
use -> observe -> lesson -> pattern -> skill/agent/doc -> validate -> review -> prune
```

For session-level observations, the Codex-native task-observer adaptation uses private local paths:

```text
.codex-local/evolution/observations/log.md
.codex-local/evolution/observations/cross-cutting-principles.md
.codex-local/evolution/staged-updates/YYYY-MM-DD/
```

Public templates live in `docs/evolution/templates/`. Real private observations are ignored by Git.

Observation statuses are:

- `OPEN`
- `ACTIONED`
- `DECLINED`
- `SUPERSEDED`

Cross-cutting principles require at least two observations or an explicit ADR. This prevents one-off preferences from becoming permanent rules.

## Validation And Safety

The standard healthcheck validates:

- required directories and docs;
- manifest and profile consistency;
- skill frontmatter;
- agent TOML;
- inventory and provenance coverage;
- installer preview support;
- secret-pattern checks;
- observation template rules;
- Caveman LITE contract;
- context-budget analysis;
- workspace-doctor drift checks;
- bytecode-free Python syntax validation.

The repository also keeps a clear public/private boundary:

- No `.env`, auth files, sessions, caches, local sqlite logs, or private runtime state should be tracked.
- MCPs are governed by policy and review; the repo does not install MCPs by default.
- Runtime-global writes to `~/.codex` require explicit user approval.
- Security, destructive operations, repository visibility, public-distribution claims, pruning, and core capability changes are human-gated.

## Caveman LITE

Caveman LITE is the default communication standard for this workspace. It means concise, direct, professional, and technically precise. It reduces response noise while keeping full clarity.

The upstream Caveman skill remains intact. Mandatory default behavior comes from `AGENTS.md` and the exported `codex-global/AGENTS.md` template. A consumer runtime needs both the skill and the global instruction template if it wants the same behavior.

## Recent Major Changes

Recent improvements established:

- profile-based installation through `workspace-manifest.json`;
- mandatory Caveman LITE communication policy;
- governed continuous evolution with catalog/report generation;
- task-observer-style private observations;
- planning skills that create implementation-time subagent execution plans;
- subagent context budgets and compact return contracts;
- flexible multi-subagent routing;
- `workspace_implementer` as a scoped implementation fallback;
- frontend/API specialists;
- `docs_researcher` and `test_automation_engineer`;
- context-budget audit and verification-loop skills;
- read-only context-budget and workspace-doctor scripts;
- MCP governance adapted from ECC ideas without importing hooks or runtime configs.

## Why It Is Useful

For an individual developer, the workspace reduces repeated setup and makes Codex behavior predictable.

For a team, it creates shared operating rules for skills, agents, validation, security, and documentation.

For a public template, it gives others a safe starting point: they can inspect what is included, choose a profile, preview installation, validate the repository, and adapt only what they need.

The project is intentionally opinionated about governance, but not locked to one private machine. That is the core value: reusable agentic productivity with visible controls.

## Current Maturity

The workspace is advanced as a public Codex template. It has real profiles, scripts, healthchecks, subagents, skills, docs, decisions, provenance, and lifecycle rules.

It is not fully autonomous. Self-improvement is governed: the workspace can catalog, propose, validate, and implement authorized repository-local changes, but sensitive actions remain human-gated.

That tradeoff is deliberate. The repository optimizes for useful automation that remains inspectable, portable, and safe for public reuse.
