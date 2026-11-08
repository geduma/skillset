#!/usr/bin/env bash
#
# install.sh — links this repo's skills and host-specific agent adapters to the
# paths searched by Claude Code, Codex CLI, OpenCode, Cursor, and VSCode/Copilot.
#
# Usage:
#   ./install.sh                 # install into the current project (local repo)
#   ./install.sh --global        # install globally (~/.claude, ~/.codex, etc.)
#   ./install.sh --tool claude   # install only one host adapter (opencode|claude|codex|generic|all)
#   ./install.sh --copy          # copy instead of symlink (useful on Windows/WSL with symlink issues)
#   ./install.sh --prune         # also remove LEGOS symlinks whose source no longer exists (opt-in)
#   ./install.sh --copy --force  # in --copy mode, replace real files/dirs with fresh copies (explicit, may overwrite manual edits)
#   ./install.sh --skills-only   # skills only
#   ./install.sh --agents-only   # agents only
#   ./install.sh skillset-legal-license  # install just that item (skill or agent)
#
# Philosophy: skills/ and agents/ in this repo are the SINGLE source of truth.
# agents/ is host-neutral; adapters/<host>/ is generated from it by
# scripts/build-adapters.py. This script only creates links to those files.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SRC="$REPO_DIR/agents"
ADAPTERS_DIR="$REPO_DIR/adapters"

MODE="project"
LINK_MODE="symlink"
TOOL="all"
PRUNE=0
FORCE=0
INSTALL_GROUPS=()
SELECTED_ITEMS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --global) MODE="global" ;;
    --copy) LINK_MODE="copy" ;;
    --tool)
      shift
      [ $# -gt 0 ] || { echo "❌ --tool requires a value: opencode|claude|codex|generic|all" >&2; exit 2; }
      TOOL="$1"
      ;;
    --tool=*) TOOL="${1#*=}" ;;
    --prune) PRUNE=1 ;;
    --force) FORCE=1 ;;
    --skills-only) INSTALL_GROUPS=("skills") ;;
    --agents-only) INSTALL_GROUPS=("agents") ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) SELECTED_ITEMS+=("$1") ;;
  esac
  shift
done

case "$TOOL" in
  opencode|claude|codex|generic|all) ;;
  *) echo "❌ Unknown --tool '$TOOL' (use opencode|claude|codex|generic|all)" >&2; exit 2 ;;
esac

if [ ${#INSTALL_GROUPS[@]} -eq 0 ]; then
  INSTALL_GROUPS=("skills" "agents")
fi

ALL_SKILLS=()
for d in "$SKILLS_SRC"/*/; do
  [ -d "$d" ] && ALL_SKILLS+=("$(basename "$d")")
done

ALL_AGENTS=()
if [ -d "$AGENTS_SRC" ]; then
  for f in "$AGENTS_SRC"/*.md; do
    [ -e "$f" ] || continue
    ALL_AGENTS+=("$(basename "$f" .md)")
  done
fi

SELECTED_SKILLS=()
SELECTED_AGENTS=()
if [ ${#SELECTED_ITEMS[@]} -eq 0 ]; then
  if [[ " ${INSTALL_GROUPS[*]} " == *"skills"* ]]; then
    SELECTED_SKILLS=("${ALL_SKILLS[@]}")
  fi
  if [[ " ${INSTALL_GROUPS[*]} " == *"agents"* ]]; then
    SELECTED_AGENTS=("${ALL_AGENTS[@]}")
  fi
else
  for item in "${SELECTED_ITEMS[@]}"; do
    if [ -d "$SKILLS_SRC/$item" ]; then
      SELECTED_SKILLS+=("$item")
    elif [ -f "$AGENTS_SRC/$item.md" ]; then
      SELECTED_AGENTS+=("$item")
    else
      echo "⚠️  Item '$item' not found in $SKILLS_SRC or $AGENTS_SRC, skipping."
    fi
  done
fi

if [ ${#SELECTED_AGENTS[@]} -gt 0 ] && [ ! -d "$ADAPTERS_DIR" ]; then
  echo "❌ agents/ exists but adapters/ is missing. Run: python3 scripts/build-adapters.py" >&2
  exit 2
fi

if [ "$TOOL" = "all" ]; then
  HOSTS=(opencode claude codex generic)
else
  HOSTS=("$TOOL")
fi

set_targets_for_host() {
  local host="$1"
  if [ "$MODE" = "global" ]; then
    case "$host" in
      opencode)
        CURRENT_SKILL_TARGETS=("$HOME/.config/opencode/skills")
        CURRENT_AGENT_TARGETS=("$HOME/.config/opencode/agents")
        ;;
      claude)
        CURRENT_SKILL_TARGETS=("$HOME/.claude/skills")
        CURRENT_AGENT_TARGETS=("$HOME/.claude/agents")
        ;;
      codex)
        CURRENT_SKILL_TARGETS=("$HOME/.codex/skills")
        CURRENT_AGENT_TARGETS=("$HOME/.codex/agents")
        ;;
      generic)
        CURRENT_SKILL_TARGETS=("$HOME/.agents/skills" "$HOME/.cursor/skills")
        CURRENT_AGENT_TARGETS=("$HOME/.agents/agents" "$HOME/.cursor/agents")
        ;;
    esac
  else
    local target_dir
    target_dir="$(pwd)"
    case "$host" in
      opencode)
        CURRENT_SKILL_TARGETS=("$target_dir/.opencode/skills")
        CURRENT_AGENT_TARGETS=("$target_dir/.opencode/agents")
        ;;
      claude)
        CURRENT_SKILL_TARGETS=("$target_dir/.claude/skills")
        CURRENT_AGENT_TARGETS=("$target_dir/.claude/agents")
        ;;
      codex)
        CURRENT_SKILL_TARGETS=("$target_dir/.codex/skills")
        CURRENT_AGENT_TARGETS=("$target_dir/.codex/agents")
        ;;
      generic)
        CURRENT_SKILL_TARGETS=("$target_dir/.agents/skills" "$target_dir/.cursor/skills" "$target_dir/.github/skills")
        CURRENT_AGENT_TARGETS=("$target_dir/.agents/agents" "$target_dir/.cursor/agents" "$target_dir/.github/agents")
        ;;
    esac
  fi
}

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

prune_stale_links() {
  for target_base in "$@"; do
    [ -d "$target_base" ] || continue
    for dest in "$target_base"/*; do
      [ -e "$dest" ] || [ -L "$dest" ] || continue
      [ -L "$dest" ] || continue
      link="$(readlink "$dest")"
      case "$link" in
        "$REPO_DIR/skills/"*|"$REPO_DIR/adapters/"*)
          if [ ! -e "$dest" ]; then
            rm "$dest"
            echo "🗑️  Pruned stale link: $dest -> $link"
          fi
          ;;
      esac
    done
  done
}

echo "📦 Installing from: $SKILLS_SRC + $ADAPTERS_DIR"
echo "🎯 Mode: $MODE ($LINK_MODE) [${INSTALL_GROUPS[*]}] tool=$TOOL prune=$PRUNE force=$FORCE"
echo ""

for host in "${HOSTS[@]}"; do
  set_targets_for_host "$host"
  echo "🧩 Host: $host"

  if [ ${#SELECTED_SKILLS[@]} -gt 0 ]; then
    for item in "${SELECTED_SKILLS[@]}"; do
      link_item "$SKILLS_SRC/$item" dir "${CURRENT_SKILL_TARGETS[@]}"
    done
  fi

  if [ ${#SELECTED_AGENTS[@]} -gt 0 ]; then
    for item in "${SELECTED_AGENTS[@]}"; do
      adapter="$ADAPTERS_DIR/$host/agents/$item.md"
      if [ ! -f "$adapter" ]; then
        echo "⚠️  Missing adapter for '$item' on host '$host' (expected $adapter). Run scripts/build-adapters.py."
        continue
      fi
      link_item "$adapter" file "${CURRENT_AGENT_TARGETS[@]}"
    done
  fi
  echo ""
done

if [ "$PRUNE" = "1" ]; then
  echo "🧹 Pruning stale LEGOS links..."
  for host in "${HOSTS[@]}"; do
    set_targets_for_host "$host"
    prune_stale_links "${CURRENT_SKILL_TARGETS[@]}" "${CURRENT_AGENT_TARGETS[@]}"
  done
  echo ""
fi
echo "✅ Done. Edit skills/ and agents/, then run scripts/build-adapters.py to refresh adapters/."
