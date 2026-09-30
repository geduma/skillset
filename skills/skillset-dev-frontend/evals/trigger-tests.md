# Trigger tests — skillset-dev-frontend

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "fix this UI bug with missing loading state" → expect activation.
2. "wire this API to the view" → expect activation.
3. "optimize these re-renders and waterfall" → expect activation.
4. "add form validation to this flow" → expect activation.
5. "review components and client vs server state" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "redesign the visual hierarchy and tokens (use design-system)" → should-NOT-trigger this skill.
2. "fix lint formatting only" → should-NOT-trigger this skill.
3. "write the backend endpoint" → should-NOT-trigger this skill.
