# Frontend Security Notes

Secure-by-default pointers. Full baseline lives in `skillset-sec-appsec`; full audit in `skillset-sec-audit`. This file only prevents frontend regressions.

## 1. Output safety

- Never use `innerHTML`, `dangerouslySetInnerHTML`, or `v-html` with user data. Use framework auto-escaping.
- Rich HTML only after sanitization with DOMPurify or the project sanitizer.
- JSON responses use `application/json`, never `text/html`.
- No inline event attributes such as `onclick`. Use `addEventListener` or framework bindings so CSP can hold.

## 2. CSP-compatible code

- No `eval`, `new Function`, or `data:` scripts. No `unsafe-inline` or broad wildcards to make effects work.
- Prefer nonces or hashes with `strict-dynamic` where the project controls headers.
- Set `object-src 'none'`, `base-uri 'none'`, explicit `frame-ancestors`.
- Minimize third-party domains for fonts, animations, and trackers.

## 3. Data handling

- Validate on client for UX, re-validate on server for security.
- Never bundle secrets, tokens, or private keys. Public keys only behind server checks.
- Authenticate first, authorize every object. 401 redirects to login; 403 shows denied.
- Cookies with `Secure`, `HttpOnly`, and `SameSite`; prefer `__Host-` prefix when applicable.

## 4. Headers and transport

- Require HTTPS with HSTS; set `X-Content-Type-Options: nosniff` and a strict `Referrer-Policy`.
- Cache control must not store sensitive views in shared caches.
- Defer to `skillset-sec-appsec` references for secrets, auth, uploads, rate limits, and dependencies.
