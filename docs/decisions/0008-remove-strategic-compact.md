# 0008 - Remove Strategic Compact Skill

## Decision

Remove the custom context-compaction skill from the workspace and global Codex install.

## Rationale

Codex now has the native `/compactar` command available in Manuel's environment. Maintaining a parallel manual compaction skill would duplicate native behavior and add unnecessary workflow surface.

## Changes

- Removed the workspace copy of the skill from `skills/strategic-compact`.
- Removed the global installed copy from `~/.codex/skills/strategic-compact`.
- Removed the skill from the reproducible install list in `README.md`.
