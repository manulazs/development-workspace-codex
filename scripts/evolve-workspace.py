#!/usr/bin/env python3
"""Catalog continuous-evolution tasks for this Codex workspace repository."""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass
from datetime import date
from pathlib import Path


INSTALL_BLOCKED = {"curated", "review", "deprecated", "archived"}
HUMAN_GATED_SEGMENTS = {
    "profile-safety",
    "security",
    "runtime-boundary",
    "core-capability",
    "installer-safety",
}
TOKEN_RE = re.compile(r"[a-z0-9]+")


@dataclass(frozen=True)
class Capability:
    kind: str
    name: str
    status: str
    description: str


@dataclass(frozen=True)
class EvolutionTask:
    task_id: str
    priority: str
    segment: str
    title: str
    evidence: str
    recommended_owner: str
    recommended_subagents: list[str]
    automation_level: str
    human_approval_required: bool
    validation: list[str]


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace") if path.exists() else ""


def load_manifest(root: Path) -> dict[str, object]:
    manifest_path = root / "workspace-manifest.json"
    if not manifest_path.exists():
        return {}
    return json.loads(manifest_path.read_text(encoding="utf-8"))


def parse_skill_frontmatter(skill_file: Path) -> dict[str, str]:
    lines = skill_file.read_text(encoding="utf-8", errors="replace").splitlines()
    if not lines or lines[0] != "---":
        return {}
    try:
        end = lines[1:].index("---") + 1
    except ValueError:
        return {}

    values: dict[str, str] = {}
    index = 1
    while index < end:
        line = lines[index]
        if ":" not in line or line.startswith((" ", "\t")):
            index += 1
            continue
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip().strip('"')
        if value in {">", "|"}:
            parts: list[str] = []
            index += 1
            while index < end and (
                lines[index].startswith((" ", "\t")) or not lines[index].strip()
            ):
                stripped = lines[index].strip()
                if stripped:
                    parts.append(stripped)
                index += 1
            values[key] = " ".join(parts)
            continue
        values[key] = value
        index += 1
    return values


def parse_toml_like_agent(agent_file: Path) -> dict[str, str]:
    text = read_text(agent_file)
    values: dict[str, str] = {}
    for key in ("name", "description", "sandbox_mode"):
        match = re.search(rf'(?m)^{key}\s*=\s*"([^"]*)"', text)
        if match:
            values[key] = match.group(1)
    return values


def parse_provenance_gates(root: Path) -> dict[str, str]:
    gates: dict[str, str] = {}
    text = read_text(root / "docs" / "skills-provenance.md")
    for line in text.splitlines():
        if not line.startswith("| `"):
            continue
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if len(cells) < 6:
            continue
        skill = cells[0].strip("`")
        gate = cells[-1].strip("`")
        gates[skill] = gate
    return gates


def collect_capabilities(root: Path, manifest: dict[str, object]) -> list[Capability]:
    capabilities: list[Capability] = []
    manifest_skills = manifest.get("skills", {})
    manifest_agents = manifest.get("agents", {})
    if not isinstance(manifest_skills, dict):
        manifest_skills = {}
    if not isinstance(manifest_agents, dict):
        manifest_agents = {}

    for skill_dir in sorted((root / "skills").glob("*")):
        if not skill_dir.is_dir():
            continue
        fields = parse_skill_frontmatter(skill_dir / "SKILL.md")
        capabilities.append(
            Capability(
                kind="skill",
                name=skill_dir.name,
                status=str(manifest_skills.get(skill_dir.name, "unclassified")),
                description=fields.get("description", ""),
            )
        )

    for agent_file in sorted((root / ".codex" / "agents").glob("*.toml")):
        fields = parse_toml_like_agent(agent_file)
        name = fields.get("name", agent_file.stem)
        capabilities.append(
            Capability(
                kind="agent",
                name=name,
                status=str(manifest_agents.get(name, "unclassified")),
                description=fields.get("description", ""),
            )
        )
    return capabilities


def tokens(text: str) -> set[str]:
    stop = {
        "and",
        "for",
        "the",
        "with",
        "when",
        "use",
        "uses",
        "codex",
        "skill",
        "agent",
        "workspace",
        "work",
    }
    return {token for token in TOKEN_RE.findall(text.lower()) if token not in stop}


def similarity(left: Capability, right: Capability) -> float:
    left_tokens = tokens(f"{left.name} {left.description}")
    right_tokens = tokens(f"{right.name} {right.description}")
    if not left_tokens or not right_tokens:
        return 0.0
    return len(left_tokens & right_tokens) / len(left_tokens | right_tokens)


def task(
    task_id: str,
    priority: str,
    segment: str,
    title: str,
    evidence: str,
    owner: str,
    subagents: list[str],
    automation_level: str,
    validation: list[str],
) -> EvolutionTask:
    human_required = segment in HUMAN_GATED_SEGMENTS or automation_level == "human-gated"
    return EvolutionTask(
        task_id=task_id,
        priority=priority,
        segment=segment,
        title=title,
        evidence=evidence,
        recommended_owner=owner,
        recommended_subagents=subagents,
        automation_level=automation_level,
        human_approval_required=human_required,
        validation=validation,
    )


def generate_tasks(root: Path) -> list[EvolutionTask]:
    manifest = load_manifest(root)
    capabilities = collect_capabilities(root, manifest)
    manifest_skills = manifest.get("skills", {})
    manifest_agents = manifest.get("agents", {})
    profiles = manifest.get("profiles", {})
    if not isinstance(manifest_skills, dict):
        manifest_skills = {}
    if not isinstance(manifest_agents, dict):
        manifest_agents = {}
    if not isinstance(profiles, dict):
        profiles = {}

    inventory_text = read_text(root / "docs" / "capability-inventory.md")
    gates = parse_provenance_gates(root)
    tasks: list[EvolutionTask] = []

    installer_specs = [
        (
            "EVOL-INSTALLER-NO-CLOBBER-BASH",
            root / "scripts" / "install-workspace.sh",
            ["--no-clobber", "without --force", "backup", "diff"],
        ),
        (
            "EVOL-INSTALLER-NO-CLOBBER-POWERSHELL",
            root / "scripts" / "install-workspace.ps1",
            ["NoClobber", "-Force", "Backup", "Compare"],
        ),
    ]
    for task_id, installer_path, expected_terms in installer_specs:
        installer_text = read_text(installer_path)
        if installer_text and not any(term in installer_text for term in expected_terms):
            tasks.append(
                task(
                    task_id,
                    "P1",
                    "installer-safety",
                    f"Add conflict-safe runtime adoption controls to `{installer_path.relative_to(root)}`.",
                    "Installer supports preview but does not yet advertise no-clobber, backup, or diff/hash conflict controls.",
                    "main-agent",
                    ["security_auditor"],
                    "human-gated",
                    [
                        "bash scripts/install-workspace.sh --profile full-reviewed --dry-run",
                        "python scripts/evolve-workspace.py --strict",
                    ],
                )
            )

    for capability in capabilities:
        if capability.status == "unclassified":
            tasks.append(
                task(
                    f"EVOL-MANIFEST-{capability.kind.upper()}-{capability.name}",
                    "P0",
                    "manifest-integrity",
                    f"Classify {capability.kind} `{capability.name}` in workspace-manifest.json.",
                    f"{capability.kind} exists on disk but has no manifest status.",
                    "main-agent",
                    ["code_reviewer"],
                    "auto-edit-allowed",
                    ["python scripts/validate-skills.py --strict", "bash scripts/healthcheck.sh --strict"],
                )
            )
        if capability.name not in inventory_text:
            tasks.append(
                task(
                    f"EVOL-INVENTORY-{capability.kind.upper()}-{capability.name}",
                    "P0",
                    "inventory-integrity",
                    f"Document {capability.kind} `{capability.name}` in capability inventory.",
                    "Capability is present but missing from docs/capability-inventory.md.",
                    "main-agent",
                    ["agents_md_maintainer"],
                    "auto-edit-allowed",
                    ["bash scripts/healthcheck.sh --strict"],
                )
            )

    for profile_name, raw_profile in profiles.items():
        if not isinstance(raw_profile, dict):
            continue
        for skill in raw_profile.get("skills", []):
            status = manifest_skills.get(skill)
            if status in INSTALL_BLOCKED:
                tasks.append(
                    task(
                        f"EVOL-PROFILE-SKILL-{profile_name}-{skill}",
                        "P0",
                        "profile-safety",
                        f"Remove blocked skill `{skill}` from profile `{profile_name}`.",
                        f"Profile references status `{status}`, which must not install by default.",
                        "main-agent",
                        ["security_auditor"],
                        "human-gated",
                        ["python scripts/validate-skills.py --strict", "bash scripts/healthcheck.sh --strict"],
                    )
                )
        for agent_name in raw_profile.get("agents", []):
            status = manifest_agents.get(agent_name)
            if status in INSTALL_BLOCKED:
                tasks.append(
                    task(
                        f"EVOL-PROFILE-AGENT-{profile_name}-{agent_name}",
                        "P0",
                        "profile-safety",
                        f"Remove blocked agent `{agent_name}` from profile `{profile_name}`.",
                        f"Profile references status `{status}`, which must not install by default.",
                        "main-agent",
                        ["security_auditor"],
                        "human-gated",
                        ["bash scripts/healthcheck.sh --strict"],
                    )
                )

    for skill, gate in sorted(gates.items()):
        status = manifest_skills.get(skill, "unclassified")
        if gate == "needs-source-review":
            tasks.append(
                task(
                    f"EVOL-PROVENANCE-{skill}",
                    "P1" if status in {"core", "optional"} else "P2",
                    "skill-provenance",
                    f"Resolve source/license evidence for `{skill}`.",
                    "docs/skills-provenance.md marks the skill as needs-source-review.",
                    "main-agent",
                    ["security_auditor"],
                    "human-gated" if status == "core" else "auto-fix-proposal",
                    ["python scripts/validate-skills.py --strict"],
                )
            )

    checked_pairs: set[tuple[str, str]] = set()
    for index, left in enumerate(capabilities):
        for right in capabilities[index + 1 :]:
            if left.kind != right.kind:
                continue
            pair_key = tuple(sorted((left.name, right.name)))
            if pair_key in checked_pairs:
                continue
            checked_pairs.add(pair_key)
            score = similarity(left, right)
            if score >= 0.58:
                tasks.append(
                    task(
                        f"EVOL-OVERLAP-{left.kind.upper()}-{left.name}-{right.name}",
                        "P2",
                        "duplication-review",
                        f"Review overlap between `{left.name}` and `{right.name}`.",
                        f"Token similarity score {score:.2f} from names/descriptions.",
                        "main-agent",
                        ["code_reviewer"],
                        "auto-fix-proposal",
                        ["python scripts/evolve-workspace.py --strict"],
                    )
                )

    if not tasks:
        tasks.append(
            task(
                "EVOL-STEADY-STATE",
                "P3",
                "maintenance",
                "No structural evolution tasks detected.",
                "Manifest, inventory, provenance, profiles, and overlap checks found no immediate gaps.",
                "main-agent",
                [],
                "catalog-only",
                ["bash scripts/healthcheck.sh --strict"],
            )
        )

    priority_order = {"P0": 0, "P1": 1, "P2": 2, "P3": 3}
    return sorted(tasks, key=lambda item: (priority_order.get(item.priority, 9), item.segment, item.task_id))


def render_markdown(tasks: list[EvolutionTask]) -> str:
    lines = [
        "# Continuous Evolution Task Catalog",
        "",
        f"Generated: {date.today().isoformat()}",
        "",
        "This catalog is generated from repository-visible metadata. It guides the main agent; it does not authorize runtime-global writes, commits, pushes, or destructive actions by itself.",
        "",
        "## Automation Levels",
        "",
        "| Level | Meaning |",
        "| --- | --- |",
        "| `catalog-only` | Record status; no edit implied. |",
        "| `auto-fix-proposal` | Automation may draft a change, but review is expected before persistence. |",
        "| `auto-edit-allowed` | Repository-local edits are allowed when scope is narrow and validation passes. |",
        "| `human-gated` | Human approval is required before applying or merging the change. |",
        "",
        "## Tasks",
        "",
        "| ID | Priority | Segment | Title | Owner | Subagents | Automation | Human approval | Validation |",
        "| --- | --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for item in tasks:
        subagents = ", ".join(item.recommended_subagents) if item.recommended_subagents else "-"
        validation = "<br>".join(f"`{command}`" for command in item.validation)
        approval = "yes" if item.human_approval_required else "no"
        lines.append(
            "| {task_id} | {priority} | {segment} | {title} | {owner} | {subagents} | "
            "`{automation}` | {approval} | {validation} |".format(
                task_id=item.task_id,
                priority=item.priority,
                segment=item.segment,
                title=item.title.replace("|", "\\|"),
                owner=item.recommended_owner,
                subagents=subagents,
                automation=item.automation_level,
                approval=approval,
                validation=validation,
            )
        )
    lines.extend(
        [
            "",
            "## Evidence",
            "",
        ]
    )
    for item in tasks:
        lines.extend(
            [
                f"### {item.task_id}",
                "",
                item.evidence,
                "",
            ]
        )
    return "\n".join(lines).rstrip() + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description="Catalog governed continuous-evolution tasks.")
    parser.add_argument("--root", default=".", help="Repository root. Defaults to current directory.")
    parser.add_argument("--write-catalog", action="store_true", help="Write docs/evolution/task-catalog.md and .json.")
    parser.add_argument("--json", action="store_true", help="Print task catalog as JSON.")
    parser.add_argument("--strict", action="store_true", help="Fail when P0 evolution tasks exist.")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    tasks = generate_tasks(root)

    if args.write_catalog:
        target_dir = root / "docs" / "evolution"
        target_dir.mkdir(parents=True, exist_ok=True)
        (target_dir / "task-catalog.md").write_text(render_markdown(tasks), encoding="utf-8")
        (target_dir / "task-catalog.json").write_text(
            json.dumps([asdict(item) for item in tasks], indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )

    if args.json:
        print(json.dumps([asdict(item) for item in tasks], indent=2, ensure_ascii=False))
    else:
        print(render_markdown(tasks))

    if args.strict and any(item.priority == "P0" for item in tasks):
        raise SystemExit(1)


if __name__ == "__main__":
    main()
