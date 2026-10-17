# Security Checklist

Preventive security baseline for application, API, or backend code. Project-agnostic.

## 1. Secrets

- [ ] No secrets, API keys, passwords, or tokens in source code
- [ ] No secrets in commit history (check `git log -p` if needed)
- [ ] Secrets loaded from environment variables or a secrets manager
- [ ] `.env` files in `.gitignore`; `.env.example` committed without real values
- [ ] No hardcoded connection strings with credentials

## 2. Authentication & Authorization

- [ ] Authenticate first, authorize every object access
- [ ] Sessions/tokens validated on every request
- [ ] Passwords hashed (bcrypt, argon2, scrypt — never plaintext or fast hashes)
- [ ] Authorization checks on every resource endpoint (not just route level)
- [ ] No privilege escalation paths (user can't access another user's data)

## 3. Input handling

- [ ] All user input validated at system boundaries
- [ ] SQL queries parameterized (no string concatenation)
- [ ] Output encoded to prevent XSS
- [ ] File uploads: type-checked, size-limited, stored outside web root, scanned
- [ ] External data (API responses, logs, user content, config) treated as untrusted
- [ ] Rate limiting on authentication and write endpoints

## 4. Data storage & transport

- [ ] HTTPS enforced (TLS everywhere)
- [ ] Sensitive data encrypted at rest
- [ ] Database access uses least-privilege credentials
- [ ] No sensitive data in logs (passwords, tokens, PII)

## 5. Dependencies

- [ ] Dependencies from trusted sources
- [ ] `npm audit` / equivalent run, no known high/critical vulnerabilities
- [ ] Lockfile committed and reviewed (not hand-edited)
- [ ] One dependency per change when upgrading; changelog read before bumping

## 6. Security headers

- [ ] Security headers set (CSP, HSTS, X-Content-Type-Options, X-Frame-Options)
- [ ] CORS configured restrictively (not `*` for credentials)

## Red flags

- Secrets in code or git history
- String-concatenated SQL queries
- Passwords stored in plaintext
- No authorization checks on object access
- CORS set to `*` with credentials enabled
- Vulnerable dependencies with no remediation plan

## Relationship to skills

- `skillset-sec-appsec` owns this checklist as its preventive baseline.
- `skillset-dev-code-review` reviews security as axis 4 of the five-axis review.
- `skillset-sec-audit` is for formal hunts with `findings.json` + `REPORT.md`, not this checklist.