# Decision 0018: Add Workspace Implementer Fallback

Date: 2026-05-25

## Status

Accepted

## Context

The workspace already has specialized subagents for security, QA, code review, documentation, packages, data/BI, project instructions, skills, and Git/release work. Some implementation tasks are still practical, scoped, and context-heavy enough to benefit from delegation, but do not belong to any specialist.

The proposed name `general_purporse_implementer` was rejected because it contains a typo and is less aligned with the repository's routing language. The adopted agent name is `workspace_implementer`.

## Decision

Add `workspace_implementer` as a `core` subagent template and include it in the `governed-codex` profile.

Routing precedence:

1. The main agent decides, plans, reviews, integrates, and owns final user-facing output.
2. Specialized subagents have priority when their domain fits.
3. `workspace_implementer` is used only for clear practical implementation work with no better specialist.
4. When no specialist fits, `workspace_implementer` is preferred if delegation is expected to reduce parent-context load or token use.
5. Simple low-context edits stay in the main thread when direct implementation is the more efficient token/context path.

Multiple `workspace_implementer` instances may run in the same broader task set only for disjoint implementation lanes with clear context or token savings. They must not duplicate the same task or overlap write scopes.

The agent uses `gpt-5.3-codex`, high reasoning, and `workspace-write` because its role is bounded repository implementation.

## Consequences

- Governed profiles can install a general implementation fallback without installing domain-specific optional agents.
- The agent must not become a catch-all for architecture, security, QA, code review, data, BI, packages, Git/release, skills, project instructions, final approval, destructive operations, or pushes.
- Future routing changes should update `docs/subagents-policy.md`, `docs/subagent-context-protocol.md`, `docs/agentic-controls.md`, `workspace-manifest.json`, and `docs/capability-inventory.md`.
