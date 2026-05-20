# Skills Provenance And Publication Gates

Last reviewed: 2026-05-19

This matrix records repository-visible evidence for every skill under `skills/`. It is a governance control, not a legal opinion. A skill is ready for broad public redistribution only when its source, license or attribution, local modifications, script risk, and validation status are explicit enough for a third-party consumer to review without inspecting Manuel's private runtime.

## Status Values

| Gate | Meaning |
| --- | --- |
| `ready` | Source and license evidence are present in this repository or the skill is local original content covered by the repository license. |
| `needs-source-review` | The inventory records an origin, but this repository does not yet contain enough license or attribution evidence for confident public reuse. |
| `restricted-by-profile` | The skill is intentionally excluded from default adoption profiles because it is `review`, `curated`, `deprecated`, or `archived`. |

## Provenance Matrix

| Skill | Manifest status | Origin evidence | License or attribution evidence in repo | Script or asset risk | Publication gate |
| --- | --- | --- | --- | --- | --- |
| `adding-dbt-unit-test` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Reference-only markdown. | `needs-source-review` |
| `agent-browser` | `review` | Inventory says Vercel Labs. | No local license file or source URL recorded in skill frontmatter. | May require external browser automation tooling. | `restricted-by-profile` |
| `answering-natural-language-questions-with-dbt` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | May lead to warehouse queries in consumer workspaces. | `needs-source-review` |
| `auditing-skills` | `core` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Refers to external audit services. | `needs-source-review` |
| `building-dbt-semantic-layer` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | References external dbt tooling and docs. | `needs-source-review` |
| `canvas-design` | `curated` | Inventory says Anthropic skill, adapted. | `skills/canvas-design/LICENSE.txt` plus bundled font license files. | Bundled fonts and visual assets need attribution preservation. | `restricted-by-profile` |
| `caveman` | `optional` | Inventory says JuliusBrussee caveman. | README attribution exists; no local license file found. | Style-only instructions. | `needs-source-review` |
| `caveman-commit` | `review` | Inventory says JuliusBrussee caveman. | README attribution exists; no local license file found. | Git-message workflow only. | `restricted-by-profile` |
| `caveman-compress` | `review` | Inventory says JuliusBrussee caveman. | README attribution and SECURITY file exist; no local license file found. | Script can send file contents to a third-party API. | `restricted-by-profile` |
| `configuring-dbt-mcp-server` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Credential-handling guidance affects secret safety. | `needs-source-review` |
| `continuous-evolution` | `core` | Local template. | Covered by repository Apache-2.0 license. | Can route repository-local edits and subagent work; human gates apply to core or sensitive changes. | `ready` |
| `creating-mermaid-dbt-dag` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Reference-only markdown. | `needs-source-review` |
| `fetching-dbt-docs` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Contains a docs-fetching script and external content boundary. | `needs-source-review` |
| `find-skills` | `core` | Inventory and ADR say Vercel Labs, adapted. | No local license file or source URL recorded in skill frontmatter. | Can lead to external skill search and install proposals. | `needs-source-review` |
| `frontend-design` | `optional` | ADR says migrated from Anthropic `frontend-design`. | `skills/frontend-design/LICENSE.txt`; frontmatter records Apache-2.0 migration note. | Instruction-only plus metadata. | `ready` |
| `migrate-to-codex` | `core` | Inventory says OpenAI. | `skills/migrate-to-codex/LICENSE.txt`. | Scripts can write selected migration targets after explicit target selection. | `ready` |
| `migrating-dbt-core-to-fusion` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | References migration tooling. | `needs-source-review` |
| `migrating-dbt-project-across-platforms` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | References platform migration commands. | `needs-source-review` |
| `pdf` | `optional` | Inventory says OpenAI/curated. | `skills/pdf/LICENSE.txt`. | PDF tooling may depend on local libraries. | `ready` |
| `plan-deep` | `core` | Local template. | Covered by repository Apache-2.0 license. | Planning-only; no writes by design. | `ready` |
| `plan-deep-skills` | `core` | Local template. | Covered by repository Apache-2.0 license. | Planning-only; no installs by design. | `ready` |
| `powerbi-expert` | `optional` | Inventory says Community PCL. | Frontmatter says Apache-2.0; no local license file found. | Instruction-only. | `needs-source-review` |
| `running-dbt-commands` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Can lead to dbt command execution. | `needs-source-review` |
| `screenshot` | `review` | Inventory says OpenAI/curated. | `skills/screenshot/LICENSE.txt`. | OS screenshot scripts and privacy-sensitive output. | `restricted-by-profile` |
| `spreadsheet` | `optional` | Frontmatter metadata points to the published OpenAI `skills.sh` listing. | No local license file found. | Spreadsheet artifact generation can include external data. | `needs-source-review` |
| `theme-factory` | `curated` | Inventory says Anthropic skill. | `skills/theme-factory/LICENSE.txt`. | Bundled PDF/theme material. | `restricted-by-profile` |
| `troubleshooting-dbt-job-errors` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Can process logs that may contain sensitive values. | `needs-source-review` |
| `using-dbt-for-analytics-engineering` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Includes helper script and project-data review guidance. | `needs-source-review` |
| `using-dbt-index` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | References external CLI behavior. | `needs-source-review` |
| `web-artifacts-builder` | `curated` | Inventory says Anthropic skill, adapted. | `skills/web-artifacts-builder/LICENSE.txt`. | Bundled archive and build scripts need review before broad install. | `restricted-by-profile` |
| `webapp-testing` | `optional` | Inventory says Anthropic skill. | `skills/webapp-testing/LICENSE.txt`. | Browser/runtime testing dependency risk. | `ready` |
| `working-with-dbt-mesh` | `optional` | Inventory says dbt Labs. | No local license file or source URL recorded in skill frontmatter. | Reference-only markdown. | `needs-source-review` |

## Publication Rules

- Do not claim the repository is legally ready for broad public redistribution until every `needs-source-review` skill has explicit source URL, upstream license evidence, and attribution requirements recorded.
- Do not move `restricted-by-profile` skills into default profiles unless their risk and license evidence are reviewed in the same change.
- Keep this matrix, `workspace-manifest.json`, and `docs/capability-inventory.md` aligned whenever a skill is added, removed, reclassified, or materially changed.
- Preserve local license files, bundled asset license files, and source attribution when copying a profile into a consumer workspace.
