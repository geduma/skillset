# Trigger tests — skillset-dev-orchestrator

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "plan this end to end from idea to commit" → expect activation.
2. "run the full pipeline for this feature" → expect activation.
3. "coordinate these skills across phases" → expect activation.
4. "which skill should handle this multi-phase task" → expect activation.
5. "sequence spec code tests docs for this" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "write a single unit test (use dev-testing directly)" → should-NOT-trigger this skill.
2. "just commit this one-liner" → should-NOT-trigger this skill.
3. "quick license question" → should-NOT-trigger this skill.
