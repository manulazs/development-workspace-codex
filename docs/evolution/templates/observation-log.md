# Skill Observation Log

Persistent observations captured during task-oriented work.

Default private location in a consumer workspace:

```text
.codex-local/evolution/observations/log.md
```

Do not store private runtime state, auth files, session logs, secrets, customer data, or raw transcripts here.

Status key:

- `OPEN`: not reviewed or not actioned yet.
- `ACTIONED`: applied to a skill, agent, runbook, policy, docs, or script.
- `DECLINED`: reviewed and intentionally rejected.
- `SUPERSEDED`: replaced by a newer observation, decision, or implementation.

## Observation Template

```markdown
### Observation OBS-YYYYMMDD-001: Short title

**Status:** OPEN
**Date:** YYYY-MM-DD
**Source:** task, review, user correction, validation failure, audit, or recurring pattern
**Target:** skill, agent, runbook, docs, script, policy, or cross-cutting
**Type:** correction, gap, duplication, safety, quality, workflow, or principle
**Sensitivity:** public-safe, internal, sensitive-summary-only
**Evidence summary:** Sanitized evidence only. Use paths or short summaries; do not paste secrets, private logs, raw transcripts, tokens, auth data, or customer data.
**Proposed change:** Specific change to review.
**Gate:** auto-edit-allowed, auto-fix-proposal, human-gated, or forbidden
**Resolution note:** Empty while OPEN. For resolved entries, include the change, decline reason, or superseding ID.
```
