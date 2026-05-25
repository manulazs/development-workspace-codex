# Subagents Policy

This repository treats subagents as reusable templates for controlled delegation. Delegation is justified only when it improves quality, risk coverage, or maintainability enough to offset context and integration cost.

Use `docs/agentic-controls.md` to distinguish four different actions: recommending a subagent, spawning a subagent, creating a new subagent template, and persisting that template into a repository or runtime. Policy permission to recommend is not permission to spawn or persist.

Use `docs/subagent-context-protocol.md` for compact context packages, return budgets, and integration rules. Use `docs/continuous-evolution.md` for the orchestrator/subagent handoff protocol when delegation is part of workspace evolution.

## Default

- Use 0 subagents for small, linear, tightly coupled, or low-risk work.
- Use one or more subagents when tasks are independent, bounded, useful, and cheaper to delegate than to keep in the main context.
- Keep task framing, synthesis, conflict control, and final decisions in the main Codex thread.
- Do not delegate just because a specialized agent exists.
- Route practical implementation by precedence: main agent decides, plans, reviews, and integrates; a specialized subagent has priority when its domain fits; `workspace_implementer` is the fallback for scoped implementation with no better specialist; the main agent handles simple low-context edits directly.
- When no specialist fits, prefer `workspace_implementer` for scoped implementation whenever delegation is expected to reduce parent-context load or token use. Keep implementation in the main thread only when that is the more efficient token/context path.
- Runtime, developer, or user instructions always prevail. If the active platform requires explicit authorization before spawning subagents, request it first.
- Subagents must never use `/fast` or fast-mode shortcuts. Use normal 1:1 subagent execution only.
- Use the smallest context package that can succeed. Prefer `fork_context: false` and bounded file lists unless the subagent genuinely needs full thread context.

## Implementation Fallback

Use `workspace_implementer` only for practical repository edits with clear scope and low specialist overlap:

- implementing already planned changes;
- applying patches;
- altering scripts;
- fixing paths;
- adjusting manifests or configs;
- updating operational documentation directly tied to the change;
- small or medium refactors;
- practical tasks without a more appropriate specialist.

Do not use `workspace_implementer` for broad architecture, security, QA, code review, data, BI, frontend UI, API/backend, `AGENTS.md`, skills, packages, Git/release, sensitive governance, final approval, destructive operations, pushes, or ambiguous work when an existing specialist or the main agent is the better owner.

Efficiency default: if the implementation is scoped, practical, and not specialist-owned, route it to `workspace_implementer` when the main benefit is reducing parent-context load, isolating verbose file reads, or avoiding token-heavy local implementation. The main agent should implement directly only when the task is small enough that delegation overhead would cost more than it saves.

Multiple `workspace_implementer` instances are allowed in the same broader task set only when all conditions hold:

- each instance owns a disjoint implementation lane, file set, or responsibility;
- there is clear context or token savings from splitting the work;
- the parent agent can integrate the outputs without redoing the work;
- no specialist subagent is a better owner for any lane;
- no two implementers receive the same task or overlapping write scope.

## Planning To Implementation

Planning skills may recommend subagents but must not spawn them during planning. When a final plan contains a `Subagent Execution Plan`, treat it as an implementation-time routing instruction, not as automatic authorization.

During implementation, prefer spawning the recommended subagent when the task is independent and provides at least one clear benefit: lower main-context load, lower token use, domain isolation, independent validation, safe parallelism, or repetitive mechanical execution.

Do not spawn when the task is trivial, tightly coupled to the immediate critical path, likely to conflict with active edits, blocked by missing tools or permissions, or cheaper to complete locally.

## Context And Token Efficiency

Delegation should reduce net work. Before spawning, choose a context budget from `docs/subagent-context-protocol.md`: `tiny`, `small`, `medium`, or `large`.

- Use `tiny` or `small` for most reviews, docs tasks, inventory checks, and command-log summaries.
- Use `medium` when the subagent must inspect several related files or produce a bounded design/review.
- Use `large` only when the subagent's job is to absorb large logs, broad documentation, or search output and return a compact synthesis.
- Set an explicit return budget for verbose tasks, such as "findings only", "top 5 risks", or "summary plus changed paths".
- Do not send secrets, runtime caches, generated noise, or unrelated chat history.
- Do not ask subagents to restate the full task, reproduce large file contents, or paste long logs unless the exact excerpt is necessary evidence.

The main agent should keep a simple ownership map while agents are active: agent, scope, files or directories, expected output, and stop condition.

## Use One Or More Subagents When

- The task is independent from the next critical-path step.
- The scope has a clear owner, input, output, validation signal, and stopping point.
- The work can be reviewed by the main agent without redoing it.
- The risk of file, decision, or context conflict is low.
- A specialist can materially improve quality, coverage, or operational control.
- Another independent lane can proceed in parallel without blocking or colliding with current work.

## Use Multiple Subagents When

- There are at least 2 independent workstreams.
- Each workstream has disjoint file ownership or a clearly separate responsibility.
- The main agent can integrate outputs deterministically.
- The subagents are not answering the same question with similar scope.
- The expected quality or risk benefit exceeds the coordination overhead.
- A mechanical or lifecycle lane, such as Git commit prep, docs cleanup, dependency diagnosis, or release notes, can safely run beside research, review, or implementation.

Multiple subagents should be intentional, not rare by default. Similar-looking scopes require explicit justification, but independent lanes should not be collapsed into the main thread only because another subagent is already active.

## Do Not Delegate

- The next blocking step on the critical path.
- The same question to multiple similar agents.
- Work that requires tight, iterative local judgment.
- Broad exploration with no bounded output.
- Mutation in files another active subagent owns.
- One-off work where delegation overhead is higher than doing it locally.

## Required Delegation Context

Before spawning a subagent, provide:

- Objective.
- Why delegation is justified.
- Read scope.
- Write scope, if any.
- Files, systems, or decisions out of scope.
- Relevant constraints and user instructions.
- Required input files or snippets.
- Context budget.
- Expected output format.
- Return budget.
- Validation signal.
- Dependencies and blockers.
- Risk level.
- Stopping criteria.

Context should be sufficient but not bloated. Do not send broad repository dumps when a bounded file list or summary is enough.

## After Delegation

The main agent must:

- Review the result.
- Integrate only the useful output.
- Resolve conflicts and gaps.
- Close the subagent when no longer needed.
- Record reusable decisions only when the pattern is likely to recur.

The subagent does not own the final answer.

## Public Capability Matrix

| Task type | Preferred owner | Use subagent? | Avoid delegation when |
| --- | --- | --- | --- |
| Small code/doc edit | Main agent | No | The change is local and obvious |
| Large code change with independent slices | Runtime `worker` role or equivalent custom agent | Yes, if authorized | Files overlap or design is unsettled |
| Read-only codebase question | Runtime `explorer` role or equivalent read-only agent | Yes, if authorized | The answer blocks the immediate next command |
| Data discovery and source research | `data_discovery_researcher` | Yes, if bounded | The source contract, grain, and owner are already known |
| SQL, Databricks, dbt logic | `data_pipeline_engineer` | Yes, if bounded | Source lineage is unclear and needs main-thread decisions |
| Data catalog, taxonomy, glossary, lineage docs | `data_catalog_taxonomist` | Yes, if bounded | The task is transformation implementation or visual design |
| Data science, statistical analysis, insight synthesis | `data_science_modeler` | Yes, if bounded | The request is only deterministic pipeline work |
| Dashboard, BI, DAX, analytical UI | `dashboard_visualization_specialist` | Yes, if bounded | Semantic model decisions are not settled |
| Frontend web UI, HTML artifacts, responsive interaction | `frontend_ui_engineer` | Yes, if bounded | The task is BI/dashboard-specific, backend/API, or simple enough for the main agent |
| API routes, backend services, contracts, integration boundaries | `api_backend_engineer` | Yes, if bounded | The task is frontend UI, data pipeline/dbt, broad architecture, or simple enough for the main agent |
| Current documentation, release notes, API references, framework behavior | `docs_researcher` | Yes, if bounded and current facts affect the decision | Local project evidence is enough or the task is data-source discovery |
| Markdown docs, README, changelog, runbooks | `markdown_writer` | Yes, if bounded | Product behavior or commands are not validated |
| Automated tests, fixtures, smoke checks, validation scripts, regression coverage | `test_automation_engineer` | Yes, if bounded | Final QA review is needed or domain implementation should own tightly coupled tests |
| Review | `code_reviewer` | Yes, after implementation | No diff or acceptance criteria exists |
| QA, acceptance criteria, test gaps, release readiness | `qa_reviewer` | Yes, after implementation or before release | No implementation or acceptance criteria exists |
| Security review | `security_auditor` | Yes, for read-only audit | Fix implementation is required in the same step |
| Dependency install, package conflicts, runtime setup | `package_manager` | Yes, if isolated | Upgrade scope is broad or risky |
| Git staging, commit grouping, release-safe push prep | `version_control_manager` | Rarely | The user did not explicitly request git operations |
| Project instructions | `agents_md_maintainer` | Yes, after conventions emerge | Facts are not yet validated |
| Skill creation | `local_skill_builder` | Yes, when recurring | The workflow is one-off |
| General practical implementation without a specialist owner | `workspace_implementer` | Yes, when scoped and context-saving | A specialist applies, including frontend UI or API/backend, scope is ambiguous, or the edit is simple enough for the main agent |

## Model Guidance

Model selection should be based on risk and task complexity:

- Critical review, security, migration, or destructive-operation analysis: strong model class, higher reasoning, explicit confirmation gates.
- Complex implementation: strong Codex-oriented model when available.
- Mechanical docs or inventory updates: smaller model is acceptable when risk is low.
- Unavailable suggested model: consumer workspace should choose the closest available model by capability, not fail adoption.

See also `docs/subagents-lifecycle.md` for creation, reuse, validation, and retirement rules.
