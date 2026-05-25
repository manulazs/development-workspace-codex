# MCP Governance

Last reviewed: 2026-05-25

This repository may document MCP candidates, but it does not install or enable MCP servers by default. MCP adoption is a consumer-runtime decision because MCPs can add context load, network access, credentials, tool permissions, and supply-chain risk.

## Rules

- Prefer native Codex tools, local CLI commands, official APIs, or existing skills before adding an MCP.
- Keep active MCP servers below 10 unless a project has a documented reason for more.
- Never commit real tokens, cookies, API keys, account IDs, or private URLs.
- Use placeholders for environment variables and document required credentials.
- Treat MCPs that run `npx`, `uvx`, remote HTTP endpoints, browser automation, filesystem access, or deployment tools as review-gated.
- Do not add MCPs to `workspace-manifest.json` profiles until installer behavior, permissions, and validation are explicit.
- Runtime-global MCP writes require explicit user approval and must stay separate from repository healthchecks.

## Candidate Catalog

| MCP | Status | Purpose | Risk | Use when | Do not use when |
| --- | --- | --- | --- | --- | --- |
| `github` | `review` | GitHub issues, PRs, repos, and metadata. | Requires token and broad repo access. | Native GitHub app/tooling is unavailable or insufficient. | CLI/app tools already cover the task. |
| `context7` | `review` | Current framework/library documentation lookup. | External docs query; possible context overhead. | Official docs are needed and local/browser sources are insufficient. | The answer is stable or local docs exist. |
| `playwright` | `review` | Browser automation through MCP. | Browser/runtime dependency and possible private page data. | Native browser or local Playwright helpers are unavailable. | Existing `webapp-testing` skill/tooling covers validation. |
| `memory` | `review` | Persistent memory across sessions. | Privacy and stale-memory risk. | A consumer explicitly wants local memory with retention policy. | Repository-local observations are sufficient. |
| `sequential-thinking` | `review` | Structured reasoning tool. | Token overhead and possible redundancy with model reasoning. | A project has a measured need for tool-mediated reasoning. | Normal planning skills are enough. |
| `exa-web-search` | `review` | External web research. | API key, cost, and data-sharing risk. | Broad research requires an approved paid/search provider. | Built-in web/search or primary docs are enough. |
| `filesystem` | `review` | Filesystem operations outside normal workspace. | Broad local file access. | A narrow approved path is required. | Codex filesystem access already covers the workspace. |

## Adoption Checklist

- [ ] Source, package, version, license, and maintainer are recorded.
- [ ] Credential names are placeholders only.
- [ ] Tool count and expected context overhead are known.
- [ ] Permission scope is minimal and documented.
- [ ] Native tool or CLI alternatives were considered.
- [ ] Install and uninstall steps are dry-run capable.
- [ ] Runtime write is explicitly approved by the user.
- [ ] Security review covers prompt injection, data exfiltration, and overbroad tool access.

## Rejected ECC Surfaces For Now

- Claude Code hooks: Codex does not expose the same deterministic hook lifecycle, so hook behavior should be adapted into explicit validation scripts or policies instead.
- Full MCP catalog import: many entries require credentials, remote services, package execution, or deployment access.
- Command shims: this workspace is skills/docs/scripts-first.
- Runtime memory stores: use private `.codex-local/evolution/` observations before adopting broader persistent memory.
