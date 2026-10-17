---
name: skillset-dev-backend
description: Designs consistent, evolvable backend APIs in any stack: noun-based resources, correct methods, predictable errors, paginated collections, versioning, idempotency, and OpenAPI contracts. Use when designing, building, or reviewing REST resources and URIs, HTTP methods and status codes, error envelopes, pagination filtering sorting, versioning, idempotency, async operations, or OpenAPI contracts. Also use when the user says design this API, review my endpoint, fix my status codes, or version this API. Do not use for auth hardening, secrets, or OWASP checks - use skillset-sec-appsec. Do not use for frontend state or fetching logic - use skillset-dev-frontend.
license: MIT
allowed-tools: Read Edit Write Glob Grep Shell
metadata:
  version: 1.4.0
---

# Backend API

Designs consistent, evolvable backend APIs in any stack: noun-based resources, correct methods, predictable errors, paginated collections, versioning, idempotency, and OpenAPI contracts.

This skill is project-agnostic. It adapts examples to the detected language and framework and never hardcodes paths or package names.

## When to use this

- The user designs, builds, or reviews REST endpoints or backend services.
- The user asks about URIs, methods, status codes, errors, pagination, versioning, or contracts.
- A diff needs an API-design pass before release.

## Non-negotiable principles

1. **Resources are nouns, actions are HTTP methods.** No verbs in URIs. See `references/resource-design.md`.
2. **Status codes carry meaning alone.** 201 with Location for creates, 204 for empty success, 400/404/409/422 split correctly. See `references/methods-status.md`.
3. **Errors are uniform and actionable.** One envelope, no sensitive leakage. See `references/errors-pagination.md`.
4. **Collections are paginated and filtered.** Defaults plus max limit on every list. See `references/errors-pagination.md`.
5. **PUT is idempotent; POST is not.** Retries are safe by design. See `references/versioning-contracts.md`.
6. **Contract first.** Define the interface before implementing it. The contract is the spec; implementation follows. See `references/api-contract.md`.
7. **Hyrum's Law.** Every observable behavior becomes a de facto contract once users depend on it. Be intentional about what you expose; don't leak implementation details; plan for deprecation at design time.
8. **One-Version Rule.** Avoid forcing consumers to choose between multiple versions of the same dependency or API. Extend rather than fork.
9. **Validate at boundaries only.** Trust internal code. Validate where external input enters: API route handlers, form submissions, external service responses, environment variables. Never validate between internal functions sharing type contracts.
10. **Idempotency key honored correctly.** Claim atomically with a unique constraint (never SELECT-then-INSERT). Derive the key from an immutable identifier, not a UUID or timestamp per attempt. A reused key with a different payload fails loudly.
11. **Confirm before breaking changes.** Version bump or migration note needs approval.

## Workflow (summary)

1. **Model resources** — nouns, plurals, shallow nesting per `references/resource-design.md`.
2. **Assign methods and codes** — GET/POST/PUT/PATCH/DELETE semantics per `references/methods-status.md`.
3. **Shape errors and lists** — envelope plus pagination/filter/sort per `references/errors-pagination.md`.
4. **Contract and evolve** — OpenAPI, versioning, idempotency, async per `references/versioning-contracts.md` and `references/api-contract.md`.

See `references/resource-design.md`, `references/methods-status.md`, `references/errors-pagination.md`, `references/versioning-contracts.md`, `references/api-contract.md` for detail. Routing conflicts: see `docs/ROUTING.md`.