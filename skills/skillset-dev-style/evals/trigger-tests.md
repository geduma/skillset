# Trigger tests — skillset-dev-style

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "review this diff for naming and clean code" → expect activation.
2. "organize this project folder layout" → expect activation.
3. "add a linter with strict type-checking and formatting" → expect activation.
4. "follow my style to refactor this module" → expect activation.
5. "enforce quality gates on this PR" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "choose between React and Vue for this project" → should-NOT-trigger this skill.
2. "write a commit message" → should-NOT-trigger this skill.
3. "pick an open-source license" → should-NOT-trigger this skill.
