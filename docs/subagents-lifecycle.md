# Subagents Lifecycle

This document governs creation, reuse, validation, and retirement of custom Codex subagents in this workspace.

## Decision Rule

Prefer the smallest durable capability that solves the recurring need:

- Do nothing when the need is one-off, unclear, or already covered by normal orchestration.
- Reuse an existing subagent when its role, permissions, and examples match the task with only minor prompt context.
- Create or update a skill when the value is reusable instructions, references, commands, or templates that the main agent can invoke directly.
- Create a subagent when the recurring need is a distinct role with its own ownership, permissions, risk profile, and reviewable output.
- Update `AGENTS.md` when the learning is a short permanent behavior rule that should affect all future runs.

## Create A New Subagent When

- The responsibility recurs across projects or workspace maintenance tasks.
- Existing agents do not cover the role without material overlap or prompt contortions.
- The agent has a clear boundary: objective, inputs, outputs, read/write scope, and validation.
- The agent needs a different reasoning profile, tool posture, or permission level than the main orchestrator.
- The expected output can be reviewed without rerunning all work manually.

## Do Not Create A New Subagent When

- A skill, runbook, or pattern would be enough.
- The use case has happened only once.
- The proposed agent duplicates an existing agent with a different name.
- The role mixes unrelated responsibilities such as implementation, review, security, and documentation in one persona.
- The agent would require broad write access without a narrow ownership boundary.

## Proposal Template

Use this template before adding a file under `.codex/agents/`:

```markdown
# Agent Proposal: <agent_name>

## Purpose
What recurring problem this agent solves.

## Existing Capability Check
- Existing agents reviewed:
- Existing skills reviewed:
- Why reuse is insufficient:

## Ownership
- Read scope:
- Write scope:
- Files or systems explicitly out of scope:

## Permissions
- Recommended sandbox mode:
- Network need:
- Escalation risk:

## Inputs And Outputs
- Required input:
- Expected output:
- Validation signal:

## Risks
- Overlap risk:
- Safety risk:
- Maintenance risk:

## Examples
- Good use:
- Bad use:

## Inventory Update
- Inventory row added or updated:
- Review date:
```

## Validation

Before committing a new or changed subagent:

- Compare it with `.codex/agents/` and `docs/capability-inventory.md`.
- Validate custom agents with `migrate-to-codex --validate-target .`.
- Confirm the permission level matches the role. Prefer read-only for audit and review agents.
- Add or update the capability inventory entry with status, purpose, overlap, risk, and retention decision.
- Document structural policy changes in `docs/decisions/` when the change affects governance.

## Retirement

Retire or archive a subagent when:

- It is duplicated by another agent, native runtime capability, plugin, or skill.
- Its ownership is unclear or too broad.
- It has no demonstrated use and adds maintenance cost.
- Its permissions are riskier than its value.
- The workflow is better represented as a skill, pattern, or runbook.

Archived agents must be moved outside `.codex/agents/` so they are not loaded accidentally. Record the reason in `docs/capability-inventory.md` and, when useful, under `docs/archive/`.
