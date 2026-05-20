#!/usr/bin/env python3
"""Validate Python syntax without writing bytecode files."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


def validate_file(path: Path) -> str | None:
    if not path.exists():
        return f"{path.as_posix()}: file not found"
    if not path.is_file():
        return f"{path.as_posix()}: not a file"

    try:
        source = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        source = path.read_text(encoding="utf-8", errors="replace")
    except OSError as exc:
        return f"{path.as_posix()}: cannot read file: {exc}"

    try:
        compile(source, str(path), "exec")
    except SyntaxError as exc:
        location = f"{exc.filename}:{exc.lineno}:{exc.offset}" if exc.lineno else str(path)
        return f"{location}: {exc.msg}"
    except ValueError as exc:
        return f"{path.as_posix()}: invalid source: {exc}"

    return None


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate Python source syntax in memory without creating __pycache__ files."
    )
    parser.add_argument("files", nargs="+", help="Python files to validate.")
    args = parser.parse_args()

    failures = []
    for raw_path in args.files:
        path = Path(raw_path)
        failure = validate_file(path)
        if failure:
            failures.append(failure)
            print(f"[FAIL] {failure}")
        else:
            print(f"[INFO] Syntax OK: {path.as_posix()}")

    print()
    print(f"Summary: {len(args.files) - len(failures)} passed, {len(failures)} failed.")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
