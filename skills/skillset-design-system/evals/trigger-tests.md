# Trigger tests — skillset-design-system

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "design this page with a distinctive visual identity" → expect activation.
2. "review my UI hierarchy and spacing" → expect activation.
3. "avoid generic AI look for this dashboard" → expect activation.
4. "improve visual hierarchy on mobile and desktop" → expect activation.
5. "build this with Material 3 tokens instead of Apple look" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "fix fetching and state logic (use dev-frontend)" → should-NOT-trigger this skill.
2. "optimize SQL queries" → should-NOT-trigger this skill.
3. "write commit messages" → should-NOT-trigger this skill.
