# 0013 - Operationalize Planning Subagents

Status: accepted.

## Decision

Planning skills must keep Plan Mode non-mutating, but they must also turn suitable delegation rows into implementation-time subagent recommendations.

## Reason

Earlier plans could list owners or agent-like roles without making clear whether they were logical owners or subagents to spawn later. That ambiguity let implementation collapse independent workstreams back into the main agent, increasing context load and reducing independent validation.

## Changes

- Add a `Planning vs Implementation Delegation Boundary` section to `plan-deep` and `plan-deep-skills`.
- Require a `Subagent Execution Plan` section when separable implementation tasks exist.
- Add `qa_reviewer` for independent acceptance and validation review.
- Add `markdown_writer` for bounded documentation work.
- Keep existing `package_manager`, `version_control_manager`, and `data_discovery_researcher` instead of creating duplicate aliases.

## Consequences

- Planning still does not spawn subagents, edit files, or install skills.
- Implementation can spawn recommended subagents when tools, permissions, and active instructions allow it.
- The main agent remains accountable for integration, final correctness, commits, pushes, and user-facing decisions.
