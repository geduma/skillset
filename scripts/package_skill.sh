#!/usr/bin/env bash
#
# package_skill.sh — valida y empaqueta una skill como .skill (zip) listo
# para subir a claude.ai / Skills API. No depende de herramientas internas
# de Anthropic — usa solo python3 (con pyyaml) y zip, que ya tienes si usas
# Claude Code / Codex / OpenCode.
#
# Uso:
#   ./scripts/package_skill.sh skills/skillset-legal-license
#
# Salida: dist/<nombre-skill>.skill en la raíz del repo.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Uso: $0 <ruta-a-carpeta-de-skill>"
  exit 1
fi

SKILL_DIR="$(cd "$1" && pwd)"
SKILL_NAME="$(basename "$SKILL_DIR")"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$REPO_ROOT/dist"

echo "🔍 Validando $SKILL_NAME..."

python3 - "$SKILL_DIR" << 'PYEOF'
import sys, re, yaml
from pathlib import Path

skill_path = Path(sys.argv[1])
skill_md = skill_path / "SKILL.md"

if not skill_md.exists():
    sys.exit("❌ No se encontró SKILL.md")

nested = [p for p in skill_path.rglob("SKILL.md") if p != skill_md]
if nested:
    sys.exit(f"❌ Hay SKILL.md anidados, no permitido para subida web: {nested}")

content = skill_md.read_text()
match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
if not match:
    sys.exit("❌ Frontmatter YAML inválido o ausente")

fm = yaml.safe_load(match.group(1))
if not isinstance(fm, dict):
    sys.exit("❌ El frontmatter debe ser un diccionario YAML")

allowed = {"name", "description", "license", "allowed-tools", "metadata", "compatibility"}
unexpected = set(fm.keys()) - allowed
if unexpected:
    sys.exit(f"❌ Claves no permitidas en frontmatter: {unexpected}")

for field in ("name", "description"):
    if field not in fm:
        sys.exit(f"❌ Falta '{field}' en el frontmatter")

name = fm["name"].strip()
if not re.match(r'^[a-z0-9-]+$', name) or name.startswith('-') or name.endswith('-') or '--' in name:
    sys.exit(f"❌ 'name' debe ser kebab-case: {name}")
if len(name) > 64:
    sys.exit("❌ 'name' supera 64 caracteres")
# Collision-safe namespace: skillset-<domain>-<topic>, salvo la meta-skill.
allowed_domains = {"sec", "design", "dev", "git", "docs", "ops", "legal", "seo"}
m = re.match(r'^skillset-([a-z0-9]+)-([a-z0-9]+(?:-[a-z0-9]+)*)$', name)
legacy_meta = {"skillset-creator"}
if name in legacy_meta:
    print("✅ Meta-skill skillset-creator")
elif not m:
    sys.exit(f"❌ 'name' debe seguir skillset-<dominio>-<tema>: {name}")
elif m.group(1) not in allowed_domains:
    sys.exit(f"❌ Dominio no permitido '{m.group(1)}', usa uno de: {sorted(allowed_domains)}")

desc = fm["description"].strip()
if '<' in desc or '>' in desc:
    sys.exit("❌ 'description' no puede contener < o >")
if len(desc) > 1024:
    sys.exit("❌ 'description' supera 1024 caracteres")

# Token budget: SKILL.md loads fully on every activation — keep it lean,
# push detail to references/ (progressive disclosure, nothing is deleted).
body = content[match.end():].strip()
body_lines = len(body.splitlines())
body_words = len(body.split())
if body_lines > 100:
    sys.exit(f"❌ SKILL.md body tiene {body_lines} líneas (máx 100). Mueve detalle a references/ y linkéalo.")
if body_words > 1500:
    sys.exit(f"❌ SKILL.md body tiene {body_words} palabras (máx 1500). Mueve detalle a references/ y linkéalo.")
elif body_lines > 60 or body_words > 800:
    print(f"⚠️  SKILL.md body en {body_lines} líneas / {body_words} palabras (objetivo ≤60 / ~800). Considera mover más a references/.")

ref_dir = skill_path / "references"
if ref_dir.is_dir():
    for ref in sorted(ref_dir.rglob("*.md")):
        rlines = len(ref.read_text().splitlines())
        rwords = len(ref.read_text().split())
        if rlines > 200:
            sys.exit(f"❌ references/{ref.name} tiene {rlines} líneas (máx 200). Divídelo por tema.")
        if rwords > 2000:
            sys.exit(f"❌ references/{ref.name} tiene {rwords} palabras (máx 2000). Divídelo por tema.")

print("✅ Skill válida")
PYEOF

mkdir -p "$DIST_DIR"
OUT_ZIP="$DIST_DIR/${SKILL_NAME}.skill"
rm -f "$OUT_ZIP"

# El zip debe contener la carpeta de la skill en su raíz (no su contenido suelto)
cd "$(dirname "$SKILL_DIR")"
zip -qr "$OUT_ZIP" "$SKILL_NAME" \
  -x "*.DS_Store" -x "*__pycache__*" -x "*/evals/*"

echo "📦 Empaquetado: $OUT_ZIP"
echo "   Súbelo directamente en claude.ai → Settings → Capabilities → Skills, o vía Skills API."
