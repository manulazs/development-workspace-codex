# Continuous Evolution Task Catalog

Generated: 2026-05-20

This catalog is generated from repository-visible metadata. It guides the main agent; it does not authorize runtime-global writes, commits, pushes, or destructive actions by itself.

## Automation Levels

| Level | Meaning |
| --- | --- |
| `catalog-only` | Record status; no edit implied. |
| `auto-fix-proposal` | Automation may draft a change, but review is expected before persistence. |
| `auto-edit-allowed` | Repository-local edits are allowed when scope is narrow and validation passes. |
| `human-gated` | Human approval is required before applying or merging the change. |

## Tasks

| ID | Priority | Segment | Title | Owner | Subagents | Automation | Human approval | Validation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| EVOL-PROVENANCE-adding-dbt-unit-test | P1 | skill-provenance | Resolve source/license evidence for `adding-dbt-unit-test`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-answering-natural-language-questions-with-dbt | P1 | skill-provenance | Resolve source/license evidence for `answering-natural-language-questions-with-dbt`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-auditing-skills | P1 | skill-provenance | Resolve source/license evidence for `auditing-skills`. | main-agent | security_auditor | `human-gated` | yes | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-building-dbt-semantic-layer | P1 | skill-provenance | Resolve source/license evidence for `building-dbt-semantic-layer`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-caveman | P1 | skill-provenance | Resolve source/license evidence for `caveman`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-configuring-dbt-mcp-server | P1 | skill-provenance | Resolve source/license evidence for `configuring-dbt-mcp-server`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-creating-mermaid-dbt-dag | P1 | skill-provenance | Resolve source/license evidence for `creating-mermaid-dbt-dag`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-fetching-dbt-docs | P1 | skill-provenance | Resolve source/license evidence for `fetching-dbt-docs`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-find-skills | P1 | skill-provenance | Resolve source/license evidence for `find-skills`. | main-agent | security_auditor | `human-gated` | yes | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-migrating-dbt-core-to-fusion | P1 | skill-provenance | Resolve source/license evidence for `migrating-dbt-core-to-fusion`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-migrating-dbt-project-across-platforms | P1 | skill-provenance | Resolve source/license evidence for `migrating-dbt-project-across-platforms`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-powerbi-expert | P1 | skill-provenance | Resolve source/license evidence for `powerbi-expert`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-running-dbt-commands | P1 | skill-provenance | Resolve source/license evidence for `running-dbt-commands`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-spreadsheet | P1 | skill-provenance | Resolve source/license evidence for `spreadsheet`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-troubleshooting-dbt-job-errors | P1 | skill-provenance | Resolve source/license evidence for `troubleshooting-dbt-job-errors`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-using-dbt-for-analytics-engineering | P1 | skill-provenance | Resolve source/license evidence for `using-dbt-for-analytics-engineering`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-using-dbt-index | P1 | skill-provenance | Resolve source/license evidence for `using-dbt-index`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-PROVENANCE-working-with-dbt-mesh | P1 | skill-provenance | Resolve source/license evidence for `working-with-dbt-mesh`. | main-agent | security_auditor | `auto-fix-proposal` | no | `python scripts/validate-skills.py --strict` |
| EVOL-OVERLAP-SKILL-plan-deep-plan-deep-skills | P2 | duplication-review | Review overlap between `plan-deep` and `plan-deep-skills`. | main-agent | code_reviewer | `auto-fix-proposal` | no | `python scripts/evolve-workspace.py --strict` |

## Evidence

### EVOL-PROVENANCE-adding-dbt-unit-test

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-answering-natural-language-questions-with-dbt

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-auditing-skills

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-building-dbt-semantic-layer

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-caveman

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-configuring-dbt-mcp-server

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-creating-mermaid-dbt-dag

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-fetching-dbt-docs

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-find-skills

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-migrating-dbt-core-to-fusion

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-migrating-dbt-project-across-platforms

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-powerbi-expert

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-running-dbt-commands

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-spreadsheet

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-troubleshooting-dbt-job-errors

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-using-dbt-for-analytics-engineering

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-using-dbt-index

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-PROVENANCE-working-with-dbt-mesh

docs/skills-provenance.md marks the skill as needs-source-review.

### EVOL-OVERLAP-SKILL-plan-deep-plan-deep-skills

Token similarity score 0.60 from names/descriptions.
