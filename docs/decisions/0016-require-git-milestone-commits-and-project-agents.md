# 0016 - Require Git Milestone Commits And Project AGENTS.md

Date: 2026-05-24

## Status

Accepted

## Context

The previous global template said not to auto-commit or push unless explicitly requested. That was safe, but too weak for active implementation in projects that already have a Git repository. Long-running work benefits from coherent intermediate commits, while pushing still needs review and explicit confirmation.

The template also checked for project `AGENTS.md`, but did not make creation mandatory when the file was missing and edits were allowed.

## Decision

When working in a project with an initialized Git repository and implementation is authorized:

- create coherent commits as meaningful milestones emerge;
- avoid one large final commit when the work naturally splits into validated batches;
- keep unrelated user changes out of the agent's commits;
- perform the final push only after review/validation and explicit user confirmation.

When starting substantial work in a repository:

- check for a project `AGENTS.md`;
- create it if missing and edits are allowed;
- keep it factual and evidence-based;
- prefer `agents_md_maintainer` for instruction-file maintenance when delegation is useful, and `markdown_writer` for broader docs.

## Consequences

- Git history becomes part of normal execution quality for repositories, not an optional cleanup at the end.
- Push remains human-confirmed and review-gated.
- Project-local instructions become a required operating artifact when a repository lacks them.
- Documentation/instruction maintenance can be delegated when it is independent and bounded.
