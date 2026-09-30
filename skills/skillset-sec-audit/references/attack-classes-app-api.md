# Attack Classes for App and API

Subset for application, API, and backend audits. Derived from OWASP ASVS and Top 10. Full Cloudflare class list is broader; this file keeps the app and API slice only.

## 1. Core prompts per candidate

- Auth bypass: call the endpoint with no token, expired token, and another user token.
- IDOR and broken object auth: swap IDs, tenant ids, and nested resource ids.
- Mass assignment: send `role`, `owner_id`, `price`, `balance` fields the UI never sends.
- Injection: close the query context with quotes, operators, or template markers; confirm with parameterized-code reading.
- Stored and reflected XSS: submit markup in every reflected field, then read it back in context.
- Upload abuse: wrong extension, double extension, oversized file, polyglot content; check serving headers.
- Logic abuse: negative quantity, replay, coupon reuse, state skip, pagination dump.
- Rate and quota: burst login, search, and export; expect 429 and caps.

## 2. Wildcard checks

- Try the obvious: `admin`, `true`, `0`, empty object, oversized array, null bytes, unicode tricks.
- Read error paths: verbose errors, stack traces, timing differences on login.
- Check method handling: GET vs POST, HEAD, OPTIONS, trailing slash, case change.

## 3. What is not covered here

- Memory-safety, binary, and kernel targets.
- AI and LLM prompt injection or tool abuse.
- Desktop, mobile, and local IPC.
- Cloud IAM, IaC, containers, and deployment config beyond app headers and TLS.

If the target needs those, stop and ask for a dedicated audit skill instead of stretching this one.

## 4. Recording

Each candidate needs: title, unit id, entrypoint, file plus lines, attacker request, observed result, and impact. No impact means no severity.
