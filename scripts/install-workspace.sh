#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
SKIP_SKILLS=0
SKIP_AGENTS=0
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

usage() {
  cat <<'EOF'
Usage: scripts/install-workspace.sh [--dry-run] [--codex-home PATH] [--skip-skills] [--skip-agents]

Copies tracked skills and custom agents into a Codex runtime profile.
It never deletes extra files from the target profile.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run|-n) DRY_RUN=1; shift ;;
    --codex-home)
      CODEX_HOME="$2"
      shift 2
      ;;
    --skip-skills) SKIP_SKILLS=1; shift ;;
    --skip-agents) SKIP_AGENTS=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SOURCE="$REPO_ROOT/skills"
AGENTS_SOURCE="$REPO_ROOT/.codex/agents"
SKILLS_TARGET="$CODEX_HOME/skills"
AGENTS_TARGET="$CODEX_HOME/agents"

run_or_echo() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run] %q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

copy_dir_contents() {
  local source="$1"
  local target="$2"
  run_or_echo mkdir -p "$target"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] copy contents from $source to $target"
  else
    cp -R "$source"/. "$target"/
  fi
}

copy_file() {
  local source="$1"
  local target="$2"
  run_or_echo mkdir -p "$(dirname "$target")"
  run_or_echo cp "$source" "$target"
}

[[ -d "$SKILLS_SOURCE" ]] || { echo "Missing source directory: $SKILLS_SOURCE" >&2; exit 1; }
[[ -d "$AGENTS_SOURCE" ]] || { echo "Missing source directory: $AGENTS_SOURCE" >&2; exit 1; }

echo "Workspace install"
echo "================="
echo "Repo root : $REPO_ROOT"
echo "Codex home: $CODEX_HOME"

if [[ "$SKIP_SKILLS" -eq 0 ]]; then
  skill_count=0
  while IFS= read -r skill_dir; do
    skill_name="$(basename "$skill_dir")"
    copy_dir_contents "$skill_dir" "$SKILLS_TARGET/$skill_name"
    skill_count=$((skill_count + 1))
  done < <(find "$SKILLS_SOURCE" -mindepth 1 -maxdepth 1 -type d | sort)
  echo "Skills planned/copied: $skill_count"
else
  echo "Skills skipped."
fi

if [[ "$SKIP_AGENTS" -eq 0 ]]; then
  agent_count=0
  while IFS= read -r agent_file; do
    copy_file "$agent_file" "$AGENTS_TARGET/$(basename "$agent_file")"
    agent_count=$((agent_count + 1))
  done < <(find "$AGENTS_SOURCE" -maxdepth 1 -name '*.toml' -type f | sort)
  echo "Agents planned/copied: $agent_count"
else
  echo "Agents skipped."
fi

echo
echo "Recommended validation:"
echo "  scripts/healthcheck.sh"
echo
echo "Safe preview:"
echo "  scripts/install-workspace.sh --dry-run"
