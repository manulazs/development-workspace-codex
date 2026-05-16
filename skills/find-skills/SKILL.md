---
name: find-skills
description: Helps discover, evaluate, and install agent skills when the user asks for specialized capabilities, while first checking whether an existing local or already-available skill can satisfy the need. Use when the user asks how to extend Codex, find a skill, install a skill, compare skill options, or search for reusable agent workflows.
---

# Find Skills

This skill helps discover and install skills from the open agent skills ecosystem without skipping local reuse, quality checks, or user approval.

## Core Rule

Before searching externally, check whether an already-available skill can satisfy the user's need.

Look for:

- Skills already listed in the current Codex session.
- Skills installed globally under `~/.codex/skills`.
- Project-local skills under `.agents/skills`, `.codex/skills`, or another project convention if documented.
- Built-in plugin skills already available in the environment.

If an existing skill is good enough, use it or recommend it. Do not search for or install another skill just because an external option might exist.

## When To Use This Skill

Use this skill when the user:

- Asks "how do I do X" where X might be a common task with an existing skill.
- Says "find a skill for X" or "is there a skill for X".
- Asks whether Codex can gain a specialized capability.
- Wants to extend agent capabilities.
- Wants to search for tools, templates, or workflows.
- Mentions recurring work that may deserve a reusable skill.

Do not use this skill for simple answers, one-off implementation details, or tasks already covered by a clearly applicable skill.

## Workflow

### Step 1: Understand The Need

Identify:

1. The domain, such as React, testing, Power BI, Databricks, design, deployment, or documentation.
2. The concrete task.
3. Whether this is recurring or specialized enough to justify a skill.
4. Whether using a skill would improve quality, consistency, safety, or speed.

### Step 2: Check Existing Skills First

Inspect the current environment before external discovery.

Prefer local or already-enabled skills when:

- They directly match the task.
- They are maintained in the user's own workspace.
- They encode project-specific or user-specific workflow rules.
- They avoid unnecessary installation or network access.

If an existing skill partially fits, decide whether to:

- Use it as-is.
- Use it with explicit caveats.
- Recommend updating that skill instead of installing a new one.
- Continue external search because the gap is material.

### Step 3: Search Trusted External Sources

If no existing skill is sufficient, search external sources.

Prefer:

- `skills.sh` leaderboard and skill pages.
- Official or well-known repositories such as `vercel-labs`, `anthropics`, `microsoft`, `openai`, or other reputable maintainers.
- GitHub repositories with clear documentation and meaningful maintenance signals.

Use the Skills CLI when available:

```bash
npx skills find [query]
```

Examples:

- `npx skills find react performance`
- `npx skills find pr review`
- `npx skills find changelog`
- `npx skills find power bi`

Network commands require approval when the environment asks for it.

### Step 4: Verify Quality Before Recommending

Do not recommend a skill based only on a search result.

Check:

- Fit for the user's actual task.
- Install count, when available.
- Source reputation.
- GitHub stars or project credibility.
- Last update or visible maintenance, when relevant.
- Whether the skill contains only instructions or also scripts that should be reviewed.
- Whether it asks for risky behavior such as broad automation, secret handling, destructive commands, or silent installation.

Be cautious with unknown maintainers, very low installs, unclear READMEs, or skills that require broad permissions.

### Step 5: Present Options

When relevant skills are found, present:

- Skill name.
- What it does.
- Why it fits the current need.
- Source and reputation signals.
- Installation command.
- Link to the source or skill page.
- Risks or limitations.

If multiple skills are plausible, compare them briefly and recommend one.

### Step 6: Ask Before Installing

Never install a skill silently.

Do not use automatic confirmation flags such as `-y` unless the user explicitly asks for unattended installation and the risk is low.

Prefer commands that keep confirmation visible, for example:

```bash
npx skills add <owner/repo@skill> -g
```

For Codex-native installs from GitHub, prefer the built-in `skill-installer` workflow when available.

Before installation, state:

- What will be installed.
- Where it will be installed.
- Why it is useful.
- The command or installer path that will be used.

Proceed only after explicit user approval.

### Step 7: If No Skill Fits

If no relevant skill exists:

1. Say that no suitable skill was found.
2. Offer to help directly using general capabilities.
3. If the workflow is recurring, suggest creating a custom skill.

## Common Categories

| Category | Example Queries |
| --- | --- |
| Web Development | react, nextjs, typescript, css, tailwind |
| Testing | testing, jest, playwright, e2e |
| DevOps | deploy, docker, kubernetes, ci-cd |
| Documentation | docs, readme, changelog, api-docs |
| Code Quality | review, lint, refactor, best-practices |
| Design | ui, ux, design-system, accessibility |
| BI And Data | power bi, dax, sql, databricks, tableau |
| Productivity | workflow, automation, git |

## Search Tips

- Use specific keywords.
- Try alternate terms if results are weak.
- Prefer official or well-maintained sources.
- Treat local custom skills as higher-priority when they encode user or project context.

