#!/usr/bin/env bash
#
# uninstall.sh — elimina los symlinks creados por install.sh.
# Nunca borra contenido copiado (--copy) ni carpetas que no sean symlinks,
# para no destruir nada que el usuario haya editado a mano.
#
# Uso:
#   ./uninstall.sh            # del proyecto actual
#   ./uninstall.sh --global   # de las rutas globales

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"

MODE="project"
for arg in "$@"; do
  [ "$arg" = "--global" ] && MODE="global"
done

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

for skill_dir in "$SKILLS_SRC"/*/; do
  skill="$(basename "$skill_dir")"
  for target_base in "${TARGETS[@]}"; do
    dest="$target_base/$skill"
    if [ -L "$dest" ]; then
      rm "$dest"
      echo "🗑️  Eliminado symlink: $dest"
    fi
  done
done

echo "✅ Listo."
