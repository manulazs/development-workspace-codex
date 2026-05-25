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
- Harden Python validation for Windows/OneDrive by validating syntax without writing bytecode.
- Add safe Git index lock diagnostics to the Windows healthcheck.
- Extend continuous evolution with recurring reports and optional validation snapshots.
- Treat skill provenance as informational and remove provenance gates as active use/import blockers.
- Make `caveman lite` the mandatory repository communication standard and promote `caveman` to the core profile.
- Add data pipeline agent routing from source discovery through cataloging, science, analysis, and visualization.
- Add repository healthcheck validation for skill and agent naming conventions.
- Update planning skills to emit implementation-time `Subagent Execution Plan` guidance.
- Add `qa_reviewer` and `markdown_writer` subagent templates.
- Require subagents to avoid `/fast` and use normal 1:1 execution.
- Add a subagent context protocol with context budgets, return budgets, `fork_context` guidance, compact return contracts, and evolution validation for subagent efficiency rules.
- Relax the one-subagent policy so independent research, docs, validation, and Git/release lanes can run in parallel when scopes are disjoint and coordination cost is justified.
- Require coherent milestone commits for authorized work in Git repositories, with final push gated by review/validation and explicit user confirmation; require missing project `AGENTS.md` files to be created and maintained.
- Add explicit Caveman LITE activation validation and installer support for copying the global Codex instruction template into a runtime.

## 2026-05-19

- Added governance healthcheck and install workflows.
- Added workspace audits, lessons, patterns, operations, and runbooks.
- Added subagent policy and capability inventory.
- Set `security_auditor` to read-only.
