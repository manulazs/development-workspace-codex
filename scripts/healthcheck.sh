#!/usr/bin/env bash
set -u

STRICT=0
for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
    -h|--help)
      cat <<'EOF'
Usage: scripts/healthcheck.sh [--strict]

Validates this portable Codex workspace repository on macOS/Linux. Runtime state
under ~/.codex is intentionally out of scope.
EOF
      exit 0
      ;;
    *)
      echo "[FAIL] Unknown argument: $arg"
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INFO_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0
INFOS=()
WARNS=()
FAILS=()

add_result() {
  level="$1"
  message="$2"
  case "$level" in
    INFO) INFOS+=("$message"); INFO_COUNT=$((INFO_COUNT + 1)) ;;
    WARN) WARNS+=("$message"); WARN_COUNT=$((WARN_COUNT + 1)) ;;
    FAIL) FAILS+=("$message"); FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
  esac
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

find_python() {
  for candidate in python3 python; do
    if command_exists "$candidate"; then
      if "$candidate" -c 'import sys; raise SystemExit(0 if sys.version_info[0] >= 3 else 1)' >/dev/null 2>&1; then
        echo "$candidate"
        return
      fi
    fi
  done
  echo ""
}

cd "$REPO_ROOT" || exit 1
add_result INFO "Repository root: $REPO_ROOT"
add_result INFO "Runtime state under ~/.codex is intentionally out of scope for this repository healthcheck."

if ! command_exists git; then
  add_result FAIL "git is not available on PATH."
elif ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  add_result FAIL "Current directory is not a git worktree."
else
  add_result INFO "Git worktree detected."
fi

required_dirs="
skills
.codex/agents
codex-global
docs/decisions
docs/runbooks
docs/operations
docs/audits
docs/evolution
docs/evolution/reports
docs/lessons
docs/patterns
scripts
"

for dir in $required_dirs; do
  if [ -d "$dir" ]; then
    add_result INFO "Directory exists: $dir"
  else
    add_result FAIL "Required directory missing: $dir"
  fi
done

required_docs="
README.md
.gitattributes
LICENSE
CONTRIBUTING.md
CHANGELOG.md
SECURITY.md
CODE_OF_CONDUCT.md
workspace-manifest.json
docs/README.md
docs/capability-inventory.md
docs/skills-provenance.md
docs/agentic-controls.md
docs/continuous-evolution.md
docs/subagent-context-protocol.md
docs/skill-template.md
docs/agent-template.md
docs/subagents-policy.md
docs/subagents-lifecycle.md
docs/self-improvement-lifecycle.md
docs/lessons/TEMPLATE.md
docs/patterns/TEMPLATE.md
docs/patterns/rejected/README.md
docs/audits/TEMPLATE.md
docs/decisions/TEMPLATE.md
docs/archive/README.md
docs/runbooks/setup-windows.md
docs/runbooks/setup-macos.md
"

for doc in $required_docs; do
  if [ -f "$doc" ]; then
    add_result INFO "Required file exists: $doc"
  else
    add_result FAIL "Required file missing: $doc"
  fi
done

skill_files=()
while IFS= read -r skill_file; do
  skill_files+=("$skill_file")
done < <(find skills -mindepth 2 -maxdepth 2 -name SKILL.md -type f 2>/dev/null | sort)

repo_skills=()
for skill_file in "${skill_files[@]}"; do
  repo_skills+=("$(basename "$(dirname "$skill_file")")")
done

if [ "${#skill_files[@]}" -eq 0 ]; then
  add_result FAIL "No skills with SKILL.md found under skills/."
else
  add_result INFO "Skills discovered: ${#skill_files[@]}"
fi

for skill_file in "${skill_files[@]}"; do
  first_line="$(sed -n '1p' "$skill_file")"
  if [ "$first_line" != "---" ]; then
    add_result FAIL "$skill_file frontmatter must start with ---."
    continue
  fi
  if ! awk 'NR > 1 && NR <= 60 && $0 == "---" { found=1 } END { exit found ? 0 : 1 }' "$skill_file"; then
    add_result FAIL "$skill_file frontmatter closing delimiter not found in first 60 lines."
    continue
  fi
  if ! sed -n '2,60p' "$skill_file" | grep -Eq '^name:[[:space:]]*"?[^"]+"?[[:space:]]*$'; then
    add_result FAIL "$skill_file missing simple name field in frontmatter."
  fi
  if ! sed -n '2,60p' "$skill_file" | grep -Eq '^description:[[:space:]]*.+'; then
    add_result FAIL "$skill_file missing description field in frontmatter."
  fi
done

agent_files=()
while IFS= read -r agent_file; do
  agent_files+=("$agent_file")
done < <(find .codex/agents -maxdepth 1 -name '*.toml' -type f 2>/dev/null | sort)

repo_agents=()
for agent_file in "${agent_files[@]}"; do
  repo_agents+=("$(basename "$agent_file" .toml)")
done

if [ "${#agent_files[@]}" -eq 0 ]; then
  add_result FAIL "No custom agent TOML files found under .codex/agents/."
else
  add_result INFO "Custom agents discovered: ${#agent_files[@]}"
fi

for agent_file in "${agent_files[@]}"; do
  for field in name description model model_reasoning_effort sandbox_mode developer_instructions; do
    if ! grep -Eq "^${field}[[:space:]]*=" "$agent_file"; then
      add_result FAIL "$agent_file missing required field: $field."
    fi
  done
done

PYTHON_BIN="$(find_python)"
if [ -z "$PYTHON_BIN" ]; then
  add_result WARN "Python 3 is not available; skipped JSON manifest and migrate validation."
else
  manifest_report="$(mktemp "${TMPDIR:-/tmp}/codex-workspace-manifest.XXXXXX")"
  if "$PYTHON_BIN" - "workspace-manifest.json" > "$manifest_report" <<'PY'
import json
import os
import re
import sys

manifest_path = sys.argv[1]
allowed = {"core", "optional", "curated", "review", "deprecated", "archived"}
blocked = {"curated", "review", "deprecated", "archived"}
skill_name_re = re.compile(r"^[a-z][a-z0-9-]*[a-z0-9]$")
agent_name_re = re.compile(r"^[a-z][a-z0-9_]*[a-z0-9]$")

def emit(level, message):
    print(f"{level}\t{message}")

try:
    with open(manifest_path, encoding="utf-8") as handle:
        manifest = json.load(handle)
except Exception as exc:
    emit("FAIL", f"workspace-manifest.json is not valid JSON: {exc}")
    raise SystemExit(0)

emit("INFO", "workspace-manifest.json parsed successfully.")

repo_skills = sorted(
    name for name in os.listdir("skills")
    if os.path.isdir(os.path.join("skills", name))
)
repo_agents = sorted(
    os.path.splitext(name)[0]
    for name in os.listdir(".codex/agents")
    if name.endswith(".toml")
)
manifest_skills = manifest.get("skills", {})
manifest_agents = manifest.get("agents", {})

for status in manifest.get("statuses", {}):
    if status not in allowed:
        emit("FAIL", f"Manifest declares unsupported status: {status}")

for skill in repo_skills:
    if not skill_name_re.match(skill):
        emit("FAIL", f"Skill directory uses invalid name format: {skill}")
    if skill not in manifest_skills:
        emit("FAIL", f"Manifest does not classify skill: {skill}")
for skill, status in manifest_skills.items():
    if not skill_name_re.match(skill):
        emit("FAIL", f"Manifest skill uses invalid name format: {skill}")
    if skill not in repo_skills:
        emit("FAIL", f"Manifest references missing skill directory: {skill}")
    if status not in allowed:
        emit("FAIL", f"Manifest skill '{skill}' has unsupported status '{status}'.")

for agent in repo_agents:
    if not agent_name_re.match(agent):
        emit("FAIL", f"Agent file uses invalid name format: {agent}")
    if agent not in manifest_agents:
        emit("FAIL", f"Manifest does not classify agent: {agent}")
for agent, status in manifest_agents.items():
    if not agent_name_re.match(agent):
        emit("FAIL", f"Manifest agent uses invalid name format: {agent}")
    if agent not in repo_agents:
        emit("FAIL", f"Manifest references missing agent file: {agent}")
    if status not in allowed:
        emit("FAIL", f"Manifest agent '{agent}' has unsupported status '{status}'.")

profiles = manifest.get("profiles", {})
for profile_name, profile in profiles.items():
    for parent in profile.get("extends", []):
        if parent not in profiles:
            emit("FAIL", f"Profile '{profile_name}' extends unknown profile '{parent}'.")
    for skill in profile.get("skills", []):
        status = manifest_skills.get(skill)
        if status is None:
            emit("FAIL", f"Profile '{profile_name}' references unknown skill '{skill}'.")
        elif status in blocked:
            emit("FAIL", f"Profile '{profile_name}' references non-installable skill '{skill}' with status '{status}'.")
    for agent in profile.get("agents", []):
        status = manifest_agents.get(agent)
        if status is None:
            emit("FAIL", f"Profile '{profile_name}' references unknown agent '{agent}'.")
        elif status in blocked:
            emit("FAIL", f"Profile '{profile_name}' references non-installable agent '{agent}' with status '{status}'.")
PY
  then
    while IFS="$(printf '\t')" read -r level message; do
      [ -n "$level" ] && add_result "$level" "$message"
    done < "$manifest_report"
  else
    add_result FAIL "workspace-manifest.json validation script failed."
  fi
  rm -f "$manifest_report"
fi

if [ -f docs/capability-inventory.md ]; then
  inventory="$(cat docs/capability-inventory.md)"
  for skill_name in "${repo_skills[@]}"; do
    case "$inventory" in
      *"$skill_name"*) ;;
      *) add_result FAIL "Capability inventory does not mention skill: $skill_name" ;;
    esac
  done
  for agent_name in "${repo_agents[@]}"; do
    case "$inventory" in
      *"$agent_name"*) ;;
      *) add_result FAIL "Capability inventory does not mention agent: $agent_name" ;;
    esac
  done
else
  add_result FAIL "docs/capability-inventory.md is missing."
fi

migrate_cli="skills/migrate-to-codex/scripts/cli.py"
if [ -n "${PYTHON_BIN:-}" ] && [ -f "$migrate_cli" ]; then
  if "$PYTHON_BIN" "$migrate_cli" --validate-target . >/tmp/codex-workspace-migrate-validate.log 2>&1; then
    add_result INFO "migrate-to-codex validation passed."
  else
    add_result FAIL "migrate-to-codex validation failed. See /tmp/codex-workspace-migrate-validate.log."
  fi
elif [ -z "${PYTHON_BIN:-}" ]; then
  add_result WARN "Python 3 is not available; skipped migrate-to-codex validation."
else
  add_result WARN "migrate-to-codex validator not found at $migrate_cli."
fi

skill_validator="scripts/validate-skills.py"
if [ -n "${PYTHON_BIN:-}" ] && [ -f "$skill_validator" ]; then
  if "$PYTHON_BIN" "$skill_validator" --strict >/tmp/codex-workspace-skill-validate.log 2>&1; then
    add_result INFO "Repository skill validation passed."
  else
    add_result FAIL "Repository skill validation failed. See /tmp/codex-workspace-skill-validate.log."
  fi
elif [ -z "${PYTHON_BIN:-}" ]; then
  add_result WARN "Python 3 is not available; skipped repository skill validation."
else
  add_result WARN "Repository skill validator not found at $skill_validator."
fi

evolution_validator="scripts/evolve-workspace.py"
if [ -n "${PYTHON_BIN:-}" ] && [ -f "$evolution_validator" ]; then
  if "$PYTHON_BIN" "$evolution_validator" --strict >/tmp/codex-workspace-evolution-validate.log 2>&1; then
    add_result INFO "Continuous evolution validation passed."
  else
    add_result FAIL "Continuous evolution validation failed. See /tmp/codex-workspace-evolution-validate.log."
  fi
elif [ -z "${PYTHON_BIN:-}" ]; then
  add_result WARN "Python 3 is not available; skipped continuous evolution validation."
else
  add_result WARN "Continuous evolution validator not found at $evolution_validator."
fi

python_syntax_validator="scripts/validate-python-syntax.py"
if [ -n "${PYTHON_BIN:-}" ] && [ -f "$python_syntax_validator" ]; then
  if "$PYTHON_BIN" "$python_syntax_validator" \
    scripts/validate-skills.py \
    scripts/evolve-workspace.py \
    scripts/scaffold-capability.py \
    "$python_syntax_validator" >/tmp/codex-workspace-python-syntax.log 2>&1; then
    add_result INFO "Python syntax validation passed without bytecode writes."
  else
    add_result FAIL "Python syntax validation failed. See /tmp/codex-workspace-python-syntax.log."
  fi
elif [ -z "${PYTHON_BIN:-}" ]; then
  add_result WARN "Python 3 is not available; skipped Python syntax validation."
else
  add_result WARN "Python syntax validator not found at $python_syntax_validator."
fi

for installer in scripts/install-workspace.ps1 scripts/install-workspace.sh; do
  if [ ! -f "$installer" ]; then
    add_result FAIL "Installer missing: $installer"
    continue
  fi
  if ! grep -q "workspace-manifest.json" "$installer"; then
    add_result FAIL "$installer does not use workspace-manifest.json."
  fi
done
if ! grep -q "SupportsShouldProcess" scripts/install-workspace.ps1 2>/dev/null; then
  add_result FAIL "scripts/install-workspace.ps1 must support PowerShell WhatIf."
fi
if ! grep -q -- "--dry-run" scripts/install-workspace.sh 2>/dev/null; then
  add_result FAIL "scripts/install-workspace.sh must support --dry-run."
fi

if command_exists git; then
  secret_patterns='-----BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY-----|ghp_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}|dapi[a-f0-9]{32}|xox[baprs]-[A-Za-z0-9-]{10,}|sk-[A-Za-z0-9]{20,}'
  while IFS= read -r file; do
    [ -f "$file" ] || continue
    size="$(wc -c < "$file" | tr -d ' ')"
    [ "$size" -gt 1048576 ] && continue
    if grep -Eiq -e "$secret_patterns" "$file"; then
      add_result FAIL "Potential secret pattern found in tracked file: $file"
    fi
  done < <(git ls-files)
fi

while IFS= read -r large_file; do
  add_result WARN "Large file over 5MB: $large_file"
done < <(find . -path ./.git -prune -o -type f -size +5M -print)

echo "Workspace repository healthcheck"
echo "================================"
if [ "$INFO_COUNT" -gt 0 ]; then
  for message in "${INFOS[@]}"; do echo "[INFO] $message"; done
fi
if [ "$WARN_COUNT" -gt 0 ]; then
  for message in "${WARNS[@]}"; do echo "[WARN] $message"; done
fi
if [ "$FAIL_COUNT" -gt 0 ]; then
  for message in "${FAILS[@]}"; do echo "[FAIL] $message"; done
fi
echo
echo "Summary: $INFO_COUNT info, $WARN_COUNT warnings, $FAIL_COUNT failures."

if [ "$FAIL_COUNT" -gt 0 ] || { [ "$STRICT" -eq 1 ] && [ "$WARN_COUNT" -gt 0 ]; }; then
  exit 1
fi

exit 0
