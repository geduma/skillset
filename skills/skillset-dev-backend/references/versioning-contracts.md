# Versioning and Contracts

Source baseline: Microsoft API versioning guidance; OpenAPI Initiative (openapis.org).

## 1. Versioning strategy

- Additive changes (new fields, new endpoints) need no version bump; clients ignore unknown fields.
- Breaking changes (renames, removals, relationship shifts) require a version signal.
- Options in order of simplicity: URI (`/v2/customers/3`), query (`?version=2`), header (`api-version: 2`), media type (`Accept: application/vnd.acme.v2+json`).
- URI and query versions are cache-friendly; header and media-type versions need header-aware caching to avoid cross-version leakage.

## 2. Idempotency and safety

- Design PUT and DELETE retry-safe; document which POST endpoints accept idempotency keys for safe retries.
- Validate early on create/replace; fail with `409` on duplicate operation IDs unless the request is byte-identical (retry).

## 3. Contract-first

- Describe the API in OpenAPI before coding new surface; generate docs and clients from the contract.
- Keep examples in the contract runnable; reject drift between contract and implementation in review.
- Changing a top-level error code or removing a field is a version bump plus a migration note — confirm with the user first.
