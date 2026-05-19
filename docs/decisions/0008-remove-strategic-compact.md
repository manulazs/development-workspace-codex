# 0008 - Remove Strategic Compact Skill

Status: historical. The lasting policy is to remove duplicated capabilities instead of maintaining parallel workflow surface.

## Decision

Remove the custom context-compaction skill from the workspace and global Codex install.

## Rationale

Codex runtimes may provide native compaction commands. Maintaining a parallel manual compaction skill would duplicate native behavior and add unnecessary workflow surface when the native command is available.

## Changes

- Removed the workspace copy of the skill from `skills/strategic-compact`.
- Removed the skill from runtime-loadable repository paths.
- Removed the skill from the reproducible capability list.
