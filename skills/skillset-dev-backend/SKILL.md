---
name: skillset-dev-backend
description: Use this when designing, building, or reviewing backend or API code such as REST resources and URIs, HTTP methods and status codes, error envelopes, pagination filtering sorting, versioning, idempotency, async operations, or OpenAPI contracts. Also use when the user says design this API, review my endpoint, fix my status codes, or version this API. Do not use for auth hardening, secrets, or OWASP checks - use skillset-sec-appsec. Do not use for frontend state or fetching logic - use skillset-dev-frontend.
license: MIT
allowed-tools: Read Edit Write Glob Grep Shell
metadata:
  version: 1.1.0
---

# Backend API

Designs consistent, evolvable backend APIs in any stack: noun-based resources, correct methods, predictable errors, paginated collections.

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
6. **Confirm before breaking changes.** Version bump or migration note needs approval.

## Workflow (summary)

1. **Model resources** — nouns, plurals, shallow nesting per `references/resource-design.md`.
2. **Assign methods and codes** — GET/POST/PUT/PATCH/DELETE semantics per `references/methods-status.md`.
3. **Shape errors and lists** — envelope plus pagination/filter/sort per `references/errors-pagination.md`.
4. **Contract and evolve** — OpenAPI, versioning, idempotency, async per `references/versioning-contracts.md`.

See `references/resource-design.md`, `references/methods-status.md`, `references/errors-pagination.md`, `references/versioning-contracts.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
