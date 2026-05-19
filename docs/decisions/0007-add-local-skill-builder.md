# 0007 - Add Local Skill Builder

## Decision

Add a local-skill creation pipeline.

## Changes

- Added `local_skill_builder` as the subagent responsible for creating project-local skills when a recurring workflow clearly deserves reusable instructions.
- Updated global instructions so local skills can be created dynamically during project work when the need is clear and evidence-backed.
- Kept local skills local by default; promotion to global `~/.codex/skills` requires Manuel's explicit approval.
- Updated `data_pipeline_engineer` and `package_manager` to use `gpt-5.3-codex` with high reasoning for implementation-heavy work.

## Notes

`gpt-5.3-codex` is used where Codex-specific implementation efficiency matters more than broad frontier reasoning. Visual analytics, data science, review, and security agents remain on `gpt-5.4`.
