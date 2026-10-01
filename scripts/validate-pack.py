#!/usr/bin/env python3
"""validate-pack.py — pack-level harness gates for the skillset repo.

Checks every skill under skills/:
  - frontmatter keys (name, description, license, allowed-tools, metadata.version)
  - name follows skillset-<domain>-<topic> and matches folder
  - description length / forbidden chars
  - SKILL.md token budgets (<=100 lines / <=1500 words body)
  - references budgets (<=200 lines / <=2000 words each)
  - evals/trigger-tests.md present with >=5 should-trigger and >=3 should-NOT-trigger
  - routing pointer to docs/ROUTING.md
  - metadata.version matches VERSION file and is semver

Exit 0 when clean, 1 with error list otherwise. Warnings do not fail.
Usage: python3 scripts/validate-pack.py [--strict]
"""
import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("FAIL: pyyaml required (pip install pyyaml)")

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ROOT / "skills"
VERSION_FILE = ROOT / "VERSION"
ALLOWED_KEYS = {"name", "description", "license", "allowed-tools", "metadata", "compatibility"}
ALLOWED_DOMAINS = {"sec", "design", "dev", "git", "docs", "ops", "legal", "seo"}
LEGACY = {"skillset-creator"}
SEMVER = re.compile(r"^\d+\.\d+\.\d+$")

errors: list[str] = []
warnings: list[str] = []

pack_version = VERSION_FILE.read_text().strip() if VERSION_FILE.exists() else None
if not pack_version or not SEMVER.match(pack_version):
    errors.append(f"VERSION file missing or not semver: {pack_version!r}")

for skill_dir in sorted(p for p in SKILLS.iterdir() if p.is_dir()):
    name = skill_dir.name
    md = skill_dir / "SKILL.md"
    if not md.exists():
        errors.append(f"{name}: missing SKILL.md")
        continue
    text = md.read_text()
    m = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
    if not m:
        errors.append(f"{name}: invalid/missing frontmatter")
        continue
    try:
        fm = yaml.safe_load(m.group(1))
    except Exception as e:  # noqa: BLE001
        errors.append(f"{name}: frontmatter YAML error: {e}")
        continue
    if not isinstance(fm, dict):
        errors.append(f"{name}: frontmatter must be a mapping")
        continue
    unexpected = set(fm.keys()) - ALLOWED_KEYS
    if unexpected:
        errors.append(f"{name}: unexpected frontmatter keys: {sorted(unexpected)}")
    for field in ("name", "description"):
        if field not in fm:
            errors.append(f"{name}: frontmatter missing '{field}'")
    fname = str(fm.get("name", "")).strip()
    if fname != name:
        errors.append(f"{name}: frontmatter name {fname!r} != folder name")
    mm = re.match(r"^skillset-([a-z0-9]+)-([a-z0-9]+(?:-[a-z0-9]+)*)$", fname)
    if fname in LEGACY:
        pass
    elif not mm:
        errors.append(f"{name}: name must follow skillset-<domain>-<topic>")
    elif mm.group(1) not in ALLOWED_DOMAINS:
        errors.append(f"{name}: domain {mm.group(1)!r} not allowed")
    desc = str(fm.get("description", ""))
    if "<" in desc or ">" in desc:
        errors.append(f"{name}: description contains < or >")
    if len(desc.strip()) > 1024:
        errors.append(f"{name}: description > 1024 chars")
    if len(desc.strip()) < 80:
        warnings.append(f"{name}: description very short (<80 chars), trigger may be weak")
    if "license" not in fm:
        errors.append(f"{name}: frontmatter missing 'license'")
    if "allowed-tools" not in fm:
        errors.append(f"{name}: frontmatter missing 'allowed-tools'")
    meta = fm.get("metadata") or {}
    ver = meta.get("version") if isinstance(meta, dict) else None
    if not ver:
        errors.append(f"{name}: frontmatter missing 'metadata.version'")
    elif not SEMVER.match(str(ver)):
        errors.append(f"{name}: metadata.version {ver!r} not semver")
    elif pack_version and str(ver) != pack_version:
        errors.append(f"{name}: metadata.version {ver!r} != pack VERSION {pack_version!r}")

    body = text[m.end():].strip()
    blines = len(body.splitlines())
    bwords = len(body.split())
    if blines > 100:
        errors.append(f"{name}: SKILL.md body {blines} lines (max 100)")
    if bwords > 1500:
        errors.append(f"{name}: SKILL.md body {bwords} words (max 1500)")
    elif blines > 60 or bwords > 800:
        warnings.append(f"{name}: SKILL.md body {blines} lines/{bwords} words (target <=60/~800)")

    ref_dir = skill_dir / "references"
    if ref_dir.is_dir():
        for ref in sorted(ref_dir.rglob("*.md")):
            rl = len(ref.read_text().splitlines())
            rw = len(ref.read_text().split())
            if rl > 200:
                errors.append(f"{name}: references/{ref.name} {rl} lines (max 200)")
            if rw > 2000:
                errors.append(f"{name}: references/{ref.name} {rw} words (max 2000)")

    evals = skill_dir / "evals" / "trigger-tests.md"
    if not evals.exists():
        errors.append(f"{name}: missing evals/trigger-tests.md")
    else:
        et = evals.read_text()
        triggers = len(re.findall(r"(?m)^\s*\d+\.\s+", et.split("should-not-trigger", 1)[0] if "should-not-trigger" in et.lower() else et))
        not_triggers = et.lower().count("should-not-trigger")
        if triggers < 5:
            errors.append(f"{name}: evals need >=5 should-trigger cases (found ~{triggers})")
        if not_triggers < 4:
            errors.append(f"{name}: evals need >=3 should-NOT-trigger cases (found ~{max(0, not_triggers - 2)} cases + headers)")

    if "docs/ROUTING.md" not in body:
        errors.append(f"{name}: SKILL.md missing routing pointer to docs/ROUTING.md")
    nested = [p for p in skill_dir.rglob("SKILL.md") if p != md]
    if nested:
        errors.append(f"{name}: nested SKILL.md not allowed: {nested}")

routing = ROOT / "docs" / "ROUTING.md"
if not routing.exists():
    errors.append("docs/ROUTING.md missing")
strict = "--strict" in sys.argv
for w in warnings:
    print(f"WARN: {w}")
if errors:
    print("\n".join(f"FAIL: {e}" for e in errors))
    sys.exit(1)
if strict and warnings:
    print("FAIL(strict): warnings present")
    sys.exit(1)
print(f"pack valid ({pack_version}), {len(list(SKILLS.iterdir()))} skills")
