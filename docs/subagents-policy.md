# Subagents Policy

This workspace uses subagents only when delegation improves quality or speed without creating duplicate work.

## Default

- Use 0 subagents by default.
- Keep orchestration and final decisions in the main Codex thread.
- Do not delegate just because a specialized agent exists.

## Use 1 Subagent When

- The user explicitly allows or requests subagent use.
- The task is independent from the next critical-path step.
- The scope has a clear owner, input, output, and validation signal.
- The work can be reviewed by the main agent without redoing it.
- The risk of file or decision conflict is low.

## Use Multiple Subagents When

- There are at least 2 independent workstreams.
- Each workstream has disjoint file ownership or a clearly separate responsibility.
- Parallelism materially reduces elapsed time or improves risk coverage.
- The main agent can integrate the outputs deterministically.
- The default limit is 3 subagents per round.

Using more than 3 subagents requires an explicit justification in the working update.

## Do Not Delegate

- The next blocking step on the critical path.
- The same question to multiple similar agents.
- Work that requires tight, iterative local judgment.
- Broad exploration with no bounded output.
- Mutation in files another active subagent owns.

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
