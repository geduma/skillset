# Trigger tests — skillset-dev-incremental

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "implement this feature in small, verifiable slices" → expect activation.
2. "land this change incrementally without a big-bang rewrite" → expect activation.
3. "split this task into thin vertical increments" → expect activation.
4. "roll this incomplete feature out behind a flag" → expect activation.
5. "pick up the next task from the approved plan" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "design the REST resources and status codes (use dev-backend)" → should-NOT-trigger this skill.
2. "review this pull request across five axes (use dev-code-review)" → should-NOT-trigger this skill.
3. "write the spec and task breakdown (use dev-feature)" → should-NOT-trigger this skill.
