# Agentic Controls

Last reviewed: 2026-05-25

This document defines what the repository means by recommending, using, creating, and persisting skills or subagents. It is intentionally conservative: the public template can describe and validate governance, but the active Codex runtime still controls whether tools, subagents, or file writes are allowed.

Use `docs/continuous-evolution.md` for the automation boundary that connects these actions into a governed improvement loop.
Use `docs/subagent-context-protocol.md` for the context, return, and integration contract that keeps spawned subagents efficient.

## Subagent Control Matrix

| Action | Implemented by this repository? | Who decides at runtime? | Approval gate | Persistence |
| --- | --- | --- | --- | --- |
| Recommend a subagent | Yes, through `docs/subagents-policy.md`, `$plan-deep`, and `$plan-deep-skills`. | Main agent. | User/developer/runtime instructions decide whether recommendation is enough. | None. |
| Spawn a subagent | No. This repository only provides templates and policy. | Active Codex runtime and main agent. | Required when runtime or user instructions demand it. | None unless the subagent edits files. |
| Create a new subagent template | Documented, not automatic. | Maintainer or implementation agent acting under explicit task scope. | Must pass existing-capability review, manifest/inventory update, and validation. | `.codex/agents/<name>.toml`. |
| Persist a subagent into a consumer runtime | Installer can copy selected profiles; manual copy is possible. | Consumer. | Explicit profile selection or explicit manual adoption. | Consumer `~/.codex/agents`, outside repository health. |
| Retire a subagent | Documented, not automatic. | Maintainer. | Must update manifest, inventory, archive notes when useful, and validation. | Move outside `.codex/agents` if retained historically. |

## Skill Control Matrix

| Action | Implemented by this repository? | Who decides at runtime? | Approval gate | Persistence |
| --- | --- | --- | --- | --- |
| Recommend an existing skill | Yes, through `find-skills`, inventory, and planning docs. | Main agent. | No install approval needed when the skill already exists in the active session. | None. |
| Search externally for a skill | Policy-supported, not automatic. | Main agent after checking local/session/system/plugin skills. | Network and install approvals follow active runtime policy. | None. |
| Create a project-local skill | Assisted by `local_skill_builder`; not automatic. | Main agent or delegated local skill builder. | Recurrence and overlap checks required. | Consumer project-local skill path. |
| Add a repository skill | Documented, not automatic. | Maintainer or implementation agent under explicit task scope. | Must update `workspace-manifest.json`, inventory, provenance, and validation. | `skills/<name>/SKILL.md`. |
| Promote a local skill globally | Not automatic. | Consumer or maintainer. | Explicit human approval required. | Shared repository or consumer runtime. |
| Install a profile into `~/.codex` | Installer supports it. | Consumer. | Explicit command with selected profile; preview first. | Consumer `~/.codex/skills`, outside repository health. |

## Hard Rules

- The repository may recommend delegation, but it does not authorize spawning by itself.
- A `Subagent Execution Plan` in a planning-skill output is an implementation-time recommendation. It is stronger than a role label, but it still depends on active runtime tools, permissions, and user/developer instructions before any spawn occurs.
- `workspace_implementer` is a fallback implementation subagent, not a default replacement for the main agent or specialized subagents. It may be recommended only for scoped practical edits when no specialist is a better owner.
- `frontend_ui_engineer` and `api_backend_engineer` are specialist owners. Route frontend web UI or API/backend work to them before considering `workspace_implementer`.
- When no specialist is a better owner, `workspace_implementer` should be recommended for scoped implementation if the expected benefit is lower parent-context load, lower token use, or cleaner implementation isolation.
- Multiple `workspace_implementer` instances may be recommended or spawned only for disjoint implementation lanes in the same broader task set, with clear context or token savings and non-overlapping write scopes.
- A recommended subagent row should include a context budget and return budget. Without that, the recommendation is incomplete for efficient execution.
- New subagents and repository skills require evidence that an existing skill, agent, runbook, pattern, plugin, or native workflow is insufficient.
- Runtime-global writes, including `~/.codex`, are consumer operations and must not happen as a side effect of repository healthchecks.
- `migrate-to-codex` is powerful by design: once a source and target are selected, it can write generated Codex artifacts into that target. Use dry-run, plan, doctor, and validate commands before writing to a shared or global target.
- Any agentic automation that can write files must keep a narrow ownership boundary and produce validation evidence.
- Subagents should return compact evidence and decisions, not full transcripts, raw logs, or broad file excerpts.
