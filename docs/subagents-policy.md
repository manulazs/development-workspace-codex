# Subagents Policy

This workspace uses subagents only when delegation improves quality or speed without creating duplicate work. The goal is controlled leverage, not artificial restriction.

## Default

- Use 0 subagents by default for small, linear, or tightly coupled work.
- Keep orchestration and final decisions in the main Codex thread.
- Do not delegate just because a specialized agent exists.
- Runtime, developer, or user instructions always prevail. If the active platform requires explicit authorization before spawning subagents, request it first.

## Use 1 Subagent When

- The task is independent from the next critical-path step.
- The scope has a clear owner, input, output, and validation signal.
- The work can be reviewed by the main agent without redoing it.
- The risk of file or decision conflict is low.
- A specialist can materially improve speed, coverage, or quality.

## Use Multiple Subagents When

- There are at least 2 independent workstreams.
- Each workstream has disjoint file ownership or a clearly separate responsibility.
- Parallelism materially reduces elapsed time or improves risk coverage.
- The main agent can integrate the outputs deterministically.
- The subagents are not answering the same question with similar scope.

Recurring pairings are acceptable when the scopes are genuinely different. Examples:

- Setup or validation specialist plus documentation or governance specialist.
- Implementation worker plus independent reviewer.
- Domain specialist plus package or environment specialist.

There is no fixed numeric limit. Using many subagents, or several agents with similar scopes, requires an explicit justification in the working update.

## Outside Plan Mode

- The orchestrator may propose or use subagents outside `/plan` when the task justifies delegation and the runtime permits it.
- The decision should depend on independence, risk, expected benefit, and integration cost.
- The main Codex thread remains responsible for task framing, conflict control, final decisions, and the final answer.
- If runtime instructions require explicit user authorization before subagent use, those instructions override this repository policy.

## Do Not Delegate

- The next blocking step on the critical path.
- The same question to multiple similar agents.
- Work that requires tight, iterative local judgment.
- Broad exploration with no bounded output.
- Mutation in files another active subagent owns.
- One-off work where the delegation overhead is higher than doing it locally.

## Required Delegation Record

Before spawning a subagent, state:

- Objective.
- Owner or agent.
- Read scope.
- Write scope, if any.
- Input context.
- Expected output.
- Dependencies.
- Risk.
- Why the task should not stay local.

After the subagent returns:

- Review the result.
- Integrate only the needed output.
- Close the subagent when no longer needed.
- Record reusable decisions in `docs/lessons/`, `docs/patterns/`, `AGENTS.md`, or a local skill when the pattern is likely to recur.

## Capability Matrix

| Task type | Preferred owner | Use subagent? | Do not delegate when |
| --- | --- | --- | --- |
| Small code/doc edit | Main agent | No | The change is local and obvious |
| Large code change with independent slices | Worker subagent | Yes, if authorized | Files overlap or design is unsettled |
| Read-only codebase question | Explorer subagent | Yes, if authorized | The answer blocks the immediate next command |
| SQL, Databricks, dbt logic | `data_pipeline_engineer` | Yes, if bounded | Source lineage is unclear and needs main-thread decisions |
| Dashboard, Power BI, DAX, HTML Content | `dashboard_visualization_specialist` | Yes, if bounded | Semantic model decisions are not settled |
| Review | `code_reviewer` | Yes, after implementation | No diff or acceptance criteria exists |
| Security review | `security_auditor` | Yes, for read-only audit | Fix implementation is required in the same step |
| Dependency changes | `package_manager` | Yes, if isolated | Upgrade scope is broad or risky |
| Git staging/commit/push | `version_control_manager` | Rarely | The main agent already owns the change set |
| Project instructions | `agents_md_maintainer` | Yes, after conventions emerge | Facts are not yet validated |
| Local skill creation | `local_skill_builder` | Yes, when recurring | The workflow is one-off |

See also `docs/subagents-lifecycle.md` for creation, reuse, validation, and retirement rules.
