# Trigger tests — skillset-dev-backend

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "design this API with resources and URIs" → expect activation.
2. "review my endpoint status codes" → expect activation.
3. "fix pagination filtering sorting on this list" → expect activation.
4. "version this API without breaking clients" → expect activation.
5. "write the OpenAPI contract for these resources" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "harden auth and secrets on this API (use sec-appsec)" → should-NOT-trigger this skill.
2. "wire this API to a React view (use dev-frontend)" → should-NOT-trigger this skill.
3. "write commit messages for this" → should-NOT-trigger this skill.
