# Trigger tests — skillset-creator

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "make a skill for onboarding reviews" → expect activation.
2. "turn this repeated checklist into a reusable instruction set" → expect activation.
3. "review my skill, it never triggers" → expect activation.
4. "fix this SKILL.md, it is too long and token-heavy" → expect activation.
5. "add a new skill for database migrations following repo conventions" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "write a test for this function (use dev-testing)" → should-NOT-trigger this skill.
2. "commit this change (use git-workflow)" → should-NOT-trigger this skill.
3. "audit this code for vulnerabilities (use sec-audit)" → should-NOT-trigger this skill.
