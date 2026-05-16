---
name: convert-skill-to-codex
description: Converts or adapts third-party agent skills, especially Claude Code or other non-Codex skills, into Codex-compatible skill folders. Use when a useful external skill is not directly compatible with Codex, when find-skills flags a compatibility gap, or when the user asks to port, adapt, normalize, or install a skill from another agent ecosystem.
---

# Convert Skill To Codex

Convert third-party agent skills into concise, safe, Codex-compatible skills.

## Use This Skill When

- `$find-skills` finds a useful skill that is not directly Codex-compatible.
- A skill is written for Claude Code, Cursor, Copilot, Gemini, or another agent environment.
- The user asks to port, adapt, normalize, or prepare a skill for Codex.
- A skill has useful instructions but incompatible paths, metadata, tools, hooks, commands, or install assumptions.

Do not use this skill when the external skill is already Codex-compatible and only needs normal installation.

## Conversion Goals

Produce a Codex skill folder that follows this structure:

```text
skill-name/
├── SKILL.md
└── agents/
    └── openai.yaml
```

Add `references/`, `scripts/`, or `assets/` only when they are necessary for the skill to work. Keep `SKILL.md` focused and under 500 lines.

## Workflow

### Step 1: Inspect The Source

Read the source skill before converting it.

Identify:

- Original name, source URL, maintainer, and license if visible.
- Intended task and trigger conditions.
- Files that are core to the skill.
- Files that are documentation, examples, or agent-specific setup noise.
- Any scripts, hooks, MCP assumptions, commands, model names, or tool calls.

Do not execute remote scripts during inspection.

### Step 2: Assess Compatibility

Classify the source as:

- `compatible`: already usable as a Codex skill.
- `convertible`: useful but needs adaptation.
- `not suitable`: too risky, unclear, unsupported, or not worth porting.

Conversion is usually needed when the source depends on:

- Claude-specific files such as `CLAUDE.md`, `.claude/`, commands, hooks, or slash-command workflows.
- Agent-specific tool names that Codex does not expose.
- Automatic install flags, broad filesystem changes, credential handling, or destructive commands.
- Metadata formats that do not include Codex `SKILL.md` frontmatter with `name` and `description`.

If the source is not suitable, stop and explain the blocker.

### Step 3: Design The Codex Skill

Normalize:

- Folder name: lowercase letters, digits, and hyphens only.
- Frontmatter: include clear `name` and trigger-focused `description`.
- Body: keep only essential workflow instructions.
- UI metadata: add `agents/openai.yaml` with `display_name`, `short_description`, and a `default_prompt` mentioning `$skill-name`.

Prefer high-level procedural instructions over copied platform-specific text.

### Step 4: Translate Agent-Specific Behavior

Convert concepts, not vendor-specific mechanics.

Use these mappings:

| Source Pattern | Codex Adaptation |
| --- | --- |
| Claude slash command | Explain when the skill should trigger or how the user can invoke it |
| Claude hook | Convert to an explicit workflow step or safety rule |
| Claude subagent command | Describe when Codex should propose subagents and require user approval |
| Agent-specific MCP/tool | Name the required capability and use Codex tools only if available |
| Auto-install command | Replace with review-first and approval-first installation |
| Long README instructions | Keep essentials in `SKILL.md`; move optional detail to `references/` |

Do not claim a Codex capability exists unless it is available in the current environment or documented as a requirement.

### Step 5: Preserve Attribution

If the converted skill is based on an external source, preserve attribution in the repository decision notes or skill comments when useful.

Do not include large copied passages when a concise adapted workflow is enough.

### Step 6: Validate

Before installation, check:

- `SKILL.md` exists.
- Frontmatter has `name` and `description`.
- `agents/openai.yaml` strings are quoted when required by the OpenAI skill guidance.
- The skill does not include secrets, tokens, local logs, internal state, or unrelated docs.
- The skill does not instruct Codex to bypass user approval for installs, destructive commands, or broad permissions.
- Any scripts are necessary, readable, and safe to run only after approval when they need network or broad access.

Run the local skill validation helper when dependencies are available. If validation cannot run, state why and do a structural check.

### Step 7: Present The Result

Report:

- Compatibility classification.
- Files created or changed.
- Key behavior changes from the original.
- Unsupported source features, if any.
- Whether installation is recommended.
- The exact install or copy command, if the user approves installation.

Do not install the converted skill globally until the user has approved that action, unless the user already requested installation in the current task.

## Hard Limits

- Do not run remote scripts just to inspect a skill.
- Do not copy credentials, tokens, logs, databases, or private data into a skill.
- Do not preserve instructions that bypass approval, hide network activity, or make destructive changes.
- Do not convert unsupported tool calls into fake Codex capabilities.
- Do not add long auxiliary documentation inside the skill folder unless it is directly needed by the skill.

