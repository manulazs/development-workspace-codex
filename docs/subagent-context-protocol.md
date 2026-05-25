# Subagent Context Protocol

Last reviewed: 2026-05-24

This protocol keeps subagent delegation useful without flooding the main thread with raw context, duplicated work, or verbose logs. It applies to recommended and spawned subagents. It does not authorize spawning, creating, or persisting subagents by itself.

## Objectives

- Reduce main-thread context load.
- Keep delegation cheaper than doing the work locally.
- Preserve enough evidence for review and validation.
- Prevent duplicate or conflicting subagent work.
- Keep the main agent accountable for synthesis and final decisions.

## Routing Rule

Spawn a subagent only when at least one value is clear and the coordination cost is lower than the expected gain:

- `context-savings`: the subagent can read large files, logs, docs, or search results and return a compact summary.
- `domain-isolation`: the task has a clear specialist domain and bounded output.
- `independent-validation`: a second pass can catch defects without blocking implementation.
- `parallel-safe`: the subagent owns a disjoint read/write scope.
- `mechanical-repeat`: the task is repetitive, structured, and easy to verify.

Multiple subagents may run at the same time when their lanes are independent. For example, a Git hygiene or release-notes lane can run beside source research, documentation cleanup can run beside validation, and a read-only reviewer can run beside non-overlapping implementation. The rule is disjoint scope and useful output, not a fixed cap of one active subagent.

Keep work local when the next step is blocked on the answer, the task is trivial, the scope overlaps active edits, the required context is already small, or the main agent would need to redo the whole task to trust the result.

For implementation work, route by precedence:

1. Keep orchestration, planning, integration, and final approval in the main agent.
2. Use a specialized subagent when the task fits an existing specialist domain.
3. Use `workspace_implementer` for clear practical implementation only when no specialist is a better fit.
4. Keep simple low-context edits in the main agent.

More than one `workspace_implementer` may be spawned for one broader work package only when each instance owns a disjoint lane and the split clearly saves context or tokens. Do not split one tightly coupled task across multiple generic implementers.

## Context Package

Send the smallest package that lets the subagent complete the task:

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

Use one of these context budgets:

| Budget | Use when | Package |
| --- | --- | --- |
| `tiny` | The task is mechanical or review-only. | Goal, 1-3 files or commands, exact output format. |
| `small` | The task needs local repo evidence. | Goal, bounded file list, relevant decisions, validation command. |
| `medium` | The task needs a short design or cross-file review. | Goal, bounded directories, known risks, acceptance criteria. |
| `large` | The task must inspect large logs/docs or broad repo slices. | Goal, search strategy, exclusions, summary-only return. |

Do not send broad repository dumps, previous full conversations, large logs, generated files, secrets, caches, or unrelated user preferences. Use `fork_context: false` unless the subagent truly needs the full current thread.

## Return Contract

Subagents should return compact, reviewable output:

```text
Result:
Evidence:
Files changed:
Validation:
Residual risk:
Recommended next action:
```

Rules:

- Summarize logs and large reads; include only the key command, status, and failure tail.
- Cite paths, commands, or tests instead of pasting large content.
- Return changed files only when the subagent edited files.
- State blockers directly, including the exact missing input or permission.
- Do not continue exploring after the stopping criteria are met.

## Integration Contract

The main agent must:

- keep the immediate critical path local;
- track active subagent ownership to avoid overlapping writes;
- integrate only useful output;
- validate merged changes in the main workspace;
- close subagents when their output is no longer needed;
- record durable policy changes in docs, not in ad hoc prompts.

## Planning Output

Planning skills should turn separable rows into a `Subagent Execution Plan`. Each recommended subagent row should include:

- real available agent or explicit fallback state;
- implementation phase;
- context budget;
- `fork_context` expectation;
- read/write scope;
- expected output;
- validation signal;
- token or quality benefit;
- dependencies;
- conflict risk;
- fallback if unavailable.

If no subagent should run, the plan should say `Subagent Execution Plan: none` and explain why.
