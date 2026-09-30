# API, Transport, and Dependencies

Covers API Rate Limiting, Security Headers, TLS/HTTPS, Dependency Security. Baseline: OWASP REST Security, Transport Layer Security, Secure Headers Project.

## 1. API rate limiting

- Limit per user and per IP on auth, search, export, and write endpoints. Return 429 with Retry-After.
- Cap page size and result counts. Require pagination for lists.
- Strip verbose errors and stack traces from responses.

## 2. Security headers

- Set at the edge or framework middleware:
  ```
  Strict-Transport-Security: max-age=31536000; includeSubDomains
  Content-Security-Policy: default-src 'self'
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  ```
- Remove `X-Powered-By` and other version banners.

## 3. TLS and HTTPS

- Serve HTTPS only. Redirect HTTP to HTTPS and enable HSTS.
- Use TLS 1.2+ with modern ciphers. No mixed content on pages.
- Transmit passwords, tokens, and session cookies over TLS only.

## 4. Dependencies

- Pin versions, audit on install, and fix high-severity CVEs promptly.
- Prefer maintained packages with small scope. Remove unused deps.
- Keep a lockfile and review diffs on upgrade. Confirm before major bumps.

## 5. Ask the user

- Which API routes are public and what limits apply today?
- Where are headers and TLS terminated: app, proxy, or CDN?
