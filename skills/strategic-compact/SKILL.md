---
name: strategic-compact
description: Manual-only Codex context compaction checklist. Use only when Manuel explicitly invokes $strategic-compact or asks to run the strategic compact skill; do not auto-trigger because Codex already has strong automatic compaction.
metadata:
  short-description: Manual context compaction checklist
  source: "Adapted from affaan-m/ECC strategic-compact"
  source-url: "https://github.com/affaan-m/ECC/blob/main/.agents/skills/strategic-compact/SKILL.md"
---

# Strategic Compact

Use this skill only when Manuel explicitly invokes `$strategic-compact` or directly asks to use the strategic compact skill.

Codex already has strong automatic compaction. This skill does not replace it, does not install hooks, and must not suggest compaction automatically. It exists for manual checkpointing before a deliberate context reset.

## Goal

Prepare a concise compaction handoff at a logical boundary so the next context keeps the durable facts and loses only noisy exploration.

## When It Makes Sense

Use manual compaction only at clear boundaries:

- after exploration, before implementation;
- after a plan is finalized;
- after completing a milestone;
- after debugging a dead end;
- before switching to an unrelated task;
- when the user explicitly asks to compact.

Avoid compaction:

- mid-implementation;
- while unresolved tool output still matters;
- before important file paths, commands, risks, or user decisions are written down;
- when the next step depends on details that are only in the current conversation.

## Procedure

1. Identify the boundary.
   - State why compaction is useful now.
   - If the boundary is weak, say not to compact yet.

2. Preserve durable context.
   - Current goal and success criteria.
   - Files, modules, commands, and validation results.
   - Decisions made by Manuel.
   - Known blockers, risks, and follow-up steps.
   - Git state when relevant.

3. Drop noise.
   - Exploratory dead ends.
   - Repeated command output.
   - Superseded assumptions.
   - Verbose reasoning that is no longer needed.

4. Produce a compact handoff.
   - Write a short summary the user can use as the compaction prompt.
   - Include only actionable, durable state.
   - Mention what should be verified after compaction.

## Output Format

Return:

- `Compactar agora?` with `sim` or `nao`;
- reason in one short paragraph;
- `Resumo para compactacao` as a compact handoff;
- `Retomar por` with the exact next action.

Do not run commands, edit files, or trigger compaction yourself.
