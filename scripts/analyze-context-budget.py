#!/usr/bin/env python3
"""Estimate repository context/token load without mutating files."""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass
from pathlib import Path


TOKEN_RE = re.compile(r"[A-Za-z0-9_'-]+")
LOADABLE_DOCS = {
    "AGENTS.md",
    "codex-global/AGENTS.md",
    "docs/subagent-context-protocol.md",
    "docs/subagents-policy.md",
    "docs/continuous-evolution.md",
    "docs/capability-inventory.md",
}


@dataclass(frozen=True)
class Component:
    kind: str
    name: str
    path: str
    status: str
    lines: int
    tokens: int
    bucket: str
    recommendation: str


def read_json(path: Path) -> dict[str, object]:
    return json.loads(path.read_text(encoding="utf-8"))


def estimate_tokens(text: str) -> int:
    return int(len(TOKEN_RE.findall(text)) * 1.3)


def text_stats(path: Path) -> tuple[int, int]:
    text = path.read_text(encoding="utf-8", errors="replace")
    return len(text.splitlines()), estimate_tokens(text)


def resolve_profile(manifest: dict[str, object], profile_name: str) -> tuple[set[str], set[str]]:
    profiles = manifest.get("profiles", {})
    if not isinstance(profiles, dict) or profile_name not in profiles:
        raise SystemExit(f"Unknown profile: {profile_name}")

    skills: set[str] = set()
    agents: set[str] = set()

    def visit(name: str, seen: set[str]) -> None:
        if name in seen:
            return
        seen.add(name)
        raw = profiles.get(name)
        if not isinstance(raw, dict):
            return
        for parent in raw.get("extends", []):
            visit(str(parent), seen)
        skills.update(str(item) for item in raw.get("skills", []))
        agents.update(str(item) for item in raw.get("agents", []))

    visit(profile_name, set())
    return skills, agents


def bucket_for(status: str, selected: bool) -> str:
    if selected:
        return "always"
    if status == "optional":
        return "optional"
    if status in {"review", "curated"}:
        return status
    if status in {"deprecated", "archived"}:
        return "candidate-prune"
    return "optional"


def recommendation_for(kind: str, bucket: str, lines: int, tokens: int) -> str:
    if bucket == "candidate-prune":
        return "Review for archive/removal from loadable surfaces."
    if bucket in {"review", "curated"}:
        return "Keep out of default profiles unless reviewed."
    if lines > 450 or tokens > 3500:
        return "Consider splitting, summarizing, or lazy-loading."
    if kind == "doc" and lines > 220:
        return "Keep concise because it may be read often."
    return "No immediate action."


def collect_components(root: Path, profile: str | None) -> tuple[list[Component], dict[str, object]]:
    manifest = read_json(root / "workspace-manifest.json")
    manifest_skills = manifest.get("skills", {})
    manifest_agents = manifest.get("agents", {})
    if not isinstance(manifest_skills, dict) or not isinstance(manifest_agents, dict):
        raise SystemExit("workspace-manifest.json must contain skills and agents objects.")

    selected_skills: set[str] = set()
    selected_agents: set[str] = set()
    if profile:
        selected_skills, selected_agents = resolve_profile(manifest, profile)

    components: list[Component] = []

    for skill_dir in sorted((root / "skills").iterdir()):
        skill_file = skill_dir / "SKILL.md"
        if not skill_dir.is_dir() or not skill_file.exists():
            continue
        status = str(manifest_skills.get(skill_dir.name, "unclassified"))
        lines, tokens = text_stats(skill_file)
        bucket = bucket_for(status, skill_dir.name in selected_skills)
        components.append(
            Component(
                "skill",
                skill_dir.name,
                skill_file.relative_to(root).as_posix(),
                status,
                lines,
                tokens,
                bucket,
                recommendation_for("skill", bucket, lines, tokens),
            )
        )

    for agent_file in sorted((root / ".codex" / "agents").glob("*.toml")):
        status = str(manifest_agents.get(agent_file.stem, "unclassified"))
        lines, tokens = text_stats(agent_file)
        bucket = bucket_for(status, agent_file.stem in selected_agents)
        components.append(
            Component(
                "agent",
                agent_file.stem,
                agent_file.relative_to(root).as_posix(),
                status,
                lines,
                tokens,
                bucket,
                recommendation_for("agent", bucket, lines, tokens),
            )
        )

    for doc in sorted(LOADABLE_DOCS):
        path = root / doc
        if not path.exists():
            continue
        lines, tokens = text_stats(path)
        components.append(
            Component(
                "doc",
                path.stem,
                path.relative_to(root).as_posix(),
                "public-doc",
                lines,
                tokens,
                "always",
                recommendation_for("doc", "always", lines, tokens),
            )
        )

    summary: dict[str, object] = {
        "profile": profile,
        "component_count": len(components),
        "total_tokens": sum(item.tokens for item in components),
        "by_kind": {},
        "by_bucket": {},
        "top_heavy": [asdict(item) for item in sorted(components, key=lambda x: x.tokens, reverse=True)[:10]],
        "recommendations": [
            asdict(item)
            for item in components
            if item.recommendation != "No immediate action."
        ],
    }
    for item in components:
        by_kind = summary["by_kind"]
        by_bucket = summary["by_bucket"]
        assert isinstance(by_kind, dict)
        assert isinstance(by_bucket, dict)
        by_kind[item.kind] = int(by_kind.get(item.kind, 0)) + item.tokens
        by_bucket[item.bucket] = int(by_bucket.get(item.bucket, 0)) + item.tokens
    return components, summary


def print_text(summary: dict[str, object], components: list[Component]) -> None:
    print("Context Budget Audit")
    print("====================")
    print(f"Profile: {summary['profile'] or 'all repository components'}")
    print(f"Components: {summary['component_count']}")
    print(f"Estimated tokens: {summary['total_tokens']}")
    print()
    print("By kind:")
    for key, value in sorted(dict(summary["by_kind"]).items()):
        print(f"  {key}: {value}")
    print()
    print("By bucket:")
    for key, value in sorted(dict(summary["by_bucket"]).items()):
        print(f"  {key}: {value}")
    print()
    print("Top heavy components:")
    for item in sorted(components, key=lambda x: x.tokens, reverse=True)[:10]:
        print(f"  {item.tokens:>6} tokens  {item.path}  [{item.bucket}]")
    recommendations = [item for item in components if item.recommendation != "No immediate action."]
    if recommendations:
        print()
        print("Recommendations:")
        for item in recommendations[:20]:
            print(f"  - {item.path}: {item.recommendation}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Estimate repository context budget.")
    parser.add_argument("--repo", default=".", help="Repository root.")
    parser.add_argument("--profile", help="Optional workspace profile to mark selected capabilities.")
    parser.add_argument("--json", action="store_true", help="Emit JSON summary.")
    args = parser.parse_args()

    root = Path(args.repo).resolve()
    components, summary = collect_components(root, args.profile)
    if args.json:
        print(json.dumps(summary, indent=2, ensure_ascii=False))
    else:
        print_text(summary, components)


if __name__ == "__main__":
    main()
