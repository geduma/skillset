# Methods and Status Codes

Source baseline: Microsoft Azure Web API Design Best Practices; RFC 5789 (PATCH), RFC 6902 (JSON Patch), RFC 7396 (JSON Merge Patch).

## 1. Method semantics

- GET: retrieve one item or collection. No side effects.
- POST to a collection: create; server assigns the URI. POST to an item: process without creating.
- PUT to an item: full replace, or create only if the client can reliably assign URIs. Must be idempotent.
- PATCH to an item: partial update via merge-patch (`application/merge-patch+json`) or JSON patch (`application/json-patch+json`).
- DELETE to an item: remove.

## 2. Status codes

- GET: `200` with body, `204` for empty result sets where applicable, `404` for missing item.
- POST: `201` with `Location` header plus representation for creates; `200` or `204` for process-only.
- PUT: `200` for updated, `201` for created via PUT, `204` for updated with no body, `409` on state conflict.
- PATCH: `200` for updated, `400` for malformed patch, `409` for valid patch inapplicable to current state, `415` for unsupported patch format.
- DELETE: `204` for deleted, `404` for missing.
- Never return `200` with an error body; the code alone must signal outcome.

## 3. Bulk and async

- Offer bulk PUT on collections to cut chattiness.
- Long operations return `202 Accepted` with a `Location` status endpoint; poll it, then `303 See Other` to the new resource on completion.
