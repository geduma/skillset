# Data and Database Access

Covers Database Security, Row-Level Security, Data Encryption, Database Monitoring. Baseline: OWASP SQL Injection Prevention, Query Parameterization, Cryptographic Storage Cheat Sheets.

## 1. Database access

- Use parameterized queries or an ORM with bound parameters. Never concatenate user input into SQL, NoSQL, or LDAP strings.
- Connect with least-privilege roles: app role can read/write app tables only, never admin.
- Prefer allowlisted public schemas or views over direct table access from clients.
- Validate object IDs server-side before querying.

## 2. Row-Level Security (RLS)

- Enable RLS on multi-tenant tables so each query is scoped to the caller:
  ```
  ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
  ```
- Policy example (adapt to stack): `owner_id = current_user_id()`.
- Deny by default; add permissive policies explicitly.
- Test with two users: user A must never read user B rows, including via joins, views, or search.
- Never trust a client-supplied tenant id without server verification.

## 3. Encryption

- Encrypt sensitive fields at rest with an authenticated mode (AES-GCM or ChaCha20-Poly1305). Never roll custom crypto.
- Keep keys in a KMS or secret manager, never beside the data. Rotate without downtime.
- Minimize what you store: drop raw PII when a hash or token suffices.
- Passwords are hashed, not encrypted. See `auth-session.md`.

## 4. Monitoring and audit

- Log who accessed what sensitive record, when, and with what result. Never log secrets or full PII.
- Alert on bulk exports, disabled RLS, new admin grants, or direct prod reads.
- Keep audit logs append-only with a short retention policy the user confirms.

## 5. Ask the user

- Which tables hold PII or financial data and what is their sensitivity level?
- Which DB role does the app use, and are direct client connections allowed?
