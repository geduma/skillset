# Forms and Data

Client convenience plus server truth. Never trust client validation alone.

## 1. Form model

- Controlled inputs with visible label above, error below with icon. Never placeholder-only.
- Schema-driven validation shared between client and server when the project allows it.
- Preserve input on error; focus the first invalid field; keep submit disabled only with a clear reason.
- Name actions by outcome: Save changes, Publish, Approve payment. Same verb in button, toast, and log.

## 2. Submission flow

- Optimistic update only with rollback path; otherwise pending state with disabled submit.
- Idempotency key or disabled double-submit for payments and mutations.
- Show loading, success, error, and empty explicitly. Empty is an invitation to act, not a blank page.
- Errors explain what happened and how to fix, in interface voice. No vague alerts.

## 3. Fetching and mutations

- Centralize API access in one client module per project convention.
- Timeouts, retries with backoff for idempotent reads, no silent retry for payments.
- Handle 401 by redirecting to login with return URL; handle 403 with a denied state, not a crash.
- Pagination with stable cursors or offsets; show total, scope, units, and freshness for data views.

## 4. Ask before assuming

- Auth model, validation source of truth, and mutation side effects vary. Ask when unclear.
- Mass form or API-client rewrites need explicit confirmation first.
