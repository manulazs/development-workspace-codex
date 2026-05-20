#!/usr/bin/env python3
"""Create governed skill or agent proposals with duplicate checks."""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from datetime import date
from pathlib import Path


STATUSES = {"core", "optional", "curated", "review", "deprecated", "archived"}
CORE_GATED = {"core"}
TOKEN_RE = re.compile(r"[a-z0-9]+")
SKILL_NAME_RE = re.compile(r"^[a-z][a-z0-9-]*[a-z0-9]$")
AGENT_NAME_RE = re.compile(r"^[a-z][a-z0-9_]*[a-z0-9]$")


@dataclass(frozen=True)
class ExistingCapability:
    kind: str
    name: str
    description: str


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace") if path.exists() else ""


def load_manifest(root: Path) -> dict[str, object]:
    return json.loads((root / "workspace-manifest.json").read_text(encoding="utf-8"))


def write_manifest(root: Path, manifest: dict[str, object]) -> None:
    (root / "workspace-manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def parse_skill_description(skill_file: Path) -> str:
    text = read_text(skill_file)
    match = re.search(r"(?ms)^description:\s*(?:>\s*)?\n?(.*?)(?:\n---|\nmetadata:|\n[A-Za-z_-]+:)", text)
    if not match:
        inline = re.search(r"(?m)^description:\s*(.+)$", text)
        return inline.group(1).strip().strip('"') if inline else ""
    return " ".join(line.strip() for line in match.group(1).splitlines() if line.strip())


def parse_agent_description(agent_file: Path) -> str:
    match = re.search(r'(?m)^description\s*=\s*"([^"]*)"', read_text(agent_file))
    return match.group(1) if match else ""


def collect_existing(root: Path) -> list[ExistingCapability]:
    capabilities: list[ExistingCapability] = []
    for skill_dir in sorted((root / "skills").glob("*")):
        if skill_dir.is_dir():
            capabilities.append(
                ExistingCapability(
                    kind="skill",
                    name=skill_dir.name,
                    description=parse_skill_description(skill_dir / "SKILL.md"),
                )
            )
    for agent_file in sorted((root / ".codex" / "agents").glob("*.toml")):
        capabilities.append(
            ExistingCapability(
                kind="agent",
                name=agent_file.stem,
                description=parse_agent_description(agent_file),
            )
        )
    return capabilities


def tokens(text: str) -> set[str]:
    stop = {
        "a",
        "an",
        "and",
        "for",
        "the",
        "to",
        "with",
        "when",
        "use",
        "uses",
        "codex",
        "skill",
        "agent",
        "workspace",
        "workflow",
    }
    return {token for token in TOKEN_RE.findall(text.lower()) if token not in stop}


def similarity(left: str, right: str) -> float:
    left_tokens = tokens(left)
    right_tokens = tokens(right)
    if not left_tokens or not right_tokens:
        return 0.0
    return len(left_tokens & right_tokens) / len(left_tokens | right_tokens)


def overlap_candidates(
    kind: str,
    name: str,
    purpose: str,
    existing: list[ExistingCapability],
    threshold: float,
) -> list[tuple[ExistingCapability, float]]:
    source = f"{name} {purpose}"
    candidates: list[tuple[ExistingCapability, float]] = []
    for capability in existing:
        if capability.kind != kind:
            continue
        score = similarity(source, f"{capability.name} {capability.description}")
        if capability.name == name or score >= threshold:
            candidates.append((capability, score))
    return sorted(candidates, key=lambda item: (-item[1], item[0].name))


def require_valid_name(kind: str, name: str) -> None:
    pattern = AGENT_NAME_RE if kind == "agent" else SKILL_NAME_RE
    if not pattern.match(name):
        expected = "lowercase snake_case" if kind == "agent" else "lowercase kebab-case"
        raise SystemExit(
            f"{kind.capitalize()} name must be {expected}, start with a letter, "
            "and contain only lowercase letters, numbers, "
            + ("and underscores." if kind == "agent" else "and hyphens.")
        )


def proposal_markdown(
    kind: str,
    name: str,
    purpose: str,
    status: str,
    overlaps: list[tuple[ExistingCapability, float]],
) -> str:
    overlap_lines = [
        f"- `{item.name}` ({item.kind}), score {score:.2f}: {item.description or 'no description'}"
        for item, score in overlaps
    ] or ["- No material overlap detected by token similarity."]

    return "\n".join(
        [
            f"# Capability Proposal: {name}",
            "",
            f"Date: {date.today().isoformat()}",
            f"Kind: `{kind}`",
            f"Status: `{status}`",
            "",
            "## Purpose",
            "",
            purpose,
            "",
            "## Existing Capability Check",
            "",
            *overlap_lines,
            "",
            "## Automation Decision",
            "",
            "- `proposal`: safe to review without runtime effects.",
            "- `apply`: allowed only when overlap is resolved and human gates are satisfied.",
            "",
            "## Required Follow-Up",
            "",
            "- Validate with `python scripts/scaffold-capability.py --help` for command syntax.",
            "- Run `python scripts/evolve-workspace.py --write-catalog --strict` after applying.",
            "- Run `python scripts/validate-skills.py --strict` and `bash scripts/healthcheck.sh --strict`.",
            "",
        ]
    )


def create_proposal(
    root: Path,
    kind: str,
    name: str,
    purpose: str,
    status: str,
    overlaps: list[tuple[ExistingCapability, float]],
) -> Path:
    target_dir = root / "docs" / "evolution" / "proposals"
    target_dir.mkdir(parents=True, exist_ok=True)
    target = target_dir / f"{date.today().isoformat()}-{kind}-{name}.md"
    target.write_text(proposal_markdown(kind, name, purpose, status, overlaps), encoding="utf-8")
    return target


def insert_before_heading(text: str, heading: str, row: str) -> str:
    marker = f"\n{heading}\n"
    if marker not in text:
        raise SystemExit(f"Could not find heading: {heading}")
    before, after = text.split(marker, 1)
    if row in before:
        return text
    return before.rstrip() + "\n" + row + "\n" + marker + after


def apply_skill(root: Path, name: str, purpose: str, status: str) -> None:
    skill_dir = root / "skills" / name
    if skill_dir.exists():
        raise SystemExit(f"Skill already exists: {skill_dir}")
    skill_dir.mkdir(parents=True)
    (skill_dir / "SKILL.md").write_text(
        "\n".join(
            [
                "---",
                f"name: {name}",
                f"description: {purpose}",
                "---",
                "",
                f"# {name}",
                "",
                "Use this skill when the requested work matches the purpose above and existing repository instructions do not already cover the workflow.",
                "",
                "## Workflow",
                "",
                "1. Ground the task in repository evidence.",
                "2. Check existing skills, agents, docs, runbooks, system skills, and plugin capabilities before changing behavior.",
                "3. Keep edits scoped and validate with repository commands.",
                "",
            ]
        ),
        encoding="utf-8",
    )

    manifest = load_manifest(root)
    skills = manifest.setdefault("skills", {})
    if not isinstance(skills, dict):
        raise SystemExit("workspace-manifest.json skills must be an object.")
    skills[name] = status
    manifest["skills"] = dict(sorted(skills.items()))
    write_manifest(root, manifest)

    inventory_path = root / "docs" / "capability-inventory.md"
    inventory = read_text(inventory_path)
    inventory_row = (
        f"| `{name}` | `{status}` | Local template | {purpose} | Medium | Cross-platform | "
        "The recurring workflow matches this skill. | Existing skills, agents, or runbooks are enough. |"
    )
    inventory_path.write_text(
        insert_before_heading(inventory, "## Subagent Template Inventory", inventory_row),
        encoding="utf-8",
    )

    provenance_path = root / "docs" / "skills-provenance.md"
    provenance = read_text(provenance_path)
    provenance_row = (
        f"| `{name}` | `{status}` | Local template. | Covered by repository Apache-2.0 license. | "
        "Instruction-only scaffold; validate before broad adoption. | `authorized` |"
    )
    provenance_path.write_text(
        insert_before_heading(provenance, "## Provenance Rules", provenance_row),
        encoding="utf-8",
    )


def apply_agent(root: Path, name: str, purpose: str, status: str) -> None:
    agent_file = root / ".codex" / "agents" / f"{name}.toml"
    if agent_file.exists():
        raise SystemExit(f"Agent already exists: {agent_file}")
    agent_file.write_text(
        f'''name = "{name}"
description = "{purpose}"
model = "gpt-5.4"
model_reasoning_effort = "high"
sandbox_mode = "workspace-write"
developer_instructions = """
You own this recurring role only when the parent agent provides a bounded objective, clear scope, expected output, validation signal, and stopping criteria.

Rules:
- Check existing skills, agents, docs, runbooks, system skills, and plugin capabilities before creating new behavior.
- Keep writes within the parent-provided scope.
- Do not commit, push, install runtime-global files, or change repository visibility unless explicitly instructed by the parent agent and user.
- Return changed files, evidence, residual risk, and recommended next action.
"""
''',
        encoding="utf-8",
    )

    manifest = load_manifest(root)
    agents = manifest.setdefault("agents", {})
    if not isinstance(agents, dict):
        raise SystemExit("workspace-manifest.json agents must be an object.")
    agents[name] = status
    manifest["agents"] = dict(sorted(agents.items()))
    write_manifest(root, manifest)

    inventory_path = root / "docs" / "capability-inventory.md"
    inventory = read_text(inventory_path)
    row = (
        f"| `{name}` | `{status}` | {purpose} | Strong model for bounded role work. | "
        "`workspace-write` | Medium | The role has independent ownership and validation. | "
        "A skill, runbook, or existing agent is enough. |"
    )
    inventory_path.write_text(
        insert_before_heading(inventory, "## Capability Selection Rules", row),
        encoding="utf-8",
    )


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Create governed skill or agent proposals with anti-duplication checks."
    )
    parser.add_argument("kind", choices=["skill", "agent"], help="Capability type.")
    parser.add_argument(
        "--name",
        required=True,
        help="Capability name. Skills use lowercase kebab-case; agents use lowercase snake_case.",
    )
    parser.add_argument("--purpose", required=True, help="One-sentence purpose.")
    parser.add_argument("--status", default="review", choices=sorted(STATUSES), help="Manifest status.")
    parser.add_argument("--root", default=".", help="Repository root.")
    parser.add_argument(
        "--mode",
        choices=["proposal", "apply"],
        default="proposal",
        help="Write a review proposal or apply a repository-local scaffold.",
    )
    parser.add_argument(
        "--overlap-threshold",
        type=float,
        default=0.35,
        help="Similarity threshold that blocks apply without --allow-overlap.",
    )
    parser.add_argument("--allow-overlap", action="store_true", help="Allow apply despite overlap.")
    parser.add_argument("--dry-run", action="store_true", help="Print what would happen without writing.")
    parser.add_argument(
        "--human-approved",
        action="store_true",
        help="Required for core status or other human-gated scaffolds.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    require_valid_name(args.kind, args.name)

    existing = collect_existing(root)
    overlaps = overlap_candidates(
        args.kind, args.name, args.purpose, existing, args.overlap_threshold
    )
    exact_exists = any(item.name == args.name and item.kind == args.kind for item, _ in overlaps)

    if args.mode == "proposal":
        if args.dry_run:
            print(f"[dry-run] proposal would be written for {args.kind}: {args.name}")
            if overlaps:
                print("Overlap candidates found; prefer updating existing capability when appropriate.")
            return
        target = create_proposal(root, args.kind, args.name, args.purpose, args.status, overlaps)
        print(f"Proposal written: {target.relative_to(root)}")
        if overlaps:
            print("Overlap candidates found; prefer updating existing capability when appropriate.")
        return

    if exact_exists:
        raise SystemExit(f"{args.kind.capitalize()} already exists. Update it instead of duplicating it.")
    if overlaps and not args.allow_overlap:
        names = ", ".join(f"{item.name} ({score:.2f})" for item, score in overlaps)
        raise SystemExit(f"Overlap candidates block apply without --allow-overlap: {names}")
    if args.status in CORE_GATED and not args.human_approved:
        raise SystemExit("Core scaffolds require --human-approved.")

    if args.dry_run:
        print(f"[dry-run] {args.kind} scaffold would be applied: {args.name}")
        if args.kind == "skill":
            print("[dry-run] manifest, inventory, provenance, and proposal files would be updated.")
        else:
            print("[dry-run] manifest, inventory, and proposal files would be updated.")
        return

    if args.kind == "skill":
        apply_skill(root, args.name, args.purpose, args.status)
    else:
        apply_agent(root, args.name, args.purpose, args.status)

    create_proposal(root, args.kind, args.name, args.purpose, args.status, overlaps)
    print(f"{args.kind.capitalize()} scaffold applied: {args.name}")
    print("Run: python scripts/evolve-workspace.py --write-catalog --strict")
    print("Run: python scripts/validate-skills.py --strict")
    print("Run: bash scripts/healthcheck.sh --strict")


if __name__ == "__main__":
    main()
