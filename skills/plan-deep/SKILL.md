---
name: plan-deep
description: Manual-only Plan Mode add-on. Use only when Manuel explicitly invokes $plan-deep to create a deeper planning pass with context grounding, insights, task cataloging, and subagent delegation recommendations. Do not auto-trigger for ordinary planning requests.
metadata:
  short-description: Manual deep planning with delegation matrix
---

# Plan Deep

Use this skill only when Manuel explicitly invokes `$plan-deep`.

This is a planning add-on, not an implementation workflow. Do not edit files, spawn subagents, install skills, or run destructive commands while using this skill. If the current collaboration mode is Plan Mode, follow Plan Mode rules strictly. If the runtime is not in Plan Mode, still treat this skill invocation as planning-only unless Manuel explicitly asks for implementation after the plan.

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
   - Check built-in roles first: `default`, `explorer`, `worker`.
   - Check existing custom agents under `.codex/agents` and `~/.codex/agents`.
   - Recommend delegation only when the task can run in parallel or has a clear ownership boundary.
   - Do not recommend delegating work that blocks the immediate next critical-path step.

6. Identify agent gaps.
   - If no existing agent is suitable, propose a concise custom-agent creation step before delegation.
   - Include the proposed agent name, responsibility, model, reasoning effort, sandbox mode, and why the gap is real.

## Final Plan Shape

Return a single `<proposed_plan>` block when the plan is decision-complete.

Include:

- title and concise summary;
- key insights;
- implementation approach;
- task delegation matrix with task, owner/agent, reason, input, output, dependencies, and risk;
- validation and acceptance criteria;
- assumptions and defaults.

Keep the plan compact but complete enough for another agent to implement without deciding architecture, ownership, or validation strategy.
