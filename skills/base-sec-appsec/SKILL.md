---
name: base-sec-appsec
description: Use this when hardening or reviewing application, API, or backend code for secrets exposure, auth, database access, input handling, file uploads, rate limiting, security headers, TLS, or dependency risks, or when the user asks harden this app, secure this API, check OWASP Top 10, review backend security, or fix a security finding. Does not run a full pentest audit; for that use base-sec-audit.
---

# AppSec Baseline

Applies a preventive security baseline to any application, API, or backend without switching its stack: finds missing controls and proposes minimal fixes.

This skill is project-agnostic. It adapts examples to the detected language and framework and never hardcodes paths or package names.

## When to use this

- The user asks to harden, secure, or review app, API, or backend code.
- The user asks about secrets, auth, sessions, passwords, database access, encryption, validation, XSS, uploads, rate limiting, headers, TLS, or dependencies.
- A diff needs a preventive security pass before release.

## Non-negotiable principles

1. **Never assume what varies.** If secret location, auth model, or scope is unclear, ask. See `references/auth-session.md`.
2. **Secrets stay out of code and git.** See `references/secrets-git.md`.
3. **Deny by default.** Authenticate first, authorize every object, validate every input. See `references/data-db.md`, `references/input-output.md`.
4. **Store safely, transport safely.** Hash passwords, encrypt sensitive data, force HTTPS. See `references/data-db.md`, `references/api-transport.md`.
5. **Confirm before hard-to-reverse actions.** Key rotation, migration, mass rewrites: summarize first, wait for approval.

## Workflow (summary)

1. **Map the surface** — detect stack, env handling, auth/session, DB access, inputs/uploads, API/headers/TLS/deps. Ask only for what you cannot infer.
2. **Check against the baseline** — run the five checklists in order: `references/secrets-git.md`, `references/data-db.md`, `references/auth-session.md`, `references/input-output.md`, `references/api-transport.md`. Mark each as pass, hardening note, or vulnerability.
3. **Propose minimal fixes** — smallest project-native change per failing check, with exact file and snippet. Confirm before writing if keys rotate or many files change.
4. **Verify** — rerun the project's own tests and linters. Report what passed, what remains, and what needs a full audit via base-sec-audit.

See `references/secrets-git.md`, `references/data-db.md`, `references/auth-session.md`, `references/input-output.md`, `references/api-transport.md` for detail.
