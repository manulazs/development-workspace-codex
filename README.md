# Development Workspace Codex

Private, reproducible workspace for Manuel's Codex configuration, custom skills, and agentic workflow conventions.

## Contents

- `skills/`: custom or adapted Codex skills.
- `codex-global/`: templates for global Codex instructions.
- `docs/decisions/`: short technical decisions explaining why the workspace is structured this way.

## Current Skills

- `find-skills`: adapted from Vercel Labs' `find-skills` skill with two local rules:
  - check already-available skills before searching externally;
  - never install skills silently or with automatic confirmation unless explicitly approved.

## Reproduce Locally

From this repository root:

```bash
mkdir -p ~/.codex/skills
cp -R skills/find-skills ~/.codex/skills/find-skills
```

Restart Codex after installing or updating skills so the new skill metadata is picked up.

## Repository Policy

This repository should remain private. It may contain workflow preferences and local environment conventions, but it must not contain credentials, tokens, logs, private data exports, or Codex internal state files.

