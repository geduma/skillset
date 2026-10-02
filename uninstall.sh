#!/usr/bin/env bash
#
# uninstall.sh — removes the symlinks created by install.sh (skills + agents).
# Never deletes copied content (--copy) or folders that are not symlinks,
# so nothing the user edited by hand is destroyed.
#
# Usage:
#   ./uninstall.sh            # from the current project
#   ./uninstall.sh --global   # from the global paths
#   ./uninstall.sh --skills-only
#   ./uninstall.sh --agents-only

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SRC="$REPO_DIR/agents"

MODE="project"
INSTALL_GROUPS=("skills" "agents")
for arg in "$@"; do
  [ "$arg" = "--global" ] && MODE="global"
  [ "$arg" = "--skills-only" ] && INSTALL_GROUPS=("skills")
  [ "$arg" = "--agents-only" ] && INSTALL_GROUPS=("agents")
done

if [ "$MODE" = "global" ]; then
  SKILL_TARGETS=(
    "$HOME/.claude/skills"
    "$HOME/.codex/skills"
    "$HOME/.config/opencode/skills"
    "$HOME/.agents/skills"
    "$HOME/.cursor/skills"
  )
  AGENT_TARGETS=(
    "$HOME/.claude/agents"
    "$HOME/.codex/agents"
    "$HOME/.config/opencode/agents"
    "$HOME/.agents/agents"
    "$HOME/.cursor/agents"
  )
else
  TARGET_DIR="$(pwd)"
  SKILL_TARGETS=(
    "$TARGET_DIR/.claude/skills"
    "$TARGET_DIR/.codex/skills"
    "$TARGET_DIR/.opencode/skills"
    "$TARGET_DIR/.agents/skills"
    "$TARGET_DIR/.cursor/skills"
    "$TARGET_DIR/.github/skills"
  )
  AGENT_TARGETS=(
    "$TARGET_DIR/.claude/agents"
    "$TARGET_DIR/.codex/agents"
    "$TARGET_DIR/.opencode/agents"
    "$TARGET_DIR/.agents/agents"
    "$TARGET_DIR/.cursor/agents"
    "$TARGET_DIR/.github/agents"
  )
fi

if [[ " ${INSTALL_GROUPS[*]} " == *"skills"* ]]; then
for skill_dir in "$SKILLS_SRC"/*/; do
  [ -d "$skill_dir" ] || continue
  skill="$(basename "$skill_dir")"
  for target_base in "${SKILL_TARGETS[@]}"; do
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
  for target_base in "${AGENT_TARGETS[@]}"; do
    dest="$target_base/$agent.md"
    if [ -L "$dest" ]; then
      rm "$dest"
      echo "🗑️  Removed symlink: $dest"
    fi
  done
done
fi

echo "✅ Done."
