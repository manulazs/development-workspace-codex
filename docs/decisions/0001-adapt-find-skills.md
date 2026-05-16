# 0001 - Adapt `find-skills`

## Decision

Use Vercel Labs' `find-skills` skill as the base idea, but maintain a local adapted version in this repository.

## Reason

The original skill is useful for discovering skills in the open agent skills ecosystem, but Manuel's Codex environment should first reuse existing local, global, project, or built-in skills before searching externally.

The adapted version also avoids silent installation. External skills should be reviewed and explicitly approved before installation.

## Source

- Original: https://github.com/vercel-labs/skills/blob/main/skills/find-skills/SKILL.md
- Local adapted copy: `skills/find-skills/SKILL.md`

