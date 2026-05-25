# Staged Update Note

Use this note when an observation produces a proposed update that should be reviewed before becoming live.

Default private location:

```text
.codex-local/evolution/staged-updates/YYYY-MM-DD/<target>/
```

## Metadata

- Date:
- Related observations:
- Target capability or document:
- Gate: auto-fix-proposal or human-gated
- Reviewer required:
- Proposed files:
- Validation commands:

## Change Summary

Describe the proposed change in a few concrete bullets.

## Why This Is Staged

Explain why the change is not applied directly.

## Validation Evidence

List commands run, review outputs, and residual risk.

## Install Or Apply Instructions

Do not apply automatically. The maintainer or implementation agent should review the staged files, apply the accepted changes to repository-local files, run validation, and update the observation status.

`ACTIONED` is a resolution status after approval and application. It is not approval to publish or apply a staged change.
