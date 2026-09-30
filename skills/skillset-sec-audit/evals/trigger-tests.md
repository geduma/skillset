# Trigger tests — skillset-sec-audit

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "audit this codebase for vulnerabilities" → expect activation.
2. "hunt for exploits in this API" → expect activation.
3. "pentest this backend code" → expect activation.
4. "produce findings with REPORT.md and findings.json" → expect activation.
5. "review this code for exploitable sinks" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "quick preventive hardening without a formal report (use sec-appsec)" → should-NOT-trigger this skill.
2. "fix a failing unit test" → should-NOT-trigger this skill.
3. "write documentation" → should-NOT-trigger this skill.
