# Trigger tests — skillset-docs-discovery

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "grill this idea before we spec anything" → expect activation.
2. "sharpen the scope of this vague feature" → expect activation.
3. "challenge my assumptions on this product call" → expect activation.
4. "interview me until this is committable" → expect activation.
5. "help decide what to build first" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "write the ADR for this decided outcome (use docs-project)" → should-NOT-trigger this skill.
2. "break this into implementation tasks (use dev-feature)" → should-NOT-trigger this skill.
3. "review this code" → should-NOT-trigger this skill.
