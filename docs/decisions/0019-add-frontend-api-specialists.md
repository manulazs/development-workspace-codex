# Decision 0019: Add frontend and API specialist subagents

Date: 2026-05-25

## Status

Accepted

## Context

The workspace already has a governed data pipeline agent set, a dashboard/BI specialist, documentation/QA/security/Git specialists, and a generic `workspace_implementer` fallback. During capability review, no material duplicate agent was found for frontend web UI or API/backend service implementation.

Without specialist agents, scoped UI and API work would fall through to `workspace_implementer`. That is acceptable for simple practical changes, but it loses domain-specific routing for responsive UI, browser validation, API contracts, service boundaries, and cross-stack handoffs.

The known skill overlap between `plan-deep` and `plan-deep-skills` remains intentional: `plan-deep` is the base deep-planning workflow, while `plan-deep-skills` extends it with capability and skill-selection planning.

## Decision

Add two optional subagent templates:

- `frontend_ui_engineer` for frontend web interfaces, HTML artifacts, responsive UI implementation, browser validation, accessibility, and user-facing interaction quality.
- `api_backend_engineer` for API routes, backend service implementation, request/response contracts, validation, and integration boundaries.

Routing precedence remains:

1. Main agent frames, decides, reviews, integrates, and owns final user-facing output.
2. Specialized subagents have priority when their domain fits.
3. `workspace_implementer` handles scoped practical implementation only when no specialist is a better owner.
4. The main agent handles simple low-context edits directly when delegation would cost more than it saves.

Tune `data_discovery_researcher` and `data_catalog_taxonomist` to smaller model classes because they are bounded research/metadata roles with compact return contracts. Keep stronger models for implementation-heavy, security, review, BI, and data science roles.

## Consequences

- Frontend and API work now have explicit specialist owners instead of relying on the generic implementer.
- `frontend-artifacts` adopts `frontend_ui_engineer`; `full-reviewed` adopts `api_backend_engineer`.
- Data-project routing can include application surfaces without mixing them into data pipeline or dashboard responsibilities.
- The new agents remain optional and do not alter the governed core profile.
- `workspace_implementer` remains useful for scoped practical work outside specialist domains.
