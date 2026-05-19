# Workspace Health

Last reviewed: 2026-05-19

## Definition

Repository health means the public template is internally consistent, safe to clone, and ready for consumers to evaluate or adopt by profile.

It does not mean any maintainer's private `~/.codex` runtime matches this repository.

## Healthcheck Scope

The standard healthcheck validates:

- required repository directories and canonical docs;
- `workspace-manifest.json` parses and classifies real files;
- every skill directory has `SKILL.md` with required frontmatter;
- every custom agent TOML has required fields;
- adoption profiles reference only installable statuses;
- `docs/capability-inventory.md` mentions all tracked skills and agents;
- install scripts support safe preview (`-WhatIf` or `--dry-run`);
- basic tracked-file secret patterns;
- repository-local validators when their dependencies are available.

The standard healthcheck intentionally does not validate:

- whether any profile has been copied into `~/.codex`;
- whether a consumer has restarted Codex after local adoption;
- local auth, sessions, caches, logs, or private runtime state;
- private corporate data or tools outside the repository.

## Commands

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1
```

macOS/Linux:

```bash
scripts/healthcheck.sh
```

Strict mode treats warnings as failures:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1 -Strict
```

```bash
scripts/healthcheck.sh --strict
```

## Optional Runtime Checks

Runtime checks, if added later, must be separate, opt-in, and explicitly local. They must not be part of public repository health.

Acceptable runtime helpers may answer:

- which profile would be copied;
- which files differ in a consumer-selected target;
- whether a consumer runtime has required directories.

They must not make repository health depend on local installation state.

## Health Signals

Green:

- Manifest, inventory, docs, skills, agents, and installers are aligned.
- Healthcheck passes with 0 failures.
- Install preview is profile-based and non-destructive.
- No obvious secret patterns are tracked.

Yellow:

- Optional validators are unavailable because Python or tool dependencies are missing.
- Historical audits need clearer status labels.
- A capability remains in `review` longer than the review cadence allows.
- A large file exists and needs explicit justification.

Red:

- A profile references missing or non-installable capabilities.
- Inventory omits tracked skills or agents.
- Skill frontmatter or agent TOML is structurally invalid.
- Installer copies everything by default or lacks preview mode.
- Potential secrets, local runtime state, logs, caches, or sessions are tracked.

## Maintenance Cadence

- Run the repository healthcheck before and after structural changes.
- Update `workspace-manifest.json` and `docs/capability-inventory.md` in the same change set when skills or agents change.
- Review `review` and `curated` capabilities periodically.
- Promote recurring lessons only after recurrence is clear.
- Prune stale capabilities and docs during each review instead of only adding new material.
