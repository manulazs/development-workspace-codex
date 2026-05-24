# Capability Proposal: qa_reviewer

Date: 2026-05-24
Kind: `agent`
Status: `core`

## Purpose

Read-only QA reviewer for acceptance criteria, test coverage, validation gaps, release readiness, and residual risk.

## Existing Capability Check

- Existing agents reviewed: `code_reviewer`, `security_auditor`.
- Existing skills/runbooks reviewed: `plan-deep`, `plan-deep-skills`, `continuous-evolution`, `docs/subagents-policy.md`.
- Why reuse is insufficient: `code_reviewer` focuses on code defects and regressions, while `security_auditor` focuses on security. QA readiness needs a broader acceptance and validation-gap review that is not necessarily code-only or security-only.

## Scope

- Read scope: changed files, plans, acceptance criteria, validation outputs, docs, tests, and release notes.
- Write scope: none.
- Explicitly out of scope: implementing fixes, staging, committing, pushing, installing runtime artifacts, or changing configuration.

## Model And Permissions

- Suggested model class: strong general reasoning model.
- Fallback if unavailable: default strong model.
- Reasoning level: high.
- Sandbox mode: `read-only`.
- Network need: none by default.
- Escalation risk: low.

## Inputs And Outputs

- Required input context: task goal, plan, acceptance criteria, changed files, and validation outputs.
- Expected output: findings, test gaps, residual risks, and recommended next action.
- Validation signal: reviewer cites evidence and distinguishes blockers from non-blocking risks.
- Exit criteria: acceptance risks are reported clearly enough for the main agent to integrate.

## Risks

- Overlap risk: adjacent to `code_reviewer`, but scoped to acceptance, validation, and release readiness.
- Safety risk: low because read-only.
- Maintenance risk: low; retire if `code_reviewer` fully absorbs QA readiness review.

## Inventory And Manifest

- Manifest status: `core`.
- Inventory row updated: yes.
- Review date: 2026-05-24.
