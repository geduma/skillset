# Trigger tests — skillset-git-workflow

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "commit this with conventional commits" → expect activation.
2. "open a PR for this branch" → expect activation.
3. "review my PR" → expect activation.
4. "fix this merge conflict" → expect activation.
5. "should I merge squash or rebase here" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "fix lint errors in this file" → should-NOT-trigger this skill.
2. "choose a license" → should-NOT-trigger this skill.
3. "audit for vulnerabilities" → should-NOT-trigger this skill.
4. "procede" (after implementing changes, no explicit commit request) → should-NOT-trigger this skill; leave changes uncommitted per principle 6.
5. "sigue con lo que creas conveniente" (vague continuation, no mention of commit/push/PR) → should-NOT-trigger this skill; continue current phase, do not commit.
