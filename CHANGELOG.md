# Changelog

All notable changes to this workspace are tracked here.

## Unreleased

- Improve the public README narrative and add a canonical executive summary that explains the workspace model, profiles, capabilities, validation, self-improvement loop, and safety gates.
- Add `context-budget-audit` and `verification-loop` core skills as Codex-native adaptations of useful ECC context-budget and verification patterns.
- Add read-only `scripts/analyze-context-budget.py` and `scripts/workspace-doctor.py`, wired into healthchecks for context footprint and profile drift checks.
- Add `docs_researcher` and `test_automation_engineer` optional subagents, with routing precedence ahead of `workspace_implementer` for documentation research and test automation work.
- Add `docs/mcp-governance.md` and ADR 0020 to record accepted/rejected ECC patterns without importing hooks, MCP defaults, command shims, or runtime repair flows.
- Add `frontend_ui_engineer` and `api_backend_engineer` optional specialist subagents so frontend web/UI and API/backend work do not fall through to the generic implementer.
- Tune `data_discovery_researcher` and `data_catalog_taxonomist` to smaller model classes for bounded read-only research and metadata work while keeping strong models for implementation, review, security, BI, and data science.
- Document specialist precedence for frontend/API lanes across subagent policy, global instructions, data pipeline routing, and agentic controls.
- Clarify `plan-deep-skills` as a capability-audit planner distinct from base `plan-deep`, resolving the last structural overlap finding.
- Add `workspace_implementer`, a core fallback implementation subagent for scoped practical repository edits when no specialist subagent is a better fit.
- Document implementation-routing precedence across repository and global instruction templates: main agent owns orchestration and integration, specialists have priority, `workspace_implementer` is fallback, and simple low-context edits stay in the main thread.
- Clarify that multiple `workspace_implementer` instances may run in one broader task set only for disjoint implementation lanes with clear context or token savings.
- Clarify that `workspace_implementer` should be preferred over main-thread implementation when no specialist fits and delegation is expected to reduce token or context load.
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
- Add Codex-native task-observer adaptation with private observation templates, staged update guidance, cross-cutting principle rules, and observation validation.

## 2026-05-19

- Added governance healthcheck and install workflows.
- Added workspace audits, lessons, patterns, operations, and runbooks.
- Added subagent policy and capability inventory.
- Set `security_auditor` to read-only.
