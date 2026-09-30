# Resource Design

Source baseline: Microsoft Azure Web API Design Best Practices (learn.microsoft.com), Richardson Maturity Model.

## 1. Nouns, not verbs

- `/orders` and `/orders/1`, never `/create-order` or `/getOrder`.
- Plurals for collections: `/customers`, item at `/customers/5`.
- Sub-resources for ownership: `/customers/5/orders`; keep nesting shallow (max collection/item/collection).
- Non-resource actions (e.g. calculations) are rare exceptions via query-invoked functions, not the default.

## 2. Relationships

- Prefer links over deep nesting: return related-resource links and let clients follow them.
- Avoid chatty APIs (many small resources needing N requests) and extraneous fetching (one giant blob with unused fields).
- Never mirror DB tables 1:1; the API is a business abstraction with a mapping layer, not a schema dump.

## 3. Representations

- JSON by default (`application/json`); support content negotiation via `Accept` where the stack allows.
- Return `406 Not Acceptable` for unsupported requested types, `415 Unsupported Media Type` for unsupported posted types.
- Keep field names stable; additive fields are non-breaking, renames and removals are breaking.

## 4. Ask the user

- What are the core business entities versus internal tables?
- Which relationships must be traversable in one call versus follow-up links?
