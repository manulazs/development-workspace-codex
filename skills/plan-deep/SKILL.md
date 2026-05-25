---
name: plan-deep
description: Manual-only Plan Mode add-on. Use only when the user explicitly invokes $plan-deep to create a deeper planning pass with context grounding, insights, task cataloging, and subagent delegation recommendations. Do not auto-trigger for ordinary planning requests.
metadata:
  short-description: Manual deep planning with delegation matrix
---

# Plan Deep

Use this skill only when the user explicitly invokes `$plan-deep`.

This is a planning add-on, not an implementation workflow. Do not edit files, install skills, or run destructive commands while using this skill. If the current collaboration mode is Plan Mode, follow Plan Mode rules strictly. If the runtime is not in Plan Mode, still treat this skill invocation as planning-only unless the user explicitly asks for implementation after the plan.

## Planning vs Implementation Delegation Boundary

Planning may use subagents only for planning assistance when the active runtime, user instructions, and developer instructions allow it. Planning-assistance subagents must be bounded, non-destructive, and normally read-only. Use them when they reduce context load, inspect broad repository areas, research current documentation, summarize logs, evaluate risks, or independently review assumptions for the plan.

Planning-assistance subagents do not authorize implementation. They must not edit files, install packages, create skills or agents, write runtime-global state, commit, push, or make final architecture decisions. The main agent remains the planner and must integrate their findings.

Planning may also recommend, map, and justify implementation-time subagents.

However, if the final plan identifies independent tasks where subagents would reduce context load, reduce token consumption, improve validation, or parallelize work safely, mark those tasks as recommended for subagent execution during implementation. Once implementation begins outside Plan Mode, the main agent may spawn those subagents according to the plan, subject to available tools, user permissions, and active runtime instructions.

Use `docs/subagent-context-protocol.md` when this repository is available. A delegation recommendation is incomplete unless it defines the context budget, return budget, `fork_context` expectation, validation signal, and fallback.

Distinguish:

- `logical owner`: the role responsible for the task in the plan;
- `planning assistance subagent`: a real available subagent used during planning for read-only research, inspection, analysis, or validation support;
- `recommended implementation subagent`: a real available subagent to spawn during implementation;
- `role-only`: a conceptual owner that should not be spawned unless it is created or mapped to an existing subagent.

## Objective

Create a decision-complete plan that:

- grounds itself in the real project/environment;
- extracts the relevant insights, constraints, risks, and unknowns;
- decomposes the work into concrete tasks;
- maps each task to the best available agent or role;
- recommends new custom agents only when existing agents are insufficient.

## Workflow

1. Ground the plan in evidence.
   - Inspect repository structure, `AGENTS.md`, relevant configs, manifests, docs, schemas, and existing skills/agents.
   - Prefer `rg` and targeted reads.
   - Use a planning-assistance subagent, such as an available read-only explorer, reviewer, researcher, or domain specialist, when the context to inspect is broad and a compact summary would be cheaper or more reliable than keeping all raw context in the main thread.
   - Do not ask questions that local inspection can answer.

2. Clarify intent only where needed.
   - Ask only high-impact questions that change scope, constraints, success criteria, or risk posture.
   - If a reasonable default exists, state it as an assumption in the plan.

3. Produce insights.
   - Summarize the current state.
   - Identify constraints, coupling, dependencies, risks, likely bottlenecks, and validation needs.
   - Separate facts from assumptions.

4. Catalog tasks.
   - Break work into tasks that are independently assignable.
   - Mark dependencies and tasks that must stay local with the main agent.
   - Prefer quality and correctness over raw speed.

5. Map agents.
   - Check runtime built-in roles first when the active platform exposes them: `default`, `explorer`, `worker`. Treat them as runtime roles, not persistent `.codex/agents/` templates.
   - Check repository, project, or consumer-runtime custom agents when those sources are relevant and available.
   - When a stable project-local workflow clearly deserves reusable instructions, recommend `local_skill_builder` for a separate local skill creation task.
   - Recommend implementation-time subagent execution when the task can run independently and provides token savings, domain isolation, independent validation, repetitive/mechanical execution, or low conflict risk.
   - If planning-assistance subagents were used, cite their scope and findings separately from the implementation-time `Subagent Execution Plan`.
   - Prefer recommendations that let the implementation agent use `fork_context: false` with a bounded context package.
   - Do not recommend delegating work that blocks the immediate next critical-path step.
   - Do not recommend subagents for trivial tasks, tightly coupled work, unavailable tools, missing permissions, or work where coordination cost exceeds benefit.

6. Identify agent gaps.
   - If no existing agent is suitable, propose a concise custom-agent creation step before delegation.
   - Include the proposed agent name, responsibility, model, reasoning effort, sandbox mode, and why the gap is real.
   - Do not invent unavailable agents without labeling them as `create/provision before implementation`, `generic worker fallback`, or `role-only, do not spawn`.

## Final Plan Shape

Return a single `<proposed_plan>` block when the plan is decision-complete.

Include:

- title and concise summary;
- key insights;
- implementation approach;
- task delegation matrix with task, owner/agent, reason, input, output, dependencies, and risk;
- `Subagent Execution Plan` when separable tasks exist, with agent, implementation phase, context budget, `fork_context` expectation, scope, read/write scope, expected output, return budget, validation, token/quality benefit, dependencies, conflict risk, and fallback if unavailable;
- validation and acceptance criteria;
- assumptions and defaults.

If no implementation-time subagent is recommended, include `Subagent Execution Plan: none` with a short reason.

Keep the plan compact but complete enough for another agent to implement without deciding architecture, ownership, or validation strategy.
