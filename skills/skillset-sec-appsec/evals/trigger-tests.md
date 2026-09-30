# Trigger tests — skillset-sec-appsec

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "harden this app against OWASP Top 10" → expect activation.
2. "review backend security for auth and sessions" → expect activation.
3. "check for secrets exposure in this repo" → expect activation.
4. "fix this file upload validation" → expect activation.
5. "secure this API with rate limiting and headers" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "run a full pentest audit with findings.json (use sec-audit)" → should-NOT-trigger this skill.
2. "design REST pagination" → should-NOT-trigger this skill.
3. "write frontend components" → should-NOT-trigger this skill.
