# 0005 - Cleanup Data And BI Skills

## Decision

Clean up duplicated and overlapping skills, adapt selected third-party skills for Codex compatibility, and add data/BI-focused skills.

## Changes

- Removed user-level `openai-docs` because Codex already provides a system `openai-docs` skill.
- Removed Anthropic `xlsx` and replaced it with `spreadsheet`.
- Removed Anthropic `pptx` because the enabled Presentations plugin already owns presentation workflows.
- Removed `caveman-help`; kept `caveman`, `caveman-commit`, and `caveman-compress`.
- Converted `agent-browser` frontmatter by removing unsupported metadata and changing its trigger language so it does not override the built-in Browser plugin by default.
- Adapted `web-artifacts-builder` and `canvas-design` wording from Claude-specific phrasing to Codex/local artifact phrasing.
- Added `powerbi-expert` from `personamanagmentlayer/pcl` with Codex-valid frontmatter.
- Added dbt Labs skills from `dbt-labs/dbt-agent-skills`.

## Notes

The official `openai/skills` repository no longer exposed `skills/.curated/spreadsheet` through the GitHub tree at the time of installation, although the skill remains published on `skills.sh`. The local `spreadsheet` skill was reconstructed from the published listing and source attribution is recorded in its frontmatter.

All installed user skills passed `skill-creator/scripts/quick_validate.py` after cleanup.
