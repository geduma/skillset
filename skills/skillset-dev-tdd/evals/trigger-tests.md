# Trigger tests — skillset-dev-tdd

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "write a failing test first, then implement this function" → expect activation.
2. "walk me through red-green-refactor for this behavior" → expect activation.
3. "prove this bug with a test before fixing it" → expect activation.
4. "implement this logic test-first" → expect activation.
5. "add a regression test that reproduces the reported failure" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "plan the overall test strategy for this service (use dev-testing)" → should-NOT-trigger this skill.
2. "run a formal security audit (use sec-audit)" → should-NOT-trigger this skill.
3. "write an ADR for this decision (use docs-project)" → should-NOT-trigger this skill.
