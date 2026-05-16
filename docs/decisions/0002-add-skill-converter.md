# 0002 - Add `convert-skill-to-codex`

## Decision

Create a local `convert-skill-to-codex` skill and update `find-skills` to call it when an external skill is useful but not directly compatible with Codex.

## Reason

Many useful agent skills are written for Claude Code or other agent environments. Installing them unchanged can preserve incompatible commands, hooks, paths, tool names, or unsafe assumptions.

The converter skill creates a review-first workflow for adapting the useful parts of those skills into Codex's skill format while preserving source attribution and user approval boundaries.

## Policy

- Check existing local/global/project skills first.
- Search externally only when needed.
- Verify quality and Codex compatibility before recommending installation.
- Convert non-Codex skills before installation.
- Do not silently install converted or external skills.

