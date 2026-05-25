#!/usr/bin/env python3
"""Read-only workspace readiness and profile drift checks."""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path


BLOCKED = {"curated", "review", "deprecated", "archived"}
PRIVATE_TRACKED_MARKERS = (
    ".codex-local/",
    ".codex/sessions/",
    ".codex/cache/",
    ".codex/logs_",
    ".codex/state_",
)


@dataclass
class Finding:
    level: str
    message: str


def load_manifest(root: Path) -> dict[str, object]:
    return json.loads((root / "workspace-manifest.json").read_text(encoding="utf-8"))


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


def check_repo(root: Path, profile: str) -> list[Finding]:
    findings: list[Finding] = []
    manifest = load_manifest(root)
    manifest_skills = manifest.get("skills", {})
    manifest_agents = manifest.get("agents", {})
    if not isinstance(manifest_skills, dict) or not isinstance(manifest_agents, dict):
        return [Finding("FAIL", "workspace-manifest.json must contain skills and agents objects.")]

    repo_skills = {path.name for path in (root / "skills").iterdir() if path.is_dir()}
    repo_agents = {path.stem for path in (root / ".codex" / "agents").glob("*.toml")}
    selected_skills, selected_agents = resolve_profile(manifest, profile)

    for skill in sorted(repo_skills - set(manifest_skills)):
        findings.append(Finding("FAIL", f"Skill exists but is not classified: {skill}"))
    for agent in sorted(repo_agents - set(manifest_agents)):
        findings.append(Finding("FAIL", f"Agent exists but is not classified: {agent}"))
    for skill in sorted(set(manifest_skills) - repo_skills):
        findings.append(Finding("FAIL", f"Manifest references missing skill: {skill}"))
    for agent in sorted(set(manifest_agents) - repo_agents):
        findings.append(Finding("FAIL", f"Manifest references missing agent: {agent}"))

    for skill in sorted(selected_skills):
        status = str(manifest_skills.get(skill, "missing"))
        if status in BLOCKED:
            findings.append(Finding("FAIL", f"Profile {profile} includes blocked skill {skill} ({status})"))
    for agent in sorted(selected_agents):
        status = str(manifest_agents.get(agent, "missing"))
        if status in BLOCKED:
            findings.append(Finding("FAIL", f"Profile {profile} includes blocked agent {agent} ({status})"))

    try:
        import subprocess

        result = subprocess.run(
            ["git", "ls-files"],
            cwd=root,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        if result.returncode == 0:
            for tracked in result.stdout.splitlines():
                if any(marker in tracked for marker in PRIVATE_TRACKED_MARKERS):
                    findings.append(Finding("FAIL", f"Private/runtime path is tracked: {tracked}"))
    except Exception as exc:  # pragma: no cover - defensive CLI reporting
        findings.append(Finding("WARN", f"Skipped tracked private path check: {exc}"))

    if not findings:
        findings.append(Finding("INFO", f"Repository profile {profile} is internally consistent."))
    return findings


def check_runtime(root: Path, profile: str, codex_home: Path) -> list[Finding]:
    findings: list[Finding] = []
    manifest = load_manifest(root)
    selected_skills, selected_agents = resolve_profile(manifest, profile)
    for skill in sorted(selected_skills):
        if not (codex_home / "skills" / skill / "SKILL.md").exists():
            findings.append(Finding("WARN", f"Runtime missing profile skill: {skill}"))
    for agent in sorted(selected_agents):
        if not (codex_home / "agents" / f"{agent}.toml").exists():
            findings.append(Finding("WARN", f"Runtime missing profile agent: {agent}"))
    if not (codex_home / "AGENTS.md").exists():
        findings.append(Finding("WARN", f"Runtime global instructions missing: {codex_home / 'AGENTS.md'}"))
    if not findings:
        findings.append(Finding("INFO", f"Runtime appears aligned for profile {profile}: {codex_home}"))
    return findings


def print_findings(findings: list[Finding]) -> int:
    fail_count = sum(1 for item in findings if item.level == "FAIL")
    warn_count = sum(1 for item in findings if item.level == "WARN")
    info_count = sum(1 for item in findings if item.level == "INFO")
    print("Workspace Doctor")
    print("================")
    for item in findings:
        print(f"[{item.level}] {item.message}")
    print()
    print(f"Summary: {info_count} info, {warn_count} warnings, {fail_count} failures.")
    return 1 if fail_count else 0


def main() -> None:
    parser = argparse.ArgumentParser(description="Read-only workspace doctor.")
    parser.add_argument("--repo", default=".", help="Repository root.")
    parser.add_argument("--profile", default="governed-codex", help="Profile to validate.")
    parser.add_argument("--codex-home", help="Optional runtime path for drift checks.")
    parser.add_argument("--strict", action="store_true", help="Treat runtime warnings as failures.")
    args = parser.parse_args()

    root = Path(args.repo).resolve()
    findings = check_repo(root, args.profile)
    if args.codex_home:
        findings.extend(check_runtime(root, args.profile, Path(args.codex_home).expanduser()))
    exit_code = print_findings(findings)
    if args.strict and any(item.level == "WARN" for item in findings):
        exit_code = 1
    raise SystemExit(exit_code)


if __name__ == "__main__":
    main()
