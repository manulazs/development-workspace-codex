# Subagents Lifecycle

This document governs creation, reuse, validation, consolidation, and retirement of custom Codex subagent templates in the public repository.

Subagent files in `.codex/agents/` are reusable source templates. They are not proof that any consumer runtime has installed them.

## Decision Rule

Prefer the smallest durable capability that solves the recurring need:

- Do nothing when the need is one-off, unclear, or already covered by normal orchestration.
- Reuse an existing subagent when role, permissions, and examples match with only prompt context.
- Create or update a skill when the value is reusable instructions, references, commands, or templates.
- Create or update a runbook when the value is an operational procedure.
- Create a subagent when the recurring need is a distinct role with independent ownership, permission posture, risk profile, and reviewable output.
- Update `AGENTS.md` only when the learning is a short permanent behavior rule.

## Create Or Change A Subagent When

- The responsibility recurs across repositories or workspace maintenance tasks.
- Existing agents do not cover the role without material overlap.
- The agent has a clear boundary: objective, inputs, outputs, read/write scope, validation, and exit criteria.
- The role benefits from a different reasoning profile, sandbox posture, or tool discipline than the main orchestrator.
- The expected output can be reviewed without rerunning the whole task manually.

## Do Not Create A Subagent When

- A skill, runbook, pattern, or short instruction is enough.
- The use case has happened only once.
- The proposed agent duplicates an existing role with a different name.
- The role mixes unrelated responsibilities such as implementation, review, security, and documentation.
- The agent would require broad write access without a narrow ownership boundary.
- The only reason is speed rather than quality, control, or risk reduction.

## Required Agent Template Fields

Each subagent should define:

- Objective.
- Scope and explicit non-scope.
- Suggested model class and fallback guidance.
- Suggested reasoning level.
- Sandbox mode and permission rationale.
- Required input context.
- Context budget and return budget.
- Expected output format.
- Validation signal.
- When to use.
- When not to use.
- Risks and overlap.
- Exit criteria.

## Proposal Template

Use this before adding a file under `.codex/agents/`:

```markdown
# Agent Proposal: <agent_name>

## Purpose
What recurring role this agent owns.

## Existing Capability Check
- Existing agents reviewed:
- Existing skills/runbooks reviewed:
- Why reuse is insufficient:

## Scope
- Read scope:
- Write scope:
- Explicitly out of scope:

## Model And Permissions
- Suggested model class:
- Fallback if unavailable:
- Reasoning level:
- Sandbox mode:
- Network need:
- Escalation risk:

## Inputs And Outputs
- Required input context:
- Context budget:
- Expected output:
- Return budget:
- Validation signal:
- Exit criteria:

## Risks
- Overlap risk:
- Safety risk:
- Maintenance risk:

## Inventory And Manifest
- Manifest status:
- Inventory row updated:
- Review date:
```

## Validation

Before committing a new or changed subagent:

- Compare it with `.codex/agents/` and `docs/capability-inventory.md`.
- Confirm status in `workspace-manifest.json`.
- Validate custom agents with `migrate-to-codex --validate-target .`.
- Confirm the agent instructions include compact context/return behavior aligned with `docs/subagent-context-protocol.md`.
- Confirm the permission level matches the role. Prefer read-only for audit and review agents.
- Add or update the capability inventory entry with status, purpose, overlap, risk, platforms, and usage guidance.
- Document structural policy changes in `docs/decisions/` when governance changes.

## Consolidation

Merge or retire agents when:

- two agents differ mainly by wording, not responsibility;
- a new skill or runbook now covers the workflow;
- model or sandbox settings are no longer justified;
- integration cost exceeds delegated value;
- the agent has no demonstrated recurring use.

## Retirement

Retire or archive a subagent when:

- it is duplicated by another agent, native runtime capability, plugin, skill, pattern, or runbook;
- its ownership is unclear or too broad;
- its permissions are riskier than its value;
- its workflow is no longer public or reusable;
- it depends on a personal preference that should not be a public default.

Archived agents must be moved outside `.codex/agents/` so they are not loaded accidentally. Record the reason in `workspace-manifest.json`, `docs/capability-inventory.md`, and, when useful, under `docs/archive/`.
