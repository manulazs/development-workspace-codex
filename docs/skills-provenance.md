# Skills Provenance

Last reviewed: 2026-05-25

This matrix records repository-visible evidence for every skill under `skills/`. It is informational provenance, not an authorization gate. The maintainer has authorized all repository skills for use; profile status still controls default adoption.

## Provenance Note Values

| Note | Meaning |
| --- | --- |
| `authorized` | The skill is present in this repository and authorized for use according to its manifest status and selected profile. |
| `profile-restricted` | The skill is authorized but excluded from default profiles because it is `review`, `curated`, `deprecated`, or `archived`. |

## Provenance Matrix

| Skill | Manifest status | Origin evidence | License or attribution evidence in repo | Script or asset risk | Provenance notes |
| --- | --- | --- | --- | --- | --- |
| `adding-dbt-unit-test` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Reference-only markdown. | `authorized` |
| `agent-browser` | `review` | Inventory says Vercel Labs. | No local license file or source URL recorded in skill frontmatter. | May require external browser automation tooling. | `profile-restricted` |
| `answering-natural-language-questions-with-dbt` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | May lead to warehouse queries in consumer workspaces. | `authorized` |
| `auditing-skills` | `core` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Refers to external audit services. | `authorized` |
| `building-dbt-semantic-layer` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | References external dbt tooling and docs. | `authorized` |
| `canvas-design` | `curated` | Inventory says Anthropic skill, adapted. | `skills/canvas-design/LICENSE.txt` plus bundled font license files. | Bundled fonts and visual assets need attribution preservation. | `profile-restricted` |
| `caveman` | `core` | Inventory says JuliusBrussee caveman. | README attribution exists; no local license file found. | Style-only instructions; upstream Codex usage is per-session unless this workspace's global `AGENTS.md` rule is installed. | `authorized` |
| `caveman-commit` | `review` | Inventory says JuliusBrussee caveman. | README attribution exists; no local license file found. | Git-message workflow only. | `profile-restricted` |
| `caveman-compress` | `review` | Inventory says JuliusBrussee caveman. | README attribution and SECURITY file exist; no local license file found. | Script can send file contents to a third-party API. | `profile-restricted` |
| `configuring-dbt-mcp-server` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Credential-handling guidance affects secret safety. | `authorized` |
| `context-budget-audit` | `core` | Locally authored; concepts adapted from Affaan Mustafa's ECC `context-budget`, `token-budget-advisor`, and `strategic-compact` surfaces. | ECC is MIT licensed; no bulk ECC content copied. Repository implementation is covered by the repository license with attribution retained here. | Runs read-only repository analysis through `scripts/analyze-context-budget.py`. | `authorized` |
| `continuous-evolution` | `core` | Local template. | Covered by repository Apache-2.0 license. | Can route repository-local edits and subagent work; human gates apply to core or sensitive changes. | `authorized` |
| `creating-mermaid-dbt-dag` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Reference-only markdown. | `authorized` |
| `fetching-dbt-docs` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Contains a docs-fetching script and external content boundary. | `authorized` |
| `find-skills` | `core` | Inventory and ADR say Vercel Labs, adapted. | No local license file or source URL recorded in skill frontmatter. | Can lead to external skill search and install proposals. | `authorized` |
| `frontend-design` | `optional` | ADR says migrated from Anthropic `frontend-design`. | `skills/frontend-design/LICENSE.txt`; frontmatter records Apache-2.0 migration note. | Instruction-only plus metadata. | `authorized` |
| `migrate-to-codex` | `core` | Inventory says OpenAI. | `skills/migrate-to-codex/LICENSE.txt`. | Scripts can write selected migration targets after explicit target selection. | `authorized` |
| `migrating-dbt-core-to-fusion` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | References migration tooling. | `authorized` |
| `migrating-dbt-project-across-platforms` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | References platform migration commands. | `authorized` |
| `pdf` | `optional` | Inventory says OpenAI/curated. | `skills/pdf/LICENSE.txt`. | PDF tooling may depend on local libraries. | `authorized` |
| `plan-deep` | `core` | Local template. | Covered by repository Apache-2.0 license. | Planning-only; may recommend implementation-time subagents but does not spawn or write. | `authorized` |
| `plan-deep-skills` | `core` | Local template. | Covered by repository Apache-2.0 license. | Planning-only; may recommend skills and implementation-time subagents but does not install, spawn, or write. | `authorized` |
| `powerbi-expert` | `optional` | Inventory says Community PCL. | Frontmatter says Apache-2.0; no local license file found. | Instruction-only. | `authorized` |
| `running-dbt-commands` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Can lead to dbt command execution. | `authorized` |
| `screenshot` | `review` | Inventory says OpenAI/curated. | `skills/screenshot/LICENSE.txt`. | OS screenshot scripts and privacy-sensitive output. | `profile-restricted` |
| `spreadsheet` | `optional` | Frontmatter metadata points to the published OpenAI `skills.sh` listing. | No local license file found. | Spreadsheet artifact generation can include external data. | `authorized` |
| `theme-factory` | `curated` | Inventory says Anthropic skill. | `skills/theme-factory/LICENSE.txt`. | Bundled PDF/theme material. | `profile-restricted` |
| `troubleshooting-dbt-job-errors` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Can process logs that may contain sensitive values. | `authorized` |
| `using-dbt-for-analytics-engineering` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Includes helper script and project-data review guidance. | `authorized` |
| `using-dbt-index` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | References external CLI behavior. | `authorized` |
| `verification-loop` | `core` | Locally authored; concepts adapted from Affaan Mustafa's ECC `verification-loop` and `eval-harness` surfaces. | ECC is MIT licensed; no bulk ECC content copied. Repository implementation is covered by the repository license with attribution retained here. | Orchestrates existing validation commands; does not replace healthchecks or perform writes by itself. | `authorized` |
| `web-artifacts-builder` | `curated` | Inventory says Anthropic skill, adapted. | `skills/web-artifacts-builder/LICENSE.txt`. | Bundled archive and build scripts need review before broad install. | `profile-restricted` |
| `webapp-testing` | `optional` | Inventory says Anthropic skill. | `skills/webapp-testing/LICENSE.txt`. | Browser/runtime testing dependency risk. | `authorized` |
| `working-with-dbt-mesh` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Reference-only markdown. | `authorized` |

## Provenance Rules

- All skills present in this repository are authorized for use by maintainer decision; provenance rows do not block import or use.
- Do not move `profile-restricted` skills into default profiles unless their risk and adoption boundary are reviewed in the same change.
- Keep this matrix, `workspace-manifest.json`, and `docs/capability-inventory.md` aligned whenever a skill is added, removed, reclassified, or materially changed.
- Preserve local license files, bundled asset license files, and source attribution when copying a profile into a consumer workspace.
