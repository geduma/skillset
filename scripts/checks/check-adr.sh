#!/usr/bin/env python3
"""check-adr.sh (python) — validate a Markdown ADR has Context/Options/Decision/Consequences.
Usage: python3 scripts/checks/check-adr.sh docs/adr/0001-foo.md
"""
import re
import sys
from pathlib import Path

if len(sys.argv) != 2:
    sys.exit("Usage: check-adr.sh <adr-file.md>")
p = Path(sys.argv[1])
if not p.exists():
    sys.exit(f"FAIL: {p} not found")
text = p.read_text()
required = ["context", "options", "decision", "consequences"]
missing = [r for r in required if not re.search(rf"(?im)^#{{1,3}}\s+{r}\b", text)]
if missing:
    print(f"FAIL: {p} missing sections: {missing}")
    sys.exit(1)
if re.search(r"(?im)^#\s+adr\b", text) is None and re.search(r"(?im)status\s*:", text) is None:
    print(f"WARN: {p} has no title/Status line, consider adding one")
print("adr valid")
