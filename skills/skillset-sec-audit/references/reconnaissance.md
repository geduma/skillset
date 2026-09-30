# Reconnaissance

Goal: map where attacks can enter before hunting. Output: `architecture.md` plus `coverage-ledger.json`.

## 1. Collect

- Entrypoints: routes, handlers, RPCs, webhooks, queues, file parsers, uploads.
- Trust boundaries: client vs server, tenant vs tenant, user vs admin, app vs DB.
- Auth model: sessions, tokens, roles, public routes.
- Data map: PII, secrets, payment data, where each lives and flows.
- Prior evidence: past audits, findings, fixes, and what changed since.

## 2. Write architecture.md

Keep it short: components, boundaries, input surfaces, auth summary, data flows. Link files and line ranges, not full dumps.

## 3. Write coverage-ledger.json

One unit per attack surface slice, for example `auth-login`, `api-orders`, `upload-avatar`. Each unit has: id, files, entrypoints, status of pending, covered, or gap, and evidence pointer.

Minimal shape:

```
{"units": [{"id": "api-orders", "files": ["src/routes/orders.ts"], "entrypoints": ["POST /orders"], "status": "pending"}]}
```

## 4. Validate

Run `scripts/validate-coverage-ledger.cjs` after creation and after every update. Fix schema errors before hunting.

## 5. Ask the user

- What is in scope: full repo, `src/`, or one service?
- Where should audit artifacts live? Default is an ignored folder, never the source tree unless the user confirms.
