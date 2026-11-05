#!/usr/bin/env bash
#
# uninstall.sh — removes the symlinks created by install.sh (skills + agents).
# Agent links point at adapters/<host>/agents/; removing by agent name is enough.
# Never deletes copied content (--copy) or folders that are not symlinks,
# so nothing the user edited by hand is destroyed.
#
# Usage:
#   ./uninstall.sh            # from the current project
#   ./uninstall.sh --global   # from the global paths
#   ./uninstall.sh --tool claude
#   ./uninstall.sh --skills-only
#   ./uninstall.sh --agents-only

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SRC="$REPO_DIR/agents"

MODE="project"
TOOL="all"
INSTALL_GROUPS=("skills" "agents")

while [ $# -gt 0 ]; do
  case "$1" in
    --global) MODE="global" ;;
    --tool)
      shift
      [ $# -gt 0 ] || { echo "❌ --tool requires a value: opencode|claude|codex|generic|all" >&2; exit 2; }
      TOOL="$1"
      ;;
    --tool=*) TOOL="${1#*=}" ;;
    --skills-only) INSTALL_GROUPS=("skills") ;;
    --agents-only) INSTALL_GROUPS=("agents") ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
  esac
  shift
done

case "$TOOL" in
  opencode|claude|codex|generic|all) ;;
  *) echo "❌ Unknown --tool '$TOOL' (use opencode|claude|codex|generic|all)" >&2; exit 2 ;;
esac

if [ "$TOOL" = "all" ]; then
  HOSTS=(opencode claude codex generic)
else
  HOSTS=("$TOOL")
fi

set_targets_for_host() {
  local host="$1"
  if [ "$MODE" = "global" ]; then
    case "$host" in
      opencode) CURRENT_SKILL_TARGETS=("$HOME/.config/opencode/skills"); CURRENT_AGENT_TARGETS=("$HOME/.config/opencode/agents") ;;
      claude) CURRENT_SKILL_TARGETS=("$HOME/.claude/skills"); CURRENT_AGENT_TARGETS=("$HOME/.claude/agents") ;;
      codex) CURRENT_SKILL_TARGETS=("$HOME/.codex/skills"); CURRENT_AGENT_TARGETS=("$HOME/.codex/agents") ;;
      generic) CURRENT_SKILL_TARGETS=("$HOME/.agents/skills" "$HOME/.cursor/skills"); CURRENT_AGENT_TARGETS=("$HOME/.agents/agents" "$HOME/.cursor/agents") ;;
    esac
  else
    local target_dir
    target_dir="$(pwd)"
    case "$host" in
      opencode) CURRENT_SKILL_TARGETS=("$target_dir/.opencode/skills"); CURRENT_AGENT_TARGETS=("$target_dir/.opencode/agents") ;;
      claude) CURRENT_SKILL_TARGETS=("$target_dir/.claude/skills"); CURRENT_AGENT_TARGETS=("$target_dir/.claude/agents") ;;
      codex) CURRENT_SKILL_TARGETS=("$target_dir/.codex/skills"); CURRENT_AGENT_TARGETS=("$target_dir/.codex/agents") ;;
      generic) CURRENT_SKILL_TARGETS=("$target_dir/.agents/skills" "$target_dir/.cursor/skills" "$target_dir/.github/skills"); CURRENT_AGENT_TARGETS=("$target_dir/.agents/agents" "$target_dir/.cursor/agents" "$target_dir/.github/agents") ;;
    esac
  fi
}

for host in "${HOSTS[@]}"; do
  set_targets_for_host "$host"

  if [[ " ${INSTALL_GROUPS[*]} " == *"skills"* ]]; then
    for skill_dir in "$SKILLS_SRC"/*/; do
      [ -d "$skill_dir" ] || continue
      skill="$(basename "$skill_dir")"
      for target_base in "${CURRENT_SKILL_TARGETS[@]}"; do
        dest="$target_base/$skill"
        if [ -L "$dest" ]; then
          rm "$dest"
          echo "🗑️  Removed symlink: $dest"
        fi
      done
    done
  fi

  if [[ " ${INSTALL_GROUPS[*]} " == *"agents"* ]] && [ -d "$AGENTS_SRC" ]; then
    for agent_file in "$AGENTS_SRC"/*.md; do
      [ -e "$agent_file" ] || continue
      agent="$(basename "$agent_file" .md)"
      for target_base in "${CURRENT_AGENT_TARGETS[@]}"; do
        dest="$target_base/$agent.md"
        if [ -L "$dest" ]; then
          rm "$dest"
          echo "🗑️  Removed symlink: $dest"
        fi
      done
    done
  fi
done

echo "✅ Done."
