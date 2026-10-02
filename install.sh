#!/usr/bin/env bash
#
# install.sh — enlaza las skills y los agentes de este repo a las rutas que buscan
# Claude Code, Codex CLI, OpenCode, Cursor y VSCode/Copilot.
#
# Uso:
#   ./install.sh                 # instala en el proyecto actual (repo local)
#   ./install.sh --global        # instala globalmente (~/.claude, ~/.codex, etc.)
#   ./install.sh --copy          # copia en vez de symlink (útil en Windows/WSL con problemas de symlinks)
#   ./install.sh --skills-only   # solo skills
#   ./install.sh --agents-only   # solo agentes
#   ./install.sh skillset-legal-license  # instala solo ese item (skill o agente)
#
# Filosofía: skills/ y agents/ en este repo son la ÚNICA fuente de verdad.
# Este script solo crea enlaces hacia ellas — nunca dupliques contenido a mano.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SRC="$REPO_DIR/agents"

MODE="project"
LINK_MODE="symlink"
INSTALL_GROUPS=()
SELECTED_ITEMS=()

for arg in "$@"; do
  case "$arg" in
    --global) MODE="global" ;;
    --copy) LINK_MODE="copy" ;;
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
      else
        echo "⚠️  $dest ya existe y NO es un symlink gestionado por este script. Saltando para no sobrescribir contenido manual."
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
      echo "📄 Copiado a $dest"
    fi
  done
}

echo "📦 Instalando de: $SKILLS_SRC + $AGENTS_SRC"
echo "🎯 Modo: $MODE ($LINK_MODE) [${INSTALL_GROUPS[*]}]"
echo ""

for item in "${SELECTED_ITEMS[@]}"; do
  if [ -d "$SKILLS_SRC/$item" ]; then
    link_item "$SKILLS_SRC/$item" dir "${SKILL_TARGETS[@]}"
  elif [ -f "$AGENTS_SRC/$item.md" ]; then
    link_item "$AGENTS_SRC/$item.md" file "${AGENT_TARGETS[@]}"
  else
    echo "⚠️  Item '$item' no encontrado en $SKILLS_SRC ni en $AGENTS_SRC, saltando."
    continue
  fi
done

echo ""
echo "✅ Listo. Edita siempre el contenido en skills/<nombre>/ y agents/<nombre>.md — los enlaces se actualizan solos."
