# Trigger tests — skillset-dev-testing

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "plan test strategy for this service" → expect activation.
2. "write unit tests with AAA and hermetic mocks" → expect activation.
3. "why is this test flaky" → expect activation.
4. "reproduce this bug and add a regression test" → expect activation.
5. "add coverage for this edge case" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "add a linter (use dev-style)" → should-NOT-trigger this skill.
2. "run a security audit (use sec-audit)" → should-NOT-trigger this skill.
3. "write an ADR" → should-NOT-trigger this skill.
