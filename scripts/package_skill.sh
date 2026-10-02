#!/usr/bin/env bash
#
# package_skill.sh — validates and packages a skill as .skill (zip) ready
# for upload to claude.ai / Skills API. No dependency on internal
# Anthropic tooling — uses only python3 (with pyyaml) and zip, already
# available if you use Claude Code / Codex / OpenCode.
#
# Usage:
#   ./scripts/package_skill.sh skills/skillset-legal-license
#
# Output: dist/<skill-name>.skill at the repo root.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <path-to-skill-folder>"
  exit 1
fi

SKILL_DIR="$(cd "$1" && pwd)"
SKILL_NAME="$(basename "$SKILL_DIR")"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$REPO_ROOT/dist"

echo "🔍 Validating $SKILL_NAME..."

python3 - "$SKILL_DIR" << 'PYEOF'
import sys, re, yaml
from pathlib import Path

skill_path = Path(sys.argv[1])
skill_md = skill_path / "SKILL.md"

if not skill_md.exists():
    sys.exit("❌ SKILL.md not found")

nested = [p for p in skill_path.rglob("SKILL.md") if p != skill_md]
if nested:
    sys.exit(f"❌ Nested SKILL.md files found, not allowed for web upload: {nested}")

content = skill_md.read_text()
match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
if not match:
    sys.exit("❌ Invalid or missing YAML frontmatter")

fm = yaml.safe_load(match.group(1))
if not isinstance(fm, dict):
    sys.exit("❌ Frontmatter must be a YAML mapping")

allowed = {"name", "description", "license", "allowed-tools", "metadata", "compatibility"}
unexpected = set(fm.keys()) - allowed
if unexpected:
    sys.exit(f"❌ Unexpected frontmatter keys: {unexpected}")

for field in ("name", "description"):
    if field not in fm:
        sys.exit(f"❌ Missing '{field}' in frontmatter")

name = fm["name"].strip()
if not re.match(r'^[a-z0-9-]+$', name) or name.startswith('-') or name.endswith('-') or '--' in name:
    sys.exit(f"❌ 'name' must be kebab-case: {name}")
if len(name) > 64:
    sys.exit("❌ 'name' exceeds 64 characters")
# Collision-safe namespace: skillset-<domain>-<topic>, except the meta-skill.
allowed_domains = {"sec", "design", "dev", "git", "docs", "ops", "legal", "seo"}
m = re.match(r'^skillset-([a-z0-9]+)-([a-z0-9]+(?:-[a-z0-9]+)*)$', name)
legacy_meta = {"skillset-creator"}
if name in legacy_meta:
    print("✅ Meta-skill skillset-creator")
elif not m:
    sys.exit(f"❌ 'name' must follow skillset-<domain>-<topic>: {name}")
elif m.group(1) not in allowed_domains:
    sys.exit(f"❌ Domain '{m.group(1)}' not allowed, use one of: {sorted(allowed_domains)}")

desc = fm["description"].strip()
if '<' in desc or '>' in desc:
    sys.exit("❌ 'description' must not contain < or >")
if len(desc) > 1024:
    sys.exit("❌ 'description' exceeds 1024 characters")

# Token budget: SKILL.md loads fully on every activation — keep it lean,
# push detail to references/ (progressive disclosure, nothing is deleted).
body = content[match.end():].strip()
body_lines = len(body.splitlines())
body_words = len(body.split())
if body_lines > 100:
    sys.exit(f"❌ SKILL.md body has {body_lines} lines (max 100). Move detail to references/ and link it.")
if body_words > 1500:
    sys.exit(f"❌ SKILL.md body has {body_words} words (max 1500). Move detail to references/ and link it.")
elif body_lines > 60 or body_words > 800:
    print(f"⚠️  SKILL.md body at {body_lines} lines / {body_words} words (target ≤60 / ~800). Consider moving more to references/.")

ref_dir = skill_path / "references"
if ref_dir.is_dir():
    for ref in sorted(ref_dir.rglob("*.md")):
        rlines = len(ref.read_text().splitlines())
        rwords = len(ref.read_text().split())
        if rlines > 200:
            sys.exit(f"❌ references/{ref.name} has {rlines} lines (max 200). Split it by topic.")
        if rwords > 2000:
            sys.exit(f"❌ references/{ref.name} has {rwords} words (max 2000). Split it by topic.")

import re as _re
ver = (fm.get("metadata") or {}).get("version") if isinstance(fm.get("metadata"), dict) else None
if not ver:
    print("⚠️  Missing 'metadata.version' — add metadata:\n  version: \"<semver>\" (must match VERSION).")
elif not _re.match(r'^\d+\.\d+\.\d+$', str(ver)):
    sys.exit(f"❌ 'metadata.version' must be semver: {ver}")
if "allowed-tools" not in fm:
    print("⚠️  Missing 'allowed-tools' — declare the minimum tools the skill needs.")
if "license" not in fm:
    print("⚠️  Missing 'license' in frontmatter.")
if not (skill_path / "evals" / "trigger-tests.md").exists():
    print("⚠️  Missing evals/trigger-tests.md (5 should-trigger + 3 should-NOT-trigger; 5+5 with incidentals for high-risk skills).")
if "docs/ROUTING.md" not in body:
    print("⚠️  SKILL.md does not link to docs/ROUTING.md as routing tiebreaker.")

print("✅ Valid skill")
PYEOF

mkdir -p "$DIST_DIR"
OUT_ZIP="$DIST_DIR/${SKILL_NAME}.skill"
rm -f "$OUT_ZIP"

# The zip must contain the skill folder at its root (not its loose contents)
cd "$(dirname "$SKILL_DIR")"
zip -qr "$OUT_ZIP" "$SKILL_NAME" \
  -x "*.DS_Store" -x "*__pycache__*" -x "*/evals/*"

echo "📦 Packaged: $OUT_ZIP"
echo "   Upload it directly in claude.ai → Settings → Capabilities → Skills, or via Skills API."
