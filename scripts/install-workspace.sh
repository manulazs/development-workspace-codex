#!/usr/bin/env bash
set -eu

DRY_RUN=0
SKIP_SKILLS=0
SKIP_AGENTS=0
LIST_PROFILES=0
PROFILE="minimal"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

usage() {
  cat <<'EOF'
Usage: scripts/install-workspace.sh [options]

Options:
  --profile NAME       Adoption profile to install. Defaults to minimal.
  --list-profiles      List reusable adoption profiles and exit.
  --dry-run, -n        Show actions without copying files.
  --codex-home PATH    Target Codex home. Defaults to $CODEX_HOME or ~/.codex.
  --skip-skills        Do not copy profile skills.
  --skip-agents        Do not copy profile agents.
  -h, --help           Show this help.

This installer copies only the selected adoption profile. It never deletes files
from the target runtime and it does not compare the repo with local ~/.codex
state.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --profile)
      [ "$#" -ge 2 ] && [ -n "$2" ] || { echo "--profile requires a value." >&2; exit 1; }
      PROFILE="$2"
      shift 2
      ;;
    --list-profiles)
      LIST_PROFILES=1
      shift
      ;;
    --dry-run|-n)
      DRY_RUN=1
      shift
      ;;
    --codex-home)
      [ "$#" -ge 2 ] && [ -n "$2" ] || { echo "--codex-home requires a value." >&2; exit 1; }
      CODEX_HOME="$2"
      shift 2
      ;;
    --skip-skills)
      SKIP_SKILLS=1
      shift
      ;;
    --skip-agents)
      SKIP_AGENTS=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="$REPO_ROOT/workspace-manifest.json"
SKILLS_SOURCE="$REPO_ROOT/skills"
AGENTS_SOURCE="$REPO_ROOT/.codex/agents"
SKILLS_TARGET="$CODEX_HOME/skills"
AGENTS_TARGET="$CODEX_HOME/agents"

find_python() {
  for candidate in python3 python; do
    if command -v "$candidate" >/dev/null 2>&1; then
      if "$candidate" -c 'import sys; raise SystemExit(0 if sys.version_info[0] >= 3 else 1)' >/dev/null 2>&1; then
        echo "$candidate"
        return
      fi
    fi
  done
  echo ""
}

PYTHON_BIN="$(find_python)"
if [ -z "$PYTHON_BIN" ]; then
  echo "Python 3 is required to read workspace-manifest.json." >&2
  exit 1
fi

run_or_echo() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run]'
    for arg in "$@"; do
      printf ' %s' "$arg"
    done
    printf '\n'
  else
    "$@"
  fi
}

copy_dir_contents() {
  source="$1"
  target="$2"
  run_or_echo mkdir -p "$target"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] copy contents from $source to $target"
  else
    cp -R "$source"/. "$target"/
  fi
}

copy_file() {
  source="$1"
  target="$2"
  target_dir="$(dirname "$target")"
  run_or_echo mkdir -p "$target_dir"
  run_or_echo cp "$source" "$target"
}

list_profiles() {
  "$PYTHON_BIN" - "$MANIFEST" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    manifest = json.load(handle)

for name, profile in manifest.get("profiles", {}).items():
    print(f"{name}\t{profile.get('description', '')}")
PY
}

emit_profile_selection() {
  "$PYTHON_BIN" - "$MANIFEST" "$PROFILE" <<'PY'
import json
import sys

manifest_path = sys.argv[1]
profile_name = sys.argv[2]
blocked = {"curated", "review", "deprecated", "archived"}

with open(manifest_path, encoding="utf-8") as handle:
    manifest = json.load(handle)

profiles = manifest.get("profiles", {})
skills = manifest.get("skills", {})
agents = manifest.get("agents", {})

def add_unique(target, value):
    if value and value not in target:
        target.append(value)

def validate(kind, name):
    collection = skills if kind == "skill" else agents
    if name not in collection:
        raise SystemExit(f"Profile '{profile_name}' references unknown {kind}: {name}")
    status = collection[name]
    if status in blocked:
        raise SystemExit(
            f"Profile '{profile_name}' references {kind} '{name}' with non-installable status '{status}'."
        )

def resolve(name, seen=None):
    seen = set() if seen is None else set(seen)
    if name in seen:
        raise SystemExit(f"Profile cycle detected at '{name}'.")
    if name not in profiles:
        raise SystemExit(f"Unknown profile '{name}'. Use --list-profiles to inspect options.")

    seen.add(name)
    profile = profiles[name]
    result_skills = []
    result_agents = []

    for parent in profile.get("extends", []):
        parent_skills, parent_agents = resolve(parent, seen)
        for skill in parent_skills:
            add_unique(result_skills, skill)
        for agent in parent_agents:
            add_unique(result_agents, agent)

    for skill in profile.get("skills", []):
        validate("skill", skill)
        add_unique(result_skills, skill)
    for agent in profile.get("agents", []):
        validate("agent", agent)
        add_unique(result_agents, agent)

    return result_skills, result_agents

selected_skills, selected_agents = resolve(profile_name)
for item in selected_skills:
    print(f"skill\t{item}")
for item in selected_agents:
    print(f"agent\t{item}")
PY
}

[ -f "$MANIFEST" ] || { echo "Missing manifest: $MANIFEST" >&2; exit 1; }
[ -d "$SKILLS_SOURCE" ] || { echo "Missing source directory: $SKILLS_SOURCE" >&2; exit 1; }
[ -d "$AGENTS_SOURCE" ] || { echo "Missing source directory: $AGENTS_SOURCE" >&2; exit 1; }

if [ "$LIST_PROFILES" -eq 1 ]; then
  echo "Available adoption profiles"
  echo "==========================="
  list_profiles | while IFS="$(printf '\t')" read -r profile_name description; do
    echo "$profile_name: $description"
  done
  exit 0
fi

echo "Workspace install preview/execution"
echo "==================================="
echo "Repo root : $REPO_ROOT"
echo "Codex home: $CODEX_HOME"
echo "Profile   : $PROFILE"
echo
echo "This repository is a portable template. It does not verify or require any existing local Codex runtime state."
echo "codex-global/AGENTS.md is a source template; adapt it before copying into a consumer runtime."
echo

skill_count=0
agent_count=0

while IFS="$(printf '\t')" read -r kind name; do
  if [ "$kind" = "skill" ]; then
    if [ "$SKIP_SKILLS" -eq 0 ]; then
      source="$SKILLS_SOURCE/$name"
      target="$SKILLS_TARGET/$name"
      [ -d "$source" ] || { echo "Profile '$PROFILE' selected missing skill directory: $name" >&2; exit 1; }
      copy_dir_contents "$source" "$target"
    fi
    skill_count=$((skill_count + 1))
  elif [ "$kind" = "agent" ]; then
    if [ "$SKIP_AGENTS" -eq 0 ]; then
      source="$AGENTS_SOURCE/$name.toml"
      target="$AGENTS_TARGET/$name.toml"
      [ -f "$source" ] || { echo "Profile '$PROFILE' selected missing agent file: $name" >&2; exit 1; }
      copy_file "$source" "$target"
    fi
    agent_count=$((agent_count + 1))
  fi
done < <(emit_profile_selection)

if [ "$SKIP_SKILLS" -eq 1 ]; then
  echo "Skills skipped."
else
  echo "Skills planned/copied: $skill_count"
fi

if [ "$SKIP_AGENTS" -eq 1 ]; then
  echo "Agents skipped."
else
  echo "Agents planned/copied: $agent_count"
fi

echo
echo "Repository validation:"
echo "  scripts/healthcheck.sh"
echo
echo "Safe preview examples:"
echo "  scripts/install-workspace.sh --profile governed-codex --dry-run"
echo "  scripts/install-workspace.sh --list-profiles"
