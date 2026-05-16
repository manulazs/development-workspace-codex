# Private GitHub Repository Setup

This workspace is intended to be stored in a private GitHub repository.

Recommended repository name:

```text
development-workspace-codex
```

## Option 1: GitHub CLI

From the repository root:

```bash
gh repo create development-workspace-codex --private --source . --remote origin --push
```

## Option 2: Existing Empty Private Repository

Create an empty private repository on GitHub, then run:

```bash
git remote add origin git@github.com:<owner>/development-workspace-codex.git
git push -u origin main
```

Replace `<owner>` with the GitHub user or organization that owns the repository.

## Privacy Rule

Keep the repository private unless Manuel explicitly decides otherwise.

Do not push credentials, tokens, logs, local databases, corporate data exports, or Codex internal state.

