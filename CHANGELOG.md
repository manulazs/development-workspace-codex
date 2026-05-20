# Changelog

All notable changes to this workspace are tracked here.

## Unreleased

- Reposition the repository as a public, portable Codex workspace template rather than a mirror of local `~/.codex` state.
- Add `workspace-manifest.json` with reusable adoption profiles and capability status classification.
- Change install scripts to profile-based optional adoption with `-WhatIf`/`--dry-run`.
- Change healthchecks to validate repository integrity instead of local runtime synchronization.
- Reclassify skills and subagent templates with `core`, `optional`, `curated`, `review`, `deprecated`, and `archived` statuses.
- Add `.gitattributes` so shell scripts keep LF line endings across Windows and macOS/Linux clones.
- Prepare public repository documentation.
- Add cross-platform setup and validation scripts.
- Formalize self-improvement, subagent, and capability lifecycles.
- Add GitHub issue and pull request templates.
- Add Windows/macOS GitHub Actions validation matrix.
- Record final cross-platform officialization audit.
- Add skill provenance gates, agentic control boundaries, repository-local skill validation, and stricter CI dry-run coverage.
- Add `caveman lite` as the global template communication style and reclassify `caveman` as an optional adoption capability.
- Add governed continuous-evolution automation with task cataloging, anti-duplication review, subagent handoff protocol, and validation gates.
- Add capability scaffolding for governed skill and agent proposals with duplicate checks and core human gates.

## 2026-05-19

- Added governance healthcheck and install workflows.
- Added workspace audits, lessons, patterns, operations, and runbooks.
- Added subagent policy and capability inventory.
- Set `security_auditor` to read-only.
