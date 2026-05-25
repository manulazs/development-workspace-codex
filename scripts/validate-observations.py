#!/usr/bin/env python3
"""Validate Codex-native continuous-evolution observation scaffolding."""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


ALLOWED_STATUSES = {"OPEN", "ACTIONED", "DECLINED", "SUPERSEDED"}
PRIVATE_PREFIXES = (".codex-local/", "skill-observations/", "skill-updates/")
TEMPLATE_DIR = Path("docs/evolution/templates")
REQUIRED_TEMPLATES = {
    "observation-log.md": [
        "OBS-YYYYMMDD-001",
        "**Status:**",
        "**Date:**",
        "**Source:**",
        "**Target:**",
        "**Type:**",
        "**Sensitivity:**",
        "**Evidence summary:**",
        "**Proposed change:**",
        "**Gate:**",
        "**Resolution note:**",
    ],
    "cross-cutting-principles.md": [
        "PRIN-YYYYMMDD-001",
        "**Status:**",
        "**Evidence:**",
        "**ADR:**",
        "**Scope:**",
        "**Rule:**",
        "**Reason:**",
        "**Propagation:**",
        "at least two linked observations",
    ],
    "review-report.md": [
        "Observation Review Report",
        "Open observations reviewed",
        "Staged For Review",
        "Declined Or Superseded",
    ],
    "staged-update-note.md": [
        "Staged Update Note",
        ".codex-local/evolution/staged-updates",
        "Related observations",
        "Validation commands",
    ],
}
REQUIRED_DOC_TERMS = {
    "docs/continuous-evolution.md": [
        ".codex-local/evolution/observations",
        "observe -> log -> review -> stage -> validate -> apply/decline -> archive",
        "OPEN",
        "ACTIONED",
        "DECLINED",
        "SUPERSEDED",
    ],
    "docs/self-improvement-lifecycle.md": [
        ".codex-local/evolution/observations",
        "at least two observations",
        "ADR",
    ],
    "skills/continuous-evolution/SKILL.md": [
        ".codex-local/evolution/observations",
        "staged-updates",
        "human-gated",
    ],
}
STATUS_RE = re.compile(r"^\*\*Status:\*\*\s*([A-Z-]+)\b", re.MULTILINE)
OBS_ID_RE = re.compile(r"\bOBS-\d{8}-\d{3}\b")
OBS_HEADING_RE = re.compile(r"^### Observation\s+(OBS-\d{8}-\d{3}):", re.MULTILINE)
PRINCIPLE_RE = re.compile(r"^### Principle\s+(PRIN-\d{8}-\d{3}):", re.MULTILINE)
EVIDENCE_RE = re.compile(r"^\*\*Evidence:\*\*\s*(.+)$", re.MULTILINE)
ADR_RE = re.compile(r"^\*\*ADR:\*\*\s*(.+)$", re.MULTILINE)
OBSERVATION_FIELDS = [
    "Status",
    "Date",
    "Source",
    "Target",
    "Type",
    "Sensitivity",
    "Evidence summary",
    "Proposed change",
    "Gate",
    "Resolution note",
]
PRINCIPLE_FIELDS = [
    "Status",
    "Date",
    "Evidence",
    "ADR",
    "Scope",
    "Rule",
    "Reason",
    "Propagation",
    "Resolution note",
]


@dataclass
class Finding:
    level: str
    message: str


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def add(finding_list: list[Finding], level: str, message: str) -> None:
    finding_list.append(Finding(level, message))


def validate_required_file(root: Path, relative: str, terms: list[str], findings: list[Finding]) -> None:
    path = root / relative
    if not path.is_file():
        add(findings, "FAIL", f"Required observation file missing: {relative}")
        return
    text = read_text(path)
    missing = [term for term in terms if term not in text]
    if missing:
        add(findings, "FAIL", f"{relative} missing required terms: {', '.join(missing)}")
    else:
        add(findings, "INFO", f"Observation contract file OK: {relative}")


def git_ls_files(root: Path) -> list[str]:
    try:
        completed = subprocess.run(
            ["git", "ls-files"],
            cwd=root,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
    except OSError:
        return []
    if completed.returncode != 0:
        return []
    return [line.strip() for line in completed.stdout.splitlines() if line.strip()]


def validate_private_paths(root: Path, findings: list[Finding]) -> None:
    tracked = git_ls_files(root)
    leaked = [path for path in tracked if path.startswith(PRIVATE_PREFIXES)]
    if leaked:
        add(findings, "FAIL", "Private observation/runtime paths are tracked: " + ", ".join(leaked))
    else:
        add(findings, "INFO", "No private observation/runtime paths are tracked.")

    gitignore = root / ".gitignore"
    if not gitignore.is_file():
        add(findings, "FAIL", ".gitignore is missing.")
        return
    ignore_text = read_text(gitignore)
    missing = [prefix for prefix in PRIVATE_PREFIXES if prefix not in ignore_text]
    if missing:
        add(findings, "FAIL", ".gitignore does not ignore private observation paths: " + ", ".join(missing))
    else:
        add(findings, "INFO", ".gitignore protects private observation paths.")


def field_pattern(field: str) -> re.Pattern[str]:
    return re.compile(rf"^\*\*{re.escape(field)}:\*\*", re.MULTILINE)


def validate_entry_fields(
    label: str,
    entry_id: str,
    block: str,
    required_fields: list[str],
    findings: list[Finding],
) -> None:
    missing = [field for field in required_fields if not field_pattern(field).search(block)]
    if missing:
        add(findings, "FAIL", f"{label} entry {entry_id} missing required fields: {', '.join(missing)}")

    status_match = STATUS_RE.search(block)
    if not status_match:
        add(findings, "FAIL", f"{label} entry {entry_id} missing required Status field.")
        return
    status = status_match.group(1)
    if status not in ALLOWED_STATUSES:
        add(findings, "FAIL", f"{label} entry {entry_id} uses unsupported status: {status}")


def iter_entry_blocks(pattern: re.Pattern[str], text: str) -> list[tuple[str, str]]:
    matches = list(pattern.finditer(text))
    entries: list[tuple[str, str]] = []
    for index, match in enumerate(matches):
        start = match.end()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        entries.append((match.group(1), text[start:end]))
    return entries


def validate_optional_observation_root(root: Path, observations_root: Path, findings: list[Finding]) -> None:
    resolved = observations_root if observations_root.is_absolute() else root / observations_root
    if not resolved.exists():
        add(findings, "INFO", f"Observation root not present; skipped local log validation: {resolved}")
        return
    if not resolved.is_dir():
        add(findings, "FAIL", f"Observation root is not a directory: {resolved}")
        return

    log_path = resolved / "log.md"
    if log_path.exists():
        log_text = read_text(log_path)
        entries = iter_entry_blocks(OBS_HEADING_RE, log_text)
        ids = [entry_id for entry_id, _ in entries]
        duplicates = sorted({obs_id for obs_id in ids if ids.count(obs_id) > 1})
        if duplicates:
            add(findings, "FAIL", f"{log_path} has duplicate observation IDs: {', '.join(duplicates)}")
        else:
            add(findings, "INFO", f"{log_path} observation IDs are unique.")
        if entries:
            for entry_id, block in entries:
                validate_entry_fields(log_path.as_posix(), entry_id, block, OBSERVATION_FIELDS, findings)
            add(findings, "INFO", f"{log_path} observation entry structure checked.")
        else:
            add(findings, "INFO", f"{log_path} has no observation entries.")
    else:
        add(findings, "INFO", f"No local observation log found at {log_path}; skipped.")

    principles_path = resolved / "cross-cutting-principles.md"
    if principles_path.exists():
        principles_text = read_text(principles_path)
        entries = iter_entry_blocks(PRINCIPLE_RE, principles_text)
        ids = [entry_id for entry_id, _ in entries]
        duplicates = sorted({principle_id for principle_id in ids if ids.count(principle_id) > 1})
        if duplicates:
            add(findings, "FAIL", f"{principles_path} has duplicate principle IDs: {', '.join(duplicates)}")
        for principle_id, block in entries:
            validate_entry_fields(principles_path.as_posix(), principle_id, block, PRINCIPLE_FIELDS, findings)
            evidence_match = EVIDENCE_RE.search(block)
            adr_match = ADR_RE.search(block)
            evidence_count = len(OBS_ID_RE.findall(evidence_match.group(1) if evidence_match else ""))
            adr_text = adr_match.group(1).strip() if adr_match else ""
            has_adr = bool(adr_text and adr_text.lower() not in {"optional", "none", "n/a"})
            if evidence_count < 2 and not has_adr:
                add(
                    findings,
                    "FAIL",
                    f"{principles_path} principle {principle_id} needs at least two observations or one ADR.",
                )
        if entries:
            add(findings, "INFO", f"{principles_path} principle structure checked.")
        else:
            add(findings, "INFO", f"{principles_path} has no principle entries.")
    else:
        add(findings, "INFO", f"No local cross-cutting principles file found at {principles_path}; skipped.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate Codex-native observation scaffolding.")
    parser.add_argument("--repo", default=".", help="Repository root. Defaults to current directory.")
    parser.add_argument(
        "--observations-root",
        help="Optional private observation root to validate. Omitted by default to keep repository health independent from local runtime state.",
    )
    parser.add_argument("--strict", action="store_true", help="Treat warnings as failures.")
    args = parser.parse_args()

    root = Path(args.repo).resolve()
    findings: list[Finding] = []

    for filename, terms in REQUIRED_TEMPLATES.items():
        validate_required_file(root, (TEMPLATE_DIR / filename).as_posix(), terms, findings)
    for relative, terms in REQUIRED_DOC_TERMS.items():
        validate_required_file(root, relative, terms, findings)

    validate_private_paths(root, findings)
    if args.observations_root:
        validate_optional_observation_root(root, Path(args.observations_root), findings)
    else:
        add(findings, "INFO", "Private observation log validation skipped; pass --observations-root to opt in.")

    info = sum(1 for item in findings if item.level == "INFO")
    warn = sum(1 for item in findings if item.level == "WARN")
    fail = sum(1 for item in findings if item.level == "FAIL")
    for item in findings:
        print(f"[{item.level}] {item.message}")
    print()
    print(f"Summary: {info} info, {warn} warnings, {fail} failures.")
    if fail or (args.strict and warn):
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
