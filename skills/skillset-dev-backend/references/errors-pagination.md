# Errors and Pagination

Source baseline: RFC 9457 Problem Details for HTTP APIs; Microsoft pagination guidance.

## 1. Error envelope

- One shape across all endpoints. Prefer RFC 9457 `application/problem+json`:
  ```
  {"type": "https://api.example.com/probs/out-of-stock", "title": "Out of stock",
   "status": 409, "detail": "Item gizmo is out of stock", "instance": "/orders/99"}
  ```
- Split correctly: `400` malformed syntax, `422` well-formed but semantically invalid, `409` state conflict (e.g. duplicate name), `401` missing auth, `403` denied, `404` missing, `429` rate-limited.
- Return all field errors at once, not one per round trip. Messages are actionable; never leak secrets, stack traces, or internal paths.

## 2. Pagination

- Query params: `limit` (page size) plus `offset` (start index). Defaults like `limit=25&offset=0`.
- Always enforce a server-side `max-limit`; over-limit requests get capped or `400` per documented policy.
- Responses include total count or next/prev links so clients can walk the whole set.

## 3. Filtering, sorting, selection

- Filter via query: `GET /orders?status=shipped&minCost=100`.
- Sort via `sort` param (e.g. `sort=price`); note it fragments caches keyed on URI.
- Field selection via `fields=id,name` for projections; validate requested fields against what the caller may see.
