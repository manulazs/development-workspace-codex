---
name: plan-deep-skills
description: Manual-only Plan Mode add-on. Use only when the user explicitly invokes $plan-deep-skills to create a deeper planning pass that also evaluates existing and external skills via find-skills before recommending task delegation. Do not auto-trigger for ordinary planning requests.
metadata:
  short-description: Manual deep planning with skill discovery
---

# Plan Deep Skills

Use this skill only when the user explicitly invokes `$plan-deep-skills`.

This skill extends `$plan-deep` with a skill-evaluation stage. It is still planning-only. Do not edit files, spawn subagents, install skills, or run destructive commands while using this skill. If the current collaboration mode is Plan Mode, follow Plan Mode rules strictly. If the runtime is not in Plan Mode, still treat this skill invocation as planning-only unless the user explicitly asks for implementation after the plan.

## Planning vs Implementation Delegation Boundary

Planning must not spawn subagents, edit files, install skills, or run destructive commands. Planning may only recommend, map, and justify subagents and skills.

However, if the final plan identifies independent tasks where subagents would reduce context load, reduce token consumption, improve validation, or parallelize work safely, mark those tasks as recommended for subagent execution during implementation. Once implementation begins outside Plan Mode, the main agent may spawn those subagents according to the plan, subject to available tools, user permissions, active runtime instructions, and skill availability.

Use `docs/subagent-context-protocol.md` when this repository is available. A delegation recommendation is incomplete unless it defines the context budget, return budget, `fork_context` expectation, validation signal, fallback, and skill availability.

Distinguish:

- `logical owner`: the role responsible for the task in the plan;
- `recommended implementation subagent`: a real available subagent to spawn during implementation;
- `skill`: an existing or proposed skill the subagent or main agent should use;
- `role-only`: a conceptual owner that should not be spawned unless it is created or mapped to an existing subagent.

## Objective

Create a decision-complete plan that:

- grounds itself in the real project/environment;
- extracts insights, constraints, risks, and unknowns;
- evaluates reusable skills before recommending custom work;
- decomposes tasks;
- maps tasks to agents and skills;
- recommends new skills or agents only when existing capabilities are insufficient.

## Workflow

1. Run the `$plan-deep` style planning pass.
   - Inspect the repository and current environment.
   - Clarify only high-impact unknowns.
   - Decompose work into assignable tasks.

2. Check existing skills first.
   - Inspect skills listed in the current session.
   - Check consumer-runtime skills only when runtime inspection is relevant and allowed.
   - Check project-local skills under `skills/`, `.agents/skills`, or `.codex/skills`.
   - Prefer local/custom skills when they encode explicit workflow or project-specific rules.

3. Use `$find-skills` only if there is a real gap.
   - Search externally only when no existing skill is good enough.
   - Evaluate fit, source reputation, maintenance signals, scripts/assets, and Codex compatibility.
   - Do not recommend installation based only on a search result.

4. Handle conversion before use.
   - If an external skill is not directly Codex-compatible, recommend `$migrate-to-codex`.
   - Plan conversion and validation before installation.
   - Require explicit approval before installing or converting external skills.

5. Build the task and capability map.
   - For each task, identify agent, skill, inputs, output, validation, dependencies, and risk.
   - Recommend new custom agents or local skills only when the gap is material.
   - When a project-local skill should be created during implementation, assign that task to `local_skill_builder`.
   - Recommend implementation-time subagent execution when the task can run independently and provides token savings, domain isolation, independent validation, repetitive/mechanical execution, or low conflict risk.
   - Prefer recommendations that let the implementation agent use `fork_context: false` with a bounded context package.
   - Do not recommend subagents for trivial tasks, tightly coupled work, unavailable tools, missing permissions, or work where coordination cost exceeds benefit.
   - Do not invent unavailable agents without labeling them as `create/provision before implementation`, `generic worker fallback`, or `role-only, do not spawn`.
   - Do not delegate or install during planning.

## Final Plan Shape

Return a single `<proposed_plan>` block when the plan is decision-complete.

Include:

- title and concise summary;
- key insights;
- skill inventory decision: existing skill, external skill candidate, conversion needed, or no skill needed;
- implementation approach;
- task delegation matrix with task, owner/agent, skill, reason, input, output, dependencies, and risk;
- `Subagent Execution Plan` when separable tasks exist, with agent, implementation phase, context budget, `fork_context` expectation, scope, read/write scope, expected output, return budget, validation, token/quality benefit, dependencies, conflict risk, fallback if unavailable, and skill to use;
- validation and acceptance criteria;
- assumptions and defaults.

If no implementation-time subagent is recommended, include `Subagent Execution Plan: none` with a short reason.

Keep the plan compact but complete enough for another agent to implement without deciding architecture, ownership, skill installation, or validation strategy.
