# Trigger tests — skillset-legal-license

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "add a LICENSE to this repo" → expect activation.
2. "protect my project from commercial exploitation" → expect activation.
3. "I don't want anyone profiting off my code" → expect activation.
4. "prepare this repo for public release" → expect activation.
5. "replicate the licensing setup from my other repo" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "review code style" → should-NOT-trigger this skill.
2. "write tests" → should-NOT-trigger this skill.
3. "fix a merge conflict" → should-NOT-trigger this skill.
