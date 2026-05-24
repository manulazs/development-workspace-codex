# Capability Proposal: markdown_writer

Date: 2026-05-24
Kind: `agent`
Status: `optional`

## Purpose

Documentation writer for README, technical docs, executive summaries, changelogs, runbooks, and concise Markdown cleanup.

## Existing Capability Check

- Existing agents reviewed: `agents_md_maintainer`, `code_reviewer`.
- Existing skills/runbooks reviewed: `plan-deep`, `plan-deep-skills`, `continuous-evolution`, `docs/subagents-policy.md`.
- Why reuse is insufficient: `agents_md_maintainer` owns instruction files, not broader project docs. Documentation drafts can be bounded, mechanical, and context-heavy enough to justify a separate writer.

## Scope

- Read scope: repository docs, implemented behavior, validated commands, plans, and user decisions.
- Write scope: Markdown documentation files explicitly assigned by the parent agent.
- Explicitly out of scope: product code, scripts, lockfiles, commits, pushes, runtime-global files, and unvalidated claims.

## Model And Permissions

- Suggested model class: small or mid-size model for bounded documentation.
- Fallback if unavailable: default model with concise docs instructions.
- Reasoning level: high.
- Sandbox mode: `workspace-write`.
- Network need: none by default.
- Escalation risk: medium because it can write docs.

## Inputs And Outputs

- Required input context: doc target, audience, source evidence, validated commands, and scope limits.
- Expected output: changed docs, evidence used, validation performed, unresolved gaps, and recommended next action.
- Validation signal: docs match repository evidence and do not invent behavior.
- Exit criteria: docs are concise, accurate, and reviewable.

## Risks

- Overlap risk: adjacent to `agents_md_maintainer`, but broader and not specific to instruction files.
- Safety risk: medium; docs can overclaim if source evidence is weak.
- Maintenance risk: medium; retire if documentation work is better covered by a skill or project process.

## Inventory And Manifest

- Manifest status: `optional`.
- Inventory row updated: yes.
- Review date: 2026-05-24.
