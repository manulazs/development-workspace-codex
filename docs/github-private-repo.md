# GitHub Repository Publishing

Status: historical filename, current public-template guidance.

This repository is designed to be public, portable, and reusable. Consumers may still keep forks private when their adaptations contain private policies, internal tools, or organization-specific context.

Recommended repository name:

```text
development-workspace-codex
```

## Public Repository

Create a public repository when the content contains only reusable template material:

```bash
gh repo create development-workspace-codex --public --source . --remote origin --push
```

## Private Fork Or Internal Adaptation

Use a private repository when the fork contains private organizational rules, internal system names, logs, exports, credentials, or non-public business context:

```bash
gh repo create development-workspace-codex --private --source . --remote origin --push
```

## Existing Empty Repository

```bash
git remote add origin git@github.com:<owner>/development-workspace-codex.git
git push -u origin main
```

Replace `<owner>` with the GitHub user or organization that owns the repository.

## Safety Rule

Do not push credentials, tokens, logs, local databases, runtime state, cache files, sessions, auth files, corporate data exports, or private workspace assumptions.
