# Input Handling and File Uploads

Covers Input Validation, XSS Prevention, File Upload Security. Baseline: OWASP Input Validation, XSS Prevention, File Upload Cheat Sheets.

## 1. Input validation

- Validate on the server: type, length, range, format. Reject, do not silently clean.
- Prefer allowlists: enums, regex with anchors, max lengths matching DB columns.
- Parameterize OS commands and queries; never pass raw input to shells or evaluators.
- Return one generic error; do not echo raw input in messages.

## 2. XSS prevention

- Escape by context: HTML entity encode in HTML, JS-encode in scripts, URL-encode in URLs.
- Prefer framework auto-escaping and safe templating. Avoid `innerHTML`, `dangerouslySetInnerHTML`, or raw HTML helpers with user data.
- Set Content-Security-Policy as defense in depth, not as the only fix.
- Validate URLs before rendering links: allow http/https only, block javascript and data schemes.

## 3. File uploads

- Require auth, cap size and count per user, and scan or type-check server-side.
- Verify magic bytes plus extension, not extension alone. Store outside web root with random names:
  ```
  stored_name = uuid4().hex + ext
  ```
- Serve with `Content-Disposition: attachment` and correct content type. Never execute uploads.
- Set filesystem permissions to least privilege. Confirm before over-writing existing files.

## 4. Ask the user

- Which endpoints accept rich text, HTML, or files?
- Where are uploads stored and served from, and what size limits apply?
