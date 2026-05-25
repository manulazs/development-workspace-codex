---
name: context-budget-audit
description: Audit repository context and token load across instructions, skills, agents, profiles, and docs; recommend pruning or lazy-loading without changing files.
metadata:
  short-description: Context and token budget audit
  origin: Adapted from ECC context-budget, token-budget-advisor, and strategic-compact concepts.
---

# Context Budget Audit

Use this skill when workspace performance, token use, or capability sprawl needs review before adding more skills, agents, docs, MCPs, or global instructions.

This is an audit workflow. It does not prune, archive, install, or rewrite capabilities by itself.

## Workflow

1. Ground in the repository.
   - Read `workspace-manifest.json`, `docs/capability-inventory.md`, `docs/subagent-context-protocol.md`, and relevant `AGENTS.md` files.
   - Check whether the user cares about all repository components or one profile.

2. Run the read-only budget analyzer when available.
   - All components: `python3 scripts/analyze-context-budget.py --repo .`
   - Profile view: `python3 scripts/analyze-context-budget.py --repo . --profile full-reviewed`
   - Machine output: `python3 scripts/analyze-context-budget.py --repo . --profile full-reviewed --json`

3. Classify each finding.
   - `always`: loaded or expected in the selected profile.
   - `optional`: useful by domain, but not always loaded.
   - `review`: useful only after explicit review.
   - `curated`: source material, not default runtime.
   - `candidate-prune`: deprecated, archived, stale, duplicate, or too costly for value.

4. Recommend action without applying it.
   - Keep concise components as-is.
   - Split or summarize heavy always-loaded docs.
   - Move rare workflows to optional/review profiles.
   - Prefer lazy skill loading over global instructions.
   - Recommend pruning only when recurrence/value evidence is weak.

## Output

Return:

```text
Context Budget Summary:
Largest components:
Possible duplication:
Recommended savings:
No-change items:
Human gates:
```

Do not expose secrets, runtime caches, session logs, or local observation logs.
