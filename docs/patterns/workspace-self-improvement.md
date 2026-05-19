# Workspace Self-Improvement Pattern

Use this pattern after substantial Codex workspace work.

## End-Of-Task Review

Before finalizing a workspace change, answer:

- Did this task reveal a recurring error?
- Did it validate a repeatable command or workflow?
- Did it create a decision that changes future behavior?
- Did it expose a skill, agent, or instruction overlap?
- Did it require a manual step that should be scripted?

## Where To Record

| Finding type | Target |
| --- | --- |
| Structural decision | `docs/decisions/` |
| Recurring error and fix | `docs/lessons/` |
| Repeatable workflow | `docs/patterns/` or `docs/runbooks/` |
| Agent delegation rule | `docs/subagents-policy.md` and `AGENTS.md` |
| Project-specific recurring workflow | local skill through `local_skill_builder` |
| Capability status or overlap | `docs/capability-inventory.md` |

## Promotion Rule

- First occurrence: mention in final response or task notes.
- Second occurrence with evidence: add to `docs/lessons/`.
- Stable procedure: promote to `docs/patterns/` or `docs/runbooks/`.
- Broad recurring agent behavior: update `AGENTS.md` or create a local skill.

Do not promote one-off preferences into permanent rules.
