#!/usr/bin/env python3
"""Validate the repository's Caveman LITE activation contract."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError:
        raise AssertionError(f"Missing file: {path}") from None


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def validate_skill(skill_path: Path) -> None:
    text = read_text(skill_path)
    require("name: caveman" in text, f"{skill_path} must declare name: caveman.")
    require("lite" in text.lower(), f"{skill_path} must document lite mode.")
    require(
        "No filler/hedging. Keep articles + full sentences. Professional but tight" in text,
        f"{skill_path} must preserve the upstream lite-mode definition.",
    )


def validate_repo(repo_root: Path) -> list[str]:
    messages: list[str] = []

    validate_skill(repo_root / "skills" / "caveman" / "SKILL.md")

    manifest_path = repo_root / "workspace-manifest.json"
    manifest = json.loads(read_text(manifest_path))
    require(
        manifest.get("skills", {}).get("caveman") == "core",
        "workspace-manifest.json must classify caveman as core.",
    )
    governed = manifest.get("profiles", {}).get("governed-codex", {})
    require(
        "caveman" in governed.get("skills", []),
        "governed-codex profile must include caveman.",
    )

    global_agents = read_text(repo_root / "codex-global" / "AGENTS.md")
    require(
        "Use the `caveman` skill in `lite` mode" in global_agents,
        "codex-global/AGENTS.md must require caveman lite.",
    )
    require(
        "required workspace default" in global_agents,
        "codex-global/AGENTS.md must mark caveman lite as required.",
    )

    repo_agents = read_text(repo_root / "AGENTS.md")
    require(
        "`caveman lite` is the mandatory default communication style" in repo_agents,
        "AGENTS.md must mark caveman lite as mandatory.",
    )

    readme = read_text(repo_root / "README.md")
    require(
        "Codex install path is per-session" in readme,
        "README.md must explain that upstream Codex caveman is per-session.",
    )
    require(
        "--install-global-instructions" in readme,
        "README.md must document global instruction installation.",
    )

    install_sh = read_text(repo_root / "scripts" / "install-workspace.sh")
    require(
        "--install-global-instructions" in install_sh,
        "scripts/install-workspace.sh must support global instruction installation.",
    )
    install_ps1 = read_text(repo_root / "scripts" / "install-workspace.ps1")
    require(
        "InstallGlobalInstructions" in install_ps1,
        "scripts/install-workspace.ps1 must support global instruction installation.",
    )

    messages.append("Repository Caveman LITE contract is valid.")
    return messages


def validate_runtime(codex_home: Path) -> list[str]:
    messages: list[str] = []
    validate_skill(codex_home / "skills" / "caveman" / "SKILL.md")
    agents_text = read_text(codex_home / "AGENTS.md")
    require(
        "Use the `caveman` skill in `lite` mode" in agents_text,
        f"{codex_home / 'AGENTS.md'} must require caveman lite.",
    )
    require(
        "required workspace default" in agents_text,
        f"{codex_home / 'AGENTS.md'} must mark caveman lite as required.",
    )
    messages.append(f"Runtime Caveman LITE contract is valid: {codex_home}")
    return messages


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", default=".", help="Repository root to validate.")
    parser.add_argument(
        "--codex-home",
        help="Optional Codex home to validate for active global runtime installation.",
    )
    args = parser.parse_args()

    try:
        messages = validate_repo(Path(args.repo).resolve())
        if args.codex_home:
            messages.extend(validate_runtime(Path(args.codex_home).expanduser().resolve()))
    except AssertionError as exc:
        print(f"[FAIL] {exc}")
        return 1

    for message in messages:
        print(f"[OK] {message}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
