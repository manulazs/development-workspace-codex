---
name: plan-deep-skills
description: Manual-only Plan Mode add-on. Use only when Manuel explicitly invokes $plan-deep-skills to create a deeper planning pass that also evaluates existing and external skills via find-skills before recommending task delegation. Do not auto-trigger for ordinary planning requests.
metadata:
  short-description: Manual deep planning with skill discovery
---

# Plan Deep Skills

Use this skill only when Manuel explicitly invokes `$plan-deep-skills`.

This skill extends `$plan-deep` with a skill-evaluation stage. It is still planning-only. Do not edit files, spawn subagents, install skills, or run destructive commands while using this skill. If the current collaboration mode is Plan Mode, follow Plan Mode rules strictly. If the runtime is not in Plan Mode, still treat this skill invocation as planning-only unless Manuel explicitly asks for implementation after the plan.

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
   - Check global skills under `~/.codex/skills`.
   - Check project-local skills under `skills/`, `.agents/skills`, or `.codex/skills`.
   - Prefer local/custom skills when they encode Manuel's workflow or project-specific rules.

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
   - Do not delegate or install during planning.

## Final Plan Shape

Return a single `<proposed_plan>` block when the plan is decision-complete.

Include:

- title and concise summary;
- key insights;
- skill inventory decision: existing skill, external skill candidate, conversion needed, or no skill needed;
- implementation approach;
- task delegation matrix with task, owner/agent, skill, reason, input, output, dependencies, and risk;
- validation and acceptance criteria;
- assumptions and defaults.

Keep the plan compact but complete enough for another agent to implement without deciding architecture, ownership, skill installation, or validation strategy.
