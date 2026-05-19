# 0007 - Add Local Skill Builder

Status: updated by the current public-template policy. Promotion rules are now consumer-controlled and profile-based.

## Decision

Add a local-skill creation pipeline.

## Changes

- Added `local_skill_builder` as the subagent responsible for creating project-local skills when a recurring workflow clearly deserves reusable instructions.
- Updated global instructions so local skills can be created dynamically during project work when the need is clear and evidence-backed.
- Kept local skills local by default; promotion to a broader shared runtime or repository requires explicit consumer approval.
- Updated `data_pipeline_engineer` and `package_manager` to use `gpt-5.3-codex` with high reasoning for implementation-heavy work.

## Notes

The specific model names recorded here are historical. Current guidance should choose models by task risk, complexity, and consumer availability.
