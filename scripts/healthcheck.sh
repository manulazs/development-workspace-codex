#!/usr/bin/env bash
set -u

STRICT=0
for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
    -h|--help)
      cat <<'EOF'
Usage: scripts/healthcheck.sh [--strict]

Validates the Codex workspace repository on macOS/Linux.
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
  local level="$1"
  local message="$2"
  case "$level" in
    INFO) INFOS+=("$message"); INFO_COUNT=$((INFO_COUNT + 1)) ;;
    WARN) WARNS+=("$message"); WARN_COUNT=$((WARN_COUNT + 1)) ;;
    FAIL) FAILS+=("$message"); FAIL_COUNT=$((FAIL_COUNT + 1)) ;;
  esac
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

cd "$REPO_ROOT" || exit 1
add_result INFO "Repository root: $REPO_ROOT"

if ! command_exists git; then
  add_result FAIL "git is not available on PATH."
elif ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  add_result FAIL "Current directory is not a git worktree."
else
  add_result INFO "Git worktree detected."
fi

required_dirs=(
  "skills"
  ".codex/agents"
  "codex-global"
  "docs/decisions"
  "docs/runbooks"
  "docs/operations"
  "docs/audits"
  "docs/lessons"
  "docs/patterns"
  "scripts"
)

for dir in "${required_dirs[@]}"; do
  if [[ -d "$dir" ]]; then
    add_result INFO "Directory exists: $dir"
  else
    add_result FAIL "Required directory missing: $dir"
  fi
done

mapfile -t skill_files < <(find skills -mindepth 2 -maxdepth 2 -name SKILL.md -type f 2>/dev/null | sort)
if [[ "${#skill_files[@]}" -eq 0 ]]; then
  add_result FAIL "No skills with SKILL.md found under skills/."
else
  add_result INFO "Skills discovered: ${#skill_files[@]}"
fi

for skill_file in "${skill_files[@]}"; do
  first_line="$(sed -n '1p' "$skill_file")"
  if [[ "$first_line" != "---" ]]; then
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

mapfile -t agent_files < <(find .codex/agents -maxdepth 1 -name '*.toml' -type f 2>/dev/null | sort)
if [[ "${#agent_files[@]}" -eq 0 ]]; then
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

migrate_cli="skills/migrate-to-codex/scripts/cli.py"
if [[ -f "$migrate_cli" ]] && command_exists python; then
  if python "$migrate_cli" --validate-target . >/tmp/codex-workspace-migrate-validate.log 2>&1; then
    add_result INFO "migrate-to-codex validation passed."
  else
    add_result FAIL "migrate-to-codex validation failed. See /tmp/codex-workspace-migrate-validate.log."
  fi
elif ! command_exists python; then
  add_result WARN "python is not available; skipped migrate-to-codex validation."
else
  add_result WARN "migrate-to-codex validator not found at $migrate_cli."
fi

quick_validate="$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py"
if [[ -f "$quick_validate" ]] && command_exists python; then
  if python -c "import yaml" >/dev/null 2>&1; then
    add_result INFO "PyYAML is available for quick_validate.py."
  else
    add_result WARN "PyYAML is not installed for the active python. quick_validate.py would fail; install PyYAML or use a managed Python environment."
  fi
else
  add_result WARN "System skill quick_validate.py not available; using built-in lightweight skill checks only."
fi

if command_exists git; then
  secret_patterns='-----BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY-----|ghp_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}|dapi[a-f0-9]{32}|xox[baprs]-[A-Za-z0-9-]{10,}|sk-[A-Za-z0-9]{20,}'
  while IFS= read -r file; do
    [[ -f "$file" ]] || continue
    size="$(wc -c < "$file" | tr -d ' ')"
    [[ "$size" -gt 1048576 ]] && continue
    if grep -Eiq "$secret_patterns" "$file"; then
      add_result FAIL "Potential secret pattern found in tracked file: $file"
    fi
  done < <(git ls-files)
fi

while IFS= read -r large_file; do
  add_result WARN "Large file over 5MB: $large_file"
done < <(find . -path ./.git -prune -o -type f -size +5M -print)

if [[ ! -f docs/capability-inventory.md ]]; then
  add_result FAIL "docs/capability-inventory.md is missing."
else
  inventory="$(cat docs/capability-inventory.md)"
  for skill_file in "${skill_files[@]}"; do
    skill_name="$(basename "$(dirname "$skill_file")")"
    if [[ "$inventory" != *"$skill_name"* ]]; then
      add_result WARN "Capability inventory does not mention skill: $skill_name"
    fi
  done
  for agent_file in "${agent_files[@]}"; do
    agent_name="$(basename "$agent_file" .toml)"
    if [[ "$inventory" != *"$agent_name"* ]]; then
      add_result WARN "Capability inventory does not mention agent: $agent_name"
    fi
  done
fi

if [[ -z "${GITHUB_ACTIONS:-}" ]]; then
  codex_skills="$HOME/.codex/skills"
  codex_agents="$HOME/.codex/agents"
  if [[ -d "$codex_skills" ]]; then
    missing_skills=()
    for skill_file in "${skill_files[@]}"; do
      skill_name="$(basename "$(dirname "$skill_file")")"
      [[ -d "$codex_skills/$skill_name" ]] || missing_skills+=("$skill_name")
    done
    if [[ "${#missing_skills[@]}" -gt 0 ]]; then
      add_result WARN "Repo skills not installed in ~/.codex/skills: ${missing_skills[*]}"
    else
      add_result INFO "All repo skills are installed in ~/.codex/skills."
    fi
  else
    add_result WARN "~/.codex/skills does not exist."
  fi

  if [[ -d "$codex_agents" ]]; then
    missing_agents=()
    for agent_file in "${agent_files[@]}"; do
      agent_name="$(basename "$agent_file")"
      [[ -f "$codex_agents/$agent_name" ]] || missing_agents+=("${agent_name%.toml}")
    done
    if [[ "${#missing_agents[@]}" -gt 0 ]]; then
      add_result WARN "Repo agents not installed in ~/.codex/agents: ${missing_agents[*]}"
    else
      add_result INFO "All repo agents are installed in ~/.codex/agents."
    fi
  else
    add_result WARN "~/.codex/agents does not exist."
  fi
fi

echo "Workspace healthcheck"
echo "====================="
for message in "${INFOS[@]}"; do echo "[INFO] $message"; done
for message in "${WARNS[@]}"; do echo "[WARN] $message"; done
for message in "${FAILS[@]}"; do echo "[FAIL] $message"; done
echo
echo "Summary: $INFO_COUNT info, $WARN_COUNT warnings, $FAIL_COUNT failures."

if [[ "$FAIL_COUNT" -gt 0 || ( "$STRICT" -eq 1 && "$WARN_COUNT" -gt 0 ) ]]; then
  exit 1
fi

exit 0
