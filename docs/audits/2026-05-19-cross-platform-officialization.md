# Cross-Platform Officialization Audit - 2026-05-19

Status: historical and partially superseded by the public-template rewrite.

## Scope

This audit captured the state after cross-platform scripts, public repository documentation, self-improvement lifecycle, subagent lifecycle, capability lifecycle, GitHub templates, and CI matrix were first added.

It should not be used as current policy for runtime installation or repository health.

## Historical Validations

- Windows repository healthcheck passed at the time.
- Windows install preview was non-mutating at the time.
- `migrate-to-codex --validate-target .` passed at the time.
- macOS/Linux execution depended on CI because local bash execution was unavailable on the maintainer host.

## Superseded Items

- Install preview no longer means copying every skill and agent. Current installers copy explicit adoption profiles only.
- Runtime installation gaps are no longer repository health gaps.
- Local Python dependency gaps are not public repository state unless they affect repository-local validation.
- Current docs must use `workspace-manifest.json` and `docs/capability-inventory.md` as the active adoption sources.

## Lasting Decisions

- Keep Windows and macOS/Linux validation paths.
- Keep public repository files and CI validation.
- Keep explicit self-improvement, subagent, and capability lifecycle docs.
- Keep audits as historical records, but mark superseded runtime assumptions clearly.
