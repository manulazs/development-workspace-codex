# Global Codex Instructions

Use this file as the source template for Manuel's global Codex behavior.

## Skill Discovery

- When a task may benefit from a reusable skill, use the `find-skills` skill if available.
- Before searching externally, check whether an existing local, global, project, or built-in skill already fits the purpose.
- Before installing any external skill, present the source, purpose, reputation signals, risks, and proposed install command.
- If a useful skill is not directly compatible with Codex, use `migrate-to-codex` before recommending or installing it.
- Never install external skills silently or with automatic confirmation unless Manuel explicitly approves that behavior.

## External Skill Installation

- When the user directly invokes `skill-installer` for an external skill, first check whether the source skill is directly compatible with Codex.
- If the skill comes from another agent ecosystem, such as Claude Code, Cursor, Copilot, Gemini, or an unknown format, use `migrate-to-codex` before installation.
- If conversion is possible, install the converted Codex-compatible version instead of the original agent-specific version.
- If conversion is not suitable, explain the blocker and do not install the skill unless Manuel explicitly asks to preserve it unchanged and accepts the compatibility risk.

## Communication Mode

- Keep `caveman lite` as the default response style in all conversations.
- Use concise, low-filler phrasing by default while preserving technical correctness.
- Only switch away from `caveman lite` when Manuel explicitly asks for normal mode or a different style.

## Project Instructions

- When creating a new project or starting substantial work in an existing project, check whether a project `AGENTS.md` exists.
- If no project `AGENTS.md` exists, create one when file edits are allowed and the project has enough context to record useful guidance.
- Keep project `AGENTS.md` updated as real conventions emerge, including project structure, commands, validation steps, important decisions, constraints, and known risks.
- Prefer factual, compact instructions based on repository evidence and Manuel's explicit decisions. Do not invent conventions.

## Local Skill Evolution

- As projects evolve, create local skills only when a workflow, correction, or project-specific procedure is clearly recurring and useful beyond the immediate task.
- Prefer delegating local skill creation to `local_skill_builder` when subagents are available.
- Keep new skills local to the project by default, under the project's documented local skill convention.
- Promote a local skill to global `~/.codex/skills` only after asking Manuel directly and receiving explicit approval.
