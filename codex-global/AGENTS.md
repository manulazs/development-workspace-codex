# Global Codex Instructions

Use this file as the source template for Manuel's global Codex behavior.

## Skill Discovery

- When a task may benefit from a reusable skill, use the `find-skills` skill if available.
- Before searching externally, check whether an existing local, global, project, or built-in skill already fits the purpose.
- Before installing any external skill, present the source, purpose, reputation signals, risks, and proposed install command.
- If a useful skill is not directly compatible with Codex, use `convert-skill-to-codex` before recommending or installing it.
- Never install external skills silently or with automatic confirmation unless Manuel explicitly approves that behavior.

## External Skill Installation

- When the user directly invokes `skill-installer` for an external skill, first check whether the source skill is directly compatible with Codex.
- If the skill comes from another agent ecosystem, such as Claude Code, Cursor, Copilot, Gemini, or an unknown format, use `convert-skill-to-codex` before installation.
- If conversion is possible, install the converted Codex-compatible version instead of the original agent-specific version.
- If conversion is not suitable, explain the blocker and do not install the skill unless Manuel explicitly asks to preserve it unchanged and accepts the compatibility risk.
