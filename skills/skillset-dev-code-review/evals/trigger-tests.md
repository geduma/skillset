# Trigger tests — skillset-dev-code-review

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "review this pull request before I merge it" → expect activation.
2. "evaluate this code another model produced" → expect activation.
3. "review the fix and its regression test" → expect activation.
4. "run a five-axis review of this change" → expect activation.
5. "find correctness, readability, architecture, security, and performance issues in this diff" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "set up ESLint and Prettier (use dev-style)" → should-NOT-trigger this skill.
2. "run a formal pentest with findings.json (use sec-audit)" → should-NOT-trigger this skill.
3. "write the changelog entry (use docs-project)" → should-NOT-trigger this skill.
