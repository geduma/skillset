# Naming

Intent-first naming distilled from the user's repos and Clean Code. Language-agnostic: apply the same ideas with the project's own casing idioms.

## 1. General rules

- Name for intent, not implementation. `retryAfterMaxSeconds`, not `temp2`.
- One concept, one term per codebase. Do not mix `fetch/load/get` for the same operation.
- Keep names pronounceable and searchable. Avoid single letters except loop indexes or well-known math.
- Booleans read as predicates: `isEnabled`, `hasToken`, `canRetry`.
- Constants for fixed limits in upper snake: `MAX_TOOL_ITERATIONS`, `SESSION_PURGE_INTERVAL_MS`. Include units in the name (`Ms`, `Seconds`, `Bytes`).
- Negations are banned in flags. Prefer `enabled` over `disabled`; `allowPrivateHosts` over `blockPublicOnly`.

## 2. Files and folders

- File names are kebab-case: `llm-router.ts`, `proxy.routes.js`, `session-store.ts`.
- Folders are short plural nouns: `routes/`, `handlers/`, `services/`, `middleware/`, `utils/`, `db/`, `types/`, `scripts/`, `docs/`, `tests/`, `config/`, `docker/`.
- One responsibility per file. A file mixing routing, persistence, and formatting is split.
- Test files mirror source names: `search.test.ts` next to `search.ts`, or under a mirrored `tests/` tree.

## 3. Functions and types

- Functions are verbs: `normalizeConfig`, `recoverCooldowns`, `sanitizeFileName`.
- Small and single-purpose. Early return over nesting. Max ~3 params; group the rest into an options object.
- Types and classes are PascalCase nouns: `GatewayRequest`, `SessionStore`, `RateLimiter`.
- Do not abbreviate domain terms. `config`, `provider`, `session` stay whole.

## 4. What to reject

- Generic names: `data`, `info`, `manager2`, `utils2`, `handler` without a qualifier.
- Hungarian or type prefixes: `strName`, `bFlag`.
- Dead or commented-out code kept "just in case". Delete it; history lives in version control.
