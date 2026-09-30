# Trigger tests — skillset-docs-project

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "document this with a README quickstart" → expect activation.
2. "write an ADR for this architecture decision" → expect activation.
3. "update the changelog for this release" → expect activation.
4. "fix these stale code comments" → expect activation.
5. "onboard new contributors guide" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "grill my vague idea (use docs-discovery)" → should-NOT-trigger this skill.
2. "format this commit message" → should-NOT-trigger this skill.
3. "fix test flakes" → should-NOT-trigger this skill.
