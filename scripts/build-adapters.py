#!/usr/bin/env python3
"""build-adapters.py — generate host-specific agent adapters from canonical agents.

The files under agents/ are the tool-agnostic source of truth. Each host needs
its own frontmatter and its own wording for skill loading and delegation, so
this script combines:

  agents/<name>.md                     (canonical frontmatter + body)
  adapters/<host>/manifest.json        (host frontmatter + adapter note)

and writes:

  adapters/<host>/agents/<name>.md

Usage:
  python3 scripts/build-adapters.py            # write adapters
  python3 scripts/build-adapters.py --check    # fail on drift, write nothing
  python3 scripts/build-adapters.py --quiet    # suppress success output
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("FAIL: pyyaml required (pip install pyyaml)")

ROOT = Path(__file__).resolve().parent.parent
AGENTS = ROOT / "agents"
ADAPTERS = ROOT / "adapters"
HOSTS = ("opencode", "claude", "codex", "generic")
PLACEHOLDER = "<!-- HOST_ADAPTER -->"
FRONTMATTER = re.compile(r"^---\n(.*?)\n---\n?", re.DOTALL)


def load_canonical(path: Path) -> tuple[dict, str]:
    text = path.read_text()
    match = FRONTMATTER.match(text)
    if not match:
        raise ValueError(f"{path}: missing frontmatter")
    fm = yaml.safe_load(match.group(1))
    if not isinstance(fm, dict):
        raise ValueError(f"{path}: frontmatter must be a mapping")
    return fm, text[match.end():]


def ordered_frontmatter(host: str, canonical: dict, host_fields: dict) -> dict:
    """Return frontmatter in the order each host expects."""
    description = canonical.get("description", "")
    if host == "opencode":
        out = {"description": description}
        out.update(host_fields)
        return out
    if host == "claude":
        out = {"name": host_fields.get("name", canonical.get("name")), "description": description}
        out.update({k: v for k, v in host_fields.items() if k != "name"})
        return out
    out = {"name": host_fields.get("name", canonical.get("name")), "description": description}
    out.update({k: v for k, v in host_fields.items() if k != "name"})
    return out


def render(host: str, manifest: dict, canonical: dict, body: str) -> str:
    name = str(canonical.get("name", "")).strip()
    host_fields = (manifest.get("frontmatter") or {}).get(name)
    if not isinstance(host_fields, dict):
        raise ValueError(f"adapters/{host}/manifest.json: missing frontmatter for '{name}'")
    note = str(manifest.get("note", "")).strip()
    fm = ordered_frontmatter(host, canonical, host_fields)
    frontmatter = yaml.safe_dump(fm, sort_keys=False, allow_unicode=True, width=1000).strip()
    if PLACEHOLDER in body:
        body = body.replace(PLACEHOLDER, note)
    else:
        body = body.rstrip() + "\n\n" + note
    return f"---\n{frontmatter}\n---\n\n{body.strip()}\n"


def main() -> int:
    check = "--check" in sys.argv
    quiet = "--quiet" in sys.argv
    failures: list[str] = []
    generated: list[tuple[Path, str]] = []

    for host in HOSTS:
        manifest_path = ADAPTERS / host / "manifest.json"
        if not manifest_path.exists():
            failures.append(f"missing adapter manifest: {manifest_path.relative_to(ROOT)}")
            continue
        manifest = json.loads(manifest_path.read_text())
        for agent_path in sorted(AGENTS.glob("*.md")):
            canonical, body = load_canonical(agent_path)
            name = str(canonical.get("name", "")).strip()
            if not name:
                failures.append(f"{agent_path.relative_to(ROOT)}: missing name")
                continue
            try:
                text = render(host, manifest, canonical, body)
            except ValueError as exc:
                failures.append(str(exc))
                continue
            target = ADAPTERS / host / "agents" / f"{name}.md"
            generated.append((target, text))

    if check:
        for target, text in generated:
            if not target.exists():
                failures.append(f"missing generated adapter: {target.relative_to(ROOT)}")
            elif target.read_text() != text:
                failures.append(f"adapter drift: {target.relative_to(ROOT)} (run scripts/build-adapters.py)")
    else:
        for target, text in generated:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(text)

    if failures:
        for failure in failures:
            print(f"FAIL: {failure}")
        return 1
    if not quiet:
        action = "checked" if check else "generated"
        print(f"adapters {action}: {len(generated)} files across {len(HOSTS)} hosts")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
