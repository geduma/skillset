# Trigger tests — skillset-dev-feature

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "plan this new feature with spec and tasks" → expect activation.
2. "break down this endpoint into stories and scope" → expect activation.
3. "estimate scope for this functional change" → expect activation.
4. "write a spec before implementation" → expect activation.
5. "clarify requirements for this user story" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "grill my vague pre-spec idea (use docs-discovery)" → should-NOT-trigger this skill.
2. "fix this bug without a feature" → should-NOT-trigger this skill.
3. "record an ADR for a decided outcome" → should-NOT-trigger this skill.
