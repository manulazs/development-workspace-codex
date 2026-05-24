# 0014 - Subagent Context Efficiency Protocol

Date: 2026-05-24

## Status

Accepted

## Context

The workspace already governed when to use subagents, but the handoff contract was still too loose. A plan could recommend delegation without specifying how much context to send, whether full thread context was needed, how much output should come back, or how the main agent should keep active scopes separate.

That ambiguity can waste tokens, duplicate work, and make subagents return raw logs or broad excerpts that the main agent then has to compress again.

## Decision

Add `docs/subagent-context-protocol.md` as the canonical protocol for efficient subagent handoffs.

Require planning and governance docs to include:

- context budget;
- return budget;
- `fork_context` expectation;
- bounded read/write scope;
- compact result contract;
- validation signal;
- conflict-risk and fallback guidance.

Update custom agent templates so each agent accepts compact parent-provided context, avoids full-thread context unless essential, returns concise evidence, and has generic model fallback guidance.

Extend `scripts/evolve-workspace.py` so recurring evolution checks detect custom agents that are missing no-fast-mode, context-package, compact-return, or model-fallback rules.

## Consequences

- Delegation recommendations become more operational and easier to execute without bloating the main context.
- Subagents remain normal 1:1 executions and must not use `/fast`.
- The repository still does not authorize spawning by itself; runtime tools and user/developer permissions control execution.
- More metadata appears in generated task catalogs, but it is compact and machine-readable.
