# 0002 - Replace local converter with `migrate-to-codex`

## Decision

Use OpenAI's official `migrate-to-codex` skill instead of the local `convert-skill-to-codex` skill. Update `find-skills` to call `migrate-to-codex` when an external skill is useful but not directly compatible with Codex.

## Reason

Many useful agent skills are written for Claude Code or other agent environments. Installing them unchanged can preserve incompatible commands, hooks, paths, tool names, or unsafe assumptions.

OpenAI's official `migrate-to-codex` skill is more complete than the local converter because it includes a migration workflow, scripts, reports, validation, and references for migrating instructions, skills, agents, hooks, MCP configuration, and related Codex artifacts.

## Policy

- Check existing local/global/project skills first.
- Search externally only when needed.
- Verify quality and Codex compatibility before recommending installation.
- Use `migrate-to-codex` for non-Codex skills and migration surfaces before installation.
- Do not silently install converted or external skills.
