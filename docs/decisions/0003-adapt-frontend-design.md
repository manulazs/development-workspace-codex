# 0003 - Adapt Anthropic `frontend-design`

## Decision

Install a Codex-adapted version of Anthropic's `frontend-design` skill instead of installing the original unchanged.

## Reason

The source skill has a valid `SKILL.md`, but it comes from another agent ecosystem and includes Claude-specific wording. The local policy requires external skills from other agent ecosystems to be checked and converted when needed.

The adapted version preserves the purpose of the original skill while making the wording Codex-compatible and adding OpenAI-style `agents/openai.yaml` metadata.

## Source

- Original: https://github.com/anthropics/skills/tree/main/skills/frontend-design
- License: Apache-2.0, preserved in `skills/frontend-design/LICENSE.txt`

