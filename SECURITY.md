# Security Policy

## Supported Scope

Security review applies to:

- Workspace scripts.
- Skills and custom agents.
- Installation procedures.
- Documentation that affects operational behavior.

This repository must not contain credentials, access tokens, private logs, corporate data exports, or Codex runtime state.

## Reporting A Vulnerability

Open a private security advisory when the repository is hosted on GitHub. If private advisories are unavailable, contact the maintainer directly and avoid posting secrets or exploit details in a public issue.

Include:

- Affected file or workflow.
- Impact.
- Reproduction steps without real secrets.
- Suggested mitigation, if known.

## Secret Handling

- Never commit `~/.codex/auth.json`, logs, sqlite state, browser profiles, or token files.
- Do not paste real API keys, Databricks tokens, GitHub tokens, cookies, or OAuth material into docs or tests.
- Use placeholders such as `<TOKEN>` in examples.

## Validation

Run the repository healthcheck before committing. It includes lightweight secret-pattern scanning, but it is not a substitute for manual review.
