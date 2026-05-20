#!/usr/bin/env python3
"""Validate repository skill metadata without external dependencies."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


ALLOWED_STATUSES = {"core", "optional", "curated", "review", "deprecated", "archived"}
BLOCKED_PROFILE_STATUSES = {"curated", "review", "deprecated", "archived"}


class Reporter:
    def __init__(self) -> None:
        self.infos: list[str] = []
        self.warnings: list[str] = []
        self.failures: list[str] = []

    def info(self, message: str) -> None:
        self.infos.append(message)

    def warn(self, message: str) -> None:
        self.warnings.append(message)

    def fail(self, message: str) -> None:
        self.failures.append(message)

    def print(self) -> None:
        print("Skill validation")
        print("================")
        for message in self.infos:
            print(f"[INFO] {message}")
        for message in self.warnings:
            print(f"[WARN] {message}")
        for message in self.failures:
            print(f"[FAIL] {message}")
        print()
        print(
            f"Summary: {len(self.infos)} info, "
            f"{len(self.warnings)} warnings, {len(self.failures)} failures."
        )


def load_json(path: Path, reporter: Reporter) -> dict[str, object]:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:  # pragma: no cover - defensive CLI reporting
        reporter.fail(f"{path.as_posix()} is not valid JSON: {exc}")
        return {}


def parse_frontmatter(path: Path, reporter: Reporter) -> dict[str, str]:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    if not lines or lines[0] != "---":
        reporter.fail(f"{path.as_posix()} frontmatter must start with ---.")
        return {}

    end_index = -1
    for index, line in enumerate(lines[1:80], start=1):
        if line == "---":
            end_index = index
            break
    if end_index < 0:
        reporter.fail(f"{path.as_posix()} frontmatter closing delimiter not found.")
        return {}

    values: dict[str, str] = {}
    for line in lines[1:end_index]:
        if not line or line.startswith((" ", "\t")) or ":" not in line:
            continue
        key, value = line.split(":", 1)
        values[key.strip()] = value.strip().strip('"')
    return values


def require_doc_mentions(doc_path: Path, label: str, names: list[str], reporter: Reporter) -> None:
    if not doc_path.exists():
        reporter.fail(f"Required {label} document is missing: {doc_path.as_posix()}")
        return

    text = doc_path.read_text(encoding="utf-8", errors="replace")
    for name in names:
        if name not in text:
            reporter.fail(f"{label} does not mention skill: {name}")
    reporter.info(f"{label} covers {len(names)} skills.")


def validate_manifest(
    manifest: dict[str, object],
    skill_names: list[str],
    reporter: Reporter,
) -> None:
    manifest_skills = manifest.get("skills")
    profiles = manifest.get("profiles")
    if not isinstance(manifest_skills, dict):
        reporter.fail("workspace-manifest.json must contain a skills object.")
        return
    if not isinstance(profiles, dict):
        reporter.fail("workspace-manifest.json must contain a profiles object.")
        return

    for skill in skill_names:
        status = manifest_skills.get(skill)
        if status is None:
            reporter.fail(f"Manifest does not classify skill: {skill}")
        elif status not in ALLOWED_STATUSES:
            reporter.fail(f"Manifest skill '{skill}' has unsupported status '{status}'.")

    for skill in manifest_skills:
        if skill not in skill_names:
            reporter.fail(f"Manifest references missing skill directory: {skill}")

    for profile_name, raw_profile in profiles.items():
        if not isinstance(raw_profile, dict):
            reporter.fail(f"Profile '{profile_name}' must be an object.")
            continue
        for skill in raw_profile.get("skills", []):
            status = manifest_skills.get(skill)
            if status is None:
                reporter.fail(f"Profile '{profile_name}' references unknown skill '{skill}'.")
            elif status in BLOCKED_PROFILE_STATUSES:
                reporter.fail(
                    f"Profile '{profile_name}' references non-installable skill "
                    f"'{skill}' with status '{status}'."
                )
    reporter.info("workspace-manifest.json skill profile checks passed.")


def validate_skills(root: Path, strict: bool) -> int:
    reporter = Reporter()
    skills_root = root / "skills"
    manifest_path = root / "workspace-manifest.json"
    inventory_path = root / "docs" / "capability-inventory.md"
    provenance_path = root / "docs" / "skills-provenance.md"

    if not skills_root.is_dir():
        reporter.fail("skills/ directory is missing.")
        reporter.print()
        return 1

    skill_dirs = sorted(path for path in skills_root.iterdir() if path.is_dir())
    skill_names = [path.name for path in skill_dirs]
    if not skill_names:
        reporter.fail("No skill directories found under skills/.")

    for skill_dir in skill_dirs:
        skill_file = skill_dir / "SKILL.md"
        if not skill_file.exists():
            reporter.fail(f"{skill_file.as_posix()} is missing.")
            continue
        frontmatter = parse_frontmatter(skill_file, reporter)
        name = frontmatter.get("name")
        description = frontmatter.get("description")
        if not name:
            reporter.fail(f"{skill_file.as_posix()} missing name in frontmatter.")
        elif name != skill_dir.name:
            reporter.warn(
                f"{skill_file.as_posix()} frontmatter name '{name}' differs from directory "
                f"'{skill_dir.name}'."
            )
        if not description:
            reporter.fail(f"{skill_file.as_posix()} missing description in frontmatter.")

    reporter.info(f"Discovered {len(skill_names)} skills.")

    manifest = load_json(manifest_path, reporter)
    if manifest:
        validate_manifest(manifest, skill_names, reporter)

    require_doc_mentions(inventory_path, "Capability inventory", skill_names, reporter)
    require_doc_mentions(provenance_path, "Skill provenance matrix", skill_names, reporter)

    reporter.print()
    if reporter.failures or (strict and reporter.warnings):
        return 1
    return 0


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate repository skill metadata.")
    parser.add_argument("--root", default=".", help="Repository root. Defaults to current directory.")
    parser.add_argument("--strict", action="store_true", help="Treat warnings as failures.")
    args = parser.parse_args()

    raise SystemExit(validate_skills(Path(args.root).resolve(), args.strict))


if __name__ == "__main__":
    main()
