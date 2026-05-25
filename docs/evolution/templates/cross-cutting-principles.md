# Cross-Cutting Principles

Principles that should influence multiple skills, agents, runbooks, or policies.

Default private location in a consumer workspace:

```text
.codex-local/evolution/observations/cross-cutting-principles.md
```

A principle must have either:

- at least two linked observations; or
- one explicit ADR reference.

This prevents one-off preferences from becoming permanent workspace policy.

Status key:

- `OPEN`: proposed but not yet accepted.
- `ACTIONED`: accepted and propagated where applicable.
- `DECLINED`: reviewed and intentionally rejected.
- `SUPERSEDED`: replaced by a newer principle or decision.

## Principle Template

```markdown
### Principle PRIN-YYYYMMDD-001: Short title

**Status:** OPEN
**Date:** YYYY-MM-DD
**Evidence:** OBS-YYYYMMDD-001, OBS-YYYYMMDD-002
**ADR:** Optional; use `docs/decisions/NNNN-title.md` when a single structural decision is enough.
**Scope:** skills, agents, docs, scripts, planning, validation, or runtime adoption
**Rule:** One concise rule.
**Reason:** Why this reduces ambiguity, risk, duplication, or future work.
**Propagation:** Where this must be checked or applied.
**Resolution note:** Empty while OPEN. For resolved entries, include where it was applied, why it was declined, or what superseded it.
```
