#!/usr/bin/env bash
#
# install.sh — enlaza las skills de este repo a las rutas que buscan
# Claude Code, Codex CLI, OpenCode, Cursor y VSCode/Copilot.
#
# Uso:
#   ./install.sh                 # instala en el proyecto actual (repo local)
#   ./install.sh --global        # instala globalmente (~/.claude, ~/.codex, etc.)
#   ./install.sh --copy          # copia en vez de symlink (útil en Windows/WSL con problemas de symlinks)
#   ./install.sh license-guardian  # instala solo esa skill (por defecto instala todas)
#
# Filosofía: skills/ en este repo es la ÚNICA fuente de verdad.
# Este script solo crea enlaces hacia ella — nunca dupliques contenido a mano.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"

MODE="project"
LINK_MODE="symlink"
SELECTED_SKILLS=()

for arg in "$@"; do
  case "$arg" in
    --global) MODE="global" ;;
    --copy) LINK_MODE="copy" ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) SELECTED_SKILLS+=("$arg") ;;
  esac
done

if [ ${#SELECTED_SKILLS[@]} -eq 0 ]; then
  mapfile -t SELECTED_SKILLS < <(find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
fi

if [ "$MODE" = "global" ]; then
  TARGETS=(
    "$HOME/.claude/skills"
    "$HOME/.codex/skills"
    "$HOME/.config/opencode/skills"
    "$HOME/.agents/skills"
    "$HOME/.cursor/skills"
  )
else
  TARGET_DIR="$(pwd)"
  TARGETS=(
    "$TARGET_DIR/.claude/skills"
    "$TARGET_DIR/.codex/skills"
    "$TARGET_DIR/.opencode/skills"
    "$TARGET_DIR/.agents/skills"
    "$TARGET_DIR/.cursor/skills"
    "$TARGET_DIR/.github/skills"
  )
fi

echo "📦 Instalando skills de: $SKILLS_SRC"
echo "🎯 Modo: $MODE ($LINK_MODE)"
echo ""

for skill in "${SELECTED_SKILLS[@]}"; do
  SRC="$SKILLS_SRC/$skill"
  if [ ! -d "$SRC" ]; then
    echo "⚠️  Skill '$skill' no encontrada en $SKILLS_SRC, saltando."
    continue
  fi

  for target_base in "${TARGETS[@]}"; do
    mkdir -p "$target_base"
    dest="$target_base/$skill"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
      if [ -L "$dest" ]; then
        rm "$dest"
      else
        echo "⚠️  $dest ya existe y NO es un symlink gestionado por este script. Saltando para no sobrescribir contenido manual."
        continue
      fi
    fi

    if [ "$LINK_MODE" = "symlink" ]; then
      ln -s "$SRC" "$dest"
      echo "🔗 $dest -> $SRC"
    else
      cp -r "$SRC" "$dest"
      echo "📄 Copiado a $dest"
    fi
  done
done

echo ""
echo "✅ Listo. Edita siempre el contenido en skills/<nombre>/ — los enlaces se actualizan solos."
