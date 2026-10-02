#!/usr/bin/env bash
#
# install.sh — links this repo's skills and agents to the paths searched by
# Claude Code, Codex CLI, OpenCode, Cursor, and VSCode/Copilot.
#
# Usage:
#   ./install.sh                 # install into the current project (local repo)
#   ./install.sh --global        # install globally (~/.claude, ~/.codex, etc.)
#   ./install.sh --copy          # copy instead of symlink (useful on Windows/WSL with symlink issues)
#   ./install.sh --prune         # also remove LEGOS symlinks whose source no longer exists (opt-in)
#   ./install.sh --copy --force  # in --copy mode, replace real files/dirs with fresh copies (explicit, may overwrite manual edits)
#   ./install.sh --skills-only   # skills only
#   ./install.sh --agents-only   # agents only
#   ./install.sh skillset-legal-license  # install just that item (skill or agent)
#
# Philosophy: skills/ and agents/ in this repo are the SINGLE source of truth.
# This script only creates links to them — never duplicate content by hand.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SRC="$REPO_DIR/agents"

MODE="project"
LINK_MODE="symlink"
PRUNE=0
FORCE=0
INSTALL_GROUPS=()
SELECTED_ITEMS=()

for arg in "$@"; do
  case "$arg" in
    --global) MODE="global" ;;
    --copy) LINK_MODE="copy" ;;
    --prune) PRUNE=1 ;;
    --force) FORCE=1 ;;
    --skills-only) INSTALL_GROUPS=("skills") ;;
    --agents-only) INSTALL_GROUPS=("agents") ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) SELECTED_ITEMS+=("$arg") ;;
  esac
done

if [ ${#INSTALL_GROUPS[@]} -eq 0 ]; then
  INSTALL_GROUPS=("skills" "agents")
fi

if [ ${#SELECTED_ITEMS[@]} -eq 0 ]; then
  SELECTED_ITEMS=()
  if [[ " ${INSTALL_GROUPS[*]} " == *"skills"* ]]; then
    for d in "$SKILLS_SRC"/*/; do
      [ -d "$d" ] && SELECTED_ITEMS+=("$(basename "$d")")
    done
  fi
  if [[ " ${INSTALL_GROUPS[*]} " == *"agents"* ]] && [ -d "$AGENTS_SRC" ]; then
    for f in "$AGENTS_SRC"/*.md; do
      [ -e "$f" ] || continue
      SELECTED_ITEMS+=("$(basename "$f" .md)")
    done
  fi
fi

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

link_item() {
  local src="$1"
  local is_dir="$2"
  shift 2
  local targets=("$@")
  local name
  name="$(basename "$src")"
  if [ "$is_dir" = "file" ]; then
    name="$(basename "$src" .md)"
  fi
  for target_base in "${targets[@]}"; do
    mkdir -p "$target_base"
    local dest="$target_base/$name"
    if [ "$is_dir" = "file" ]; then
      dest="$target_base/$name.md"
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
      if [ -L "$dest" ]; then
        rm "$dest"
      elif [ "$FORCE" = "1" ]; then
        echo "⚠️  $dest exists as real file/dir. --force: removing and replacing (may overwrite manual edits)."
        rm -rf "$dest"
      else
        echo "⚠️  $dest already exists and is NOT a symlink managed by this script. Skipping to avoid overwriting manual content."
        continue
      fi
    fi

    if [ "$LINK_MODE" = "symlink" ]; then
      ln -s "$src" "$dest"
      echo "🔗 $dest -> $src"
    else
      if [ -d "$src" ]; then
        cp -r "$src" "$dest"
      else
        cp "$src" "$dest"
      fi
      echo "📄 Copied to $dest"
    fi
  done
}

echo "📦 Installing from: $SKILLS_SRC + $AGENTS_SRC"
echo "🎯 Mode: $MODE ($LINK_MODE) [${INSTALL_GROUPS[*]}] prune=$PRUNE force=$FORCE"
echo ""

prune_stale_links() {
  for target_base in "$@"; do
    [ -d "$target_base" ] || continue
    for dest in "$target_base"/*; do
      [ -e "$dest" ] || [ -L "$dest" ] || continue
      [ -L "$dest" ] || continue
      link="$(readlink "$dest")"
      case "$link" in
        "$REPO_DIR/skills/"*|"$REPO_DIR/agents/"*)
          if [ ! -e "$dest" ]; then
            rm "$dest"
            echo "🗑️  Pruned stale link: $dest -> $link"
          fi
          ;;
      esac
    done
  done
}

for item in "${SELECTED_ITEMS[@]}"; do
  if [ -d "$SKILLS_SRC/$item" ]; then
    link_item "$SKILLS_SRC/$item" dir "${SKILL_TARGETS[@]}"
  elif [ -f "$AGENTS_SRC/$item.md" ]; then
    link_item "$AGENTS_SRC/$item.md" file "${AGENT_TARGETS[@]}"
  else
    echo "⚠️  Item '$item' not found in $SKILLS_SRC or $AGENTS_SRC, skipping."
    continue
  fi
done

echo ""
if [ "$PRUNE" = "1" ]; then
  echo "🧹 Pruning stale LEGOS links..."
  prune_stale_links "${SKILL_TARGETS[@]}" "${AGENT_TARGETS[@]}"
  echo ""
fi
echo "✅ Done. Always edit content in skills/<name>/ and agents/<name>.md — links update automatically."
