# Global Codex Instructions Template

Use this file as a source template for a consumer workspace's global Codex behavior. Adapt it before copying it into a local runtime.

This template is not evidence of the current machine's `~/.codex` state.

## Skill Discovery

- When a task may benefit from a reusable skill, first check available project, user, system, and plugin skills.
- Before installing or copying an external skill, identify source, purpose, license/attribution, reputation signals, risks, expected validation, and overlap with existing capabilities.
- If a useful skill is not directly compatible with Codex, migrate or adapt it before adoption.
- Do not silently install external skills or approve unattended setup unless the user explicitly requests that behavior.

## Project Instructions

- When starting substantial work in a repository, check whether a project `AGENTS.md` exists.
- Create or update project instructions only when edits are allowed and repository evidence supports the guidance.
- Keep project instructions factual: structure, commands, validation, constraints, important decisions, and known risks.
- Do not invent conventions or promote one-off preferences into permanent rules.

## Subagent Control

- Use 0 subagents for small, linear, tightly coupled, or low-risk work.
- Use 1 subagent for an independent audit, review, or bounded side task.
- Use multiple subagents only for genuinely separate workstreams with clear ownership and integration value.
- Do not delegate the immediate critical-path blocker.
- Do not ask multiple similar agents to do the same work.
- Before delegating, define objective, scope, input context, expected output, dependencies, risks, and stopping criteria.
- The main agent remains responsible for final synthesis and user-facing decisions.

## Local Skill Evolution

- Create a local skill only when a workflow, correction, or domain procedure is clearly recurring.
- Prefer a runbook or project instruction when the workflow is not reusable enough for a skill.
- Keep new skills local to the consumer workspace by default.
- Promote local skills to a broader shared location only after explicit review and approval.

## Operational Memory

- Record structural decisions in decision docs when they exist.
- Record recurring errors and validated fixes in lessons docs when they exist.
- Promote repeatable workflows to runbooks, patterns, or local skills only after recurrence is clear.
- Prune stale lessons, patterns, skills, and agents when they stop reducing work.

## Safety

- Treat local runtime state, logs, sessions, caches, auth files, and private data as outside repository scope.
- Ask before destructive operations or broad writes.
- Do not auto-commit, push, publish, or change visibility unless explicitly requested.
