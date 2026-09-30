# Secrets and Git Hygiene

Covers Secret Management and Git Secret Security. Source baseline: OWASP Secrets Management Cheat Sheet, OWASP Key Management Cheat Sheet.

## 1. What to look for

- API keys, tokens, DB URLs, private keys hardcoded in source, config, tests, or docs.
- `.env` files committed, secrets in shell history, CI logs, error messages, or client bundles.
- Weak randomness for tokens: `Math.random`, incrementing IDs, timestamps as secrets.
- Same key reused across dev, staging, and prod.

## 2. Checks

1. Search for `api_key`, `secret`, `BEGIN PRIVATE KEY`, `aws_`, `ghp_`, `sk-`, connection strings.
2. Confirm `.env`, `*.pem`, `*.key` are git-ignored and never committed.
3. Confirm server-only keys are not exposed to the browser bundle or mobile client.
4. Confirm CI secrets come from a manager, not from repo files.

## 3. Fixes

- Move secrets to env vars or a secret manager. Read at runtime, never import from a committed file.
- Use `.env.example` with placeholder values only.
- Example pattern (adapt to stack):
  ```
  api_key = os.environ.get("API_KEY")
  if not api_key: raise RuntimeError("missing API_KEY")
  ```
- Give each environment its own key. Revoke any key that was ever committed.

## 4. Git cleanup

- If a secret was committed: revoke it first, then purge history. Revocation matters more than rewriting git.
- Add pre-commit scanning (gitleaks, trufflehog, or platform secret scanning) and block pushes on hits.
- Confirm before rewriting published history; it forces every clone to re-sync.

## 5. Ask the user

- Where are prod secrets stored today, and can this project read from there?
- Which committed secret must be revoked now?
