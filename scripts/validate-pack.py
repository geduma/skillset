#!/usr/bin/env python3
"""validate-pack.py — pack-level harness gates for the skillset repo.

Checks every skill under skills/:
  - frontmatter keys (name, description, license, allowed-tools, metadata.version)
  - name follows skillset-<domain>-<topic> and matches folder
  - description length / forbidden chars
  - SKILL.md token budgets (<=100 lines / <=1500 words body)
  - references budgets (<=200 lines / <=2000 words each)
  - evals/trigger-tests.md present with >=5 should-trigger and >=3 should-NOT-trigger
  - routing pointer to skillset-dev-orchestrator/references/routing.md
  - metadata.version matches VERSION file and is semver

Checks the canonical agents under agents/:
  - host-neutral frontmatter (name, description, role, phase)
  - no host-specific API names (subagent, permissions, `skill` tool, OpenCode)
  - planning-gate text and phase handoff
  - routing pointer to skillset-dev-orchestrator

Checks the generated adapters under adapters/<host>/:
  - one adapter per canonical agent for opencode, claude, codex, generic
  - host-specific frontmatter is valid
  - adapter bodies preserve the planning gate and routing
  - generated files are in sync with scripts/build-adapters.py

Exit 0 when clean, 1 with error list otherwise. Warnings do not fail.
Usage: python3 scripts/validate-pack.py [--strict]
"""
import json
import re
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("FAIL: pyyaml required (pip install pyyaml)")

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ROOT / "skills"
AGENTS = ROOT / "agents"
ADAPTERS = ROOT / "adapters"
VERSION_FILE = ROOT / "VERSION"
ALLOWED_KEYS = {"name", "description", "license", "allowed-tools", "metadata", "compatibility"}
ALLOWED_DOMAINS = {"sec", "design", "dev", "git", "docs", "ops", "legal", "seo"}
LEGACY = {"skillset-creator"}
LEGACY_LONG = {
    "skillset-dev-tdd",
    "skillset-dev-incremental",
    "skillset-dev-code-review",
    "skillset-dev-feature",
}
LEGACY_LONG_REFS = {
    "skillset-dev-backend/references/api-contract.md",
}
HOSTS = ("opencode", "claude", "codex", "generic")
PHASE_AGENTS = ("skillset-spec", "skillset-code", "skillset-verify", "skillset-ship")
CANONICAL_FORBIDDEN = ("subagent", "permissions", "mode: primary", "mode: subagent", "`skill` tool", "OpenCode", "opencode")
SEMVER = re.compile(r"^\d+\.\d+\.\d+$")
FRONTMATTER = re.compile(r"^---\n(.*?)\n---", re.DOTALL)

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
    m = FRONTMATTER.match(text)
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
        if name in LEGACY_LONG:
            warnings.append(f"{name}: SKILL.md body {blines} lines (legacy over 100; split into references)")
        else:
            errors.append(f"{name}: SKILL.md body {blines} lines (max 100)")
    if bwords > 1500:
        if name in LEGACY_LONG:
            warnings.append(f"{name}: SKILL.md body {bwords} words (legacy over 1500; split into references)")
        else:
            errors.append(f"{name}: SKILL.md body {bwords} words (max 1500)")
    elif blines > 60 or bwords > 800:
        warnings.append(f"{name}: SKILL.md body {blines} lines/{bwords} words (target <=60/~800)")

    ref_dir = skill_dir / "references"
    if ref_dir.is_dir():
        for ref in sorted(ref_dir.rglob("*.md")):
            rl = len(ref.read_text().splitlines())
            rw = len(ref.read_text().split())
            ref_key = f"{name}/references/{ref.relative_to(ref_dir).as_posix()}"
            if rl > 200:
                if ref_key in LEGACY_LONG_REFS:
                    warnings.append(f"{name}: references/{ref.name} {rl} lines (legacy over 200; split into smaller files)")
                else:
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

    if "skillset-dev-orchestrator" not in body and "references/routing.md" not in body:
        errors.append(f"{name}: SKILL.md missing routing pointer to skillset-dev-orchestrator/references/routing.md")
    nested = [p for p in skill_dir.rglob("SKILL.md") if p != md]
    if nested:
        errors.append(f"{name}: nested SKILL.md not allowed: {nested}")


def load_frontmatter(path: Path) -> dict | None:
    text = path.read_text()
    match = FRONTMATTER.match(text)
    if not match:
        errors.append(f"{path.relative_to(ROOT)}: invalid/missing frontmatter")
        return None
    try:
        fm = yaml.safe_load(match.group(1))
    except Exception as e:  # noqa: BLE001
        errors.append(f"{path.relative_to(ROOT)}: frontmatter YAML error: {e}")
        return None
    if not isinstance(fm, dict):
        errors.append(f"{path.relative_to(ROOT)}: frontmatter must be a mapping")
        return None
    return fm


def body_of(path: Path) -> str:
    text = path.read_text()
    match = FRONTMATTER.match(text)
    return text[match.end():] if match else ""


def validate_opencode_permissions(agent_name: str, fm: dict) -> None:
    perms = fm.get("permissions")
    if not isinstance(perms, list) or not perms:
        errors.append(f"adapters/opencode/agents/{agent_name}: permissions must be a non-empty list")
        return
    for i, rule in enumerate(perms):
        if not isinstance(rule, dict) or set(rule) != {"action", "resource", "effect"}:
            errors.append(f"adapters/opencode/agents/{agent_name}: permission #{i + 1} must have exactly action/resource/effect")
            continue
        if rule["effect"] not in {"allow", "ask", "deny"}:
            errors.append(f"adapters/opencode/agents/{agent_name}: permission #{i + 1} effect must be allow|ask|deny")
    # OpenCode uses the last matching rule. A broad ask/deny after a specific
    # allow silently cancels that allow (the original subagent/edit bug).
    actions = {r.get("action") for r in perms if isinstance(r, dict)}
    for action in actions:
        rules = [(i, r) for i, r in enumerate(perms) if isinstance(r, dict) and r.get("action") == action]
        for j, specific in rules:
            if specific.get("resource") == "*" or specific.get("effect") != "allow":
                continue
            for i, broad in rules:
                if i > j and broad.get("resource") == "*" and broad.get("effect") in {"ask", "deny"}:
                    errors.append(
                        f"adapters/opencode/agents/{agent_name}: {action} broad {broad['effect']} at #{i + 1} "
                        f"overrides specific allow at #{j + 1}; put broad rules first"
                    )
    if agent_name == "skillset":
        triples = {(r.get("action"), r.get("resource"), r.get("effect")) for r in perms if isinstance(r, dict)}
        for required_rule in (("edit", "*", "deny"), ("edit", "docs/**", "allow"), ("shell", "*", "deny")):
            if required_rule not in triples:
                errors.append(f"adapters/opencode/agents/skillset: missing structural gate rule {required_rule}")


canonical: dict[str, dict] = {}
agent_files = sorted(AGENTS.glob("*.md")) if AGENTS.is_dir() else []
if not agent_files:
    errors.append("agents/ missing or empty")
for agent_md in agent_files:
    agent_name = agent_md.stem
    fm = load_frontmatter(agent_md)
    if fm is None:
        continue
    canonical[agent_name] = fm
    for field in ("name", "description", "role", "phase"):
        if field not in fm:
            errors.append(f"agents/{agent_name}: frontmatter missing '{field}'")
    if fm.get("role") not in {"primary", "phase"}:
        errors.append(f"agents/{agent_name}: role must be primary|phase")
    if str(fm.get("name", "")) != agent_name:
        errors.append(f"agents/{agent_name}: frontmatter name {fm.get('name')!r} != file stem")
    body = body_of(agent_md)
    for required in ("Global rules", "English only", "HOST_ADAPTER", "skillset-dev-orchestrator"):
        if required not in body:
            errors.append(f"agents/{agent_name}: body missing '{required}'")
    for forbidden in CANONICAL_FORBIDDEN:
        if forbidden in body:
            errors.append(f"agents/{agent_name}: body contains host-specific token '{forbidden}'")
    for forbidden in ("skills/*/SKILL.md", "docs/ROUTING.md"):
        if forbidden in body:
            errors.append(f"agents/{agent_name}: body references source-repo path '{forbidden}'")

if "skillset" in canonical:
    body = body_of(AGENTS / "skillset.md")
    delegates = str(canonical["skillset"].get("delegates-to", ""))
    for phase_agent in PHASE_AGENTS:
        if phase_agent not in delegates:
            errors.append(f"agents/skillset: delegates-to missing '{phase_agent}'")
        if phase_agent not in body:
            errors.append(f"agents/skillset: body missing phase agent '{phase_agent}'")
    for required in (
        "Execution gate (hard stop",
        "Approve this plan to start implementation?",
        "do **not** approve execution",
    ):
        if required not in body:
            errors.append(f"agents/skillset: missing planning-gate text '{required}'")
elif agent_files:
    errors.append("agents/skillset.md missing")

if "skillset-spec" in canonical:
    body = body_of(AGENTS / "skillset-spec.md")
    for required in ("Planning gate (hard stop)", "Approve this plan to start implementation?"):
        if required not in body:
            errors.append(f"agents/skillset-spec: missing planning-gate text '{required}'")

if "skillset-code" in canonical:
    body = body_of(AGENTS / "skillset-code.md")
    for required in ("No implementation without an approved plan", "Status: approved"):
        if required not in body:
            errors.append(f"agents/skillset-code: missing approval precondition '{required}'")

for agent_name in canonical:
    if agent_name != "skillset" and "skillset" not in body_of(AGENTS / f"{agent_name}.md"):
        errors.append(f"agents/{agent_name}: body missing escalation target 'skillset'")

# Adapters: one generated file per canonical agent per host.
for host in HOSTS:
    manifest_path = ADAPTERS / host / "manifest.json"
    if not manifest_path.exists():
        errors.append(f"adapters/{host}/manifest.json missing")
        continue
    try:
        manifest = json.loads(manifest_path.read_text())
    except json.JSONDecodeError as e:
        errors.append(f"adapters/{host}/manifest.json invalid JSON: {e}")
        continue
    for agent_name in canonical:
        adapter_path = ADAPTERS / host / "agents" / f"{agent_name}.md"
        if not adapter_path.exists():
            errors.append(f"adapters/{host}/agents/{agent_name}.md missing")
            continue
        fm = load_frontmatter(adapter_path)
        if fm is None:
            continue
        body = body_of(adapter_path)
        if str(fm.get("description", "")) != str(canonical[agent_name].get("description", "")):
            errors.append(f"adapters/{host}/agents/{agent_name}: description differs from canonical")
        if "## Host adapter (" not in body:
            errors.append(f"adapters/{host}/agents/{agent_name}: missing '## Host adapter (' section")
        if "skillset-dev-orchestrator" not in body:
            errors.append(f"adapters/{host}/agents/{agent_name}: missing routing pointer")
        if agent_name in {"skillset", "skillset-spec"} and "Approve this plan to start implementation?" not in body:
            errors.append(f"adapters/{host}/agents/{agent_name}: missing planning-gate question")
        if agent_name == "skillset-code" and "No implementation without an approved plan" not in body:
            errors.append(f"adapters/{host}/agents/skillset-code: missing approval precondition")
        for forbidden in ("skills/*/SKILL.md", "docs/ROUTING.md"):
            if forbidden in body:
                errors.append(f"adapters/{host}/agents/{agent_name}: references source-repo path '{forbidden}'")
        if host == "opencode":
            if fm.get("mode") not in {"primary", "subagent"}:
                errors.append(f"adapters/opencode/agents/{agent_name}: mode must be primary|subagent")
            validate_opencode_permissions(agent_name, fm)
        elif host == "claude":
            if not fm.get("name"):
                errors.append(f"adapters/claude/agents/{agent_name}: missing name")
            if not fm.get("tools"):
                errors.append(f"adapters/claude/agents/{agent_name}: missing tools allowlist")
        else:
            if not fm.get("name"):
                errors.append(f"adapters/{host}/agents/{agent_name}: missing name")

# Adapter drift: the committed files must match scripts/build-adapters.py output.
build_script = ROOT / "scripts" / "build-adapters.py"
if build_script.exists():
    result = subprocess.run(
        [sys.executable, str(build_script), "--check", "--quiet"],
        capture_output=True,
        text=True,
        cwd=ROOT,
    )
    if result.returncode != 0:
        for line in (result.stdout + result.stderr).splitlines():
            if line.strip():
                errors.append(line.replace("FAIL: ", ""))
else:
    errors.append("scripts/build-adapters.py missing")

# Installer must expose the adapter layer.
for script_name in ("install.sh", "uninstall.sh"):
    script = ROOT / script_name
    if not script.exists():
        errors.append(f"{script_name} missing")
        continue
    text = script.read_text()
    for required in ("--tool", "adapters"):
        if required not in text:
            errors.append(f"{script_name}: missing '{required}'")

routing = ROOT / "docs" / "ROUTING.md"
routing_ref = SKILLS / "skillset-dev-orchestrator" / "references" / "routing.md"
if not routing.exists():
    errors.append("docs/ROUTING.md missing")
if not routing_ref.exists():
    errors.append("skills/skillset-dev-orchestrator/references/routing.md missing")
elif routing.exists() and routing.read_text().strip() != routing_ref.read_text().strip():
    errors.append("routing matrix drift: docs/ROUTING.md != skills/skillset-dev-orchestrator/references/routing.md")

strict = "--strict" in sys.argv
for w in warnings:
    print(f"WARN: {w}")
if errors:
    print("\n".join(f"FAIL: {e}" for e in errors))
    sys.exit(1)
if strict and warnings:
    print("FAIL(strict): warnings present")
    sys.exit(1)
print(f"pack valid ({pack_version}), {len(list(SKILLS.iterdir()))} skills, {len(canonical)} canonical agents, {len(HOSTS)} adapters")
