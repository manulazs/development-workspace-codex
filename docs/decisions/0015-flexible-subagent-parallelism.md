# 0015 - Flexible Subagent Parallelism

Date: 2026-05-24

## Status

Accepted

## Context

The earlier policy made the normal escalation path sound like `0 -> 1 -> rare multiple subagents`. That protected against over-delegation, but it could also discourage useful small parallel lanes. For example, Git hygiene, release notes, documentation cleanup, or bounded research may safely proceed while implementation or validation continues elsewhere.

## Decision

Replace the implied "only one subagent unless large project" rule with a flexible rule:

- use zero subagents for simple, linear, tightly coupled, or low-risk work;
- use one or more subagents when tasks are independent, bounded, and cheaper to delegate than to keep in the main context;
- use multiple subagents whenever lanes are disjoint and integration cost is justified;
- keep the immediate critical path, synthesis, conflict control, and final decision in the main thread.

Multiple subagents remain prohibited when they duplicate the same question, mutate overlapping files, depend on unsettled decisions, or create more coordination cost than value.

## Consequences

- The workspace can run small independent lanes in parallel, such as research plus Git hygiene or docs plus validation.
- The policy optimizes for context efficiency and non-conflicting ownership instead of a fixed subagent count.
- The main agent remains accountable for integration and validation.
- The `/fast` ban and normal 1:1 subagent execution rule remain unchanged.
