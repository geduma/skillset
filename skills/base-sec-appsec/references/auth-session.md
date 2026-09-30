# Auth, Sessions, and Abuse Protection

Covers Authentication, Authorization, Session Security, Password Security, Brute-Force Protection, Bot Protection. Baseline: OWASP Authentication, Password Storage, Session Management Cheat Sheets; NIST SP 800-63B-4.

## 1. Authentication

- Require auth on every non-public route by default. Public routes are explicit exceptions.
- Prefer MFA or passkeys for privileged accounts. Re-authenticate before email change, password change, or payouts.
- Verify server-side on every request; never trust a client role flag.

## 2. Authorization

- Check ownership on every object: `order.owner_id == session.user_id`, not just `is_logged_in`.
- Block mass-assignment: allowlist updatable fields, reject role or balance changes from clients.
- Test IDOR by swapping IDs between two test users.

## 3. Sessions and cookies

- Set cookies with HttpOnly, Secure, and SameSite=Lax or Strict. Use short lifetimes with server-side revocation.
- Rotate session ID at login. Invalidate all sessions on password change or logout.
- Store only a random session id client-side; keep state server-side.

## 4. Passwords per NIST SP 800-63B-4

- Minimum 8 chars, encourage 15+. Allow all characters, no forced complexity rules.
- Screen against known-breached lists. No periodic rotation unless compromise is suspected.
- Hash with Argon2id, bcrypt, or PBKDF2 with unique 32-bit+ salt. Compare with constant-time functions. Transmit over TLS only.

## 5. Brute-force and bots

- Rate-limit login per account plus per IP with exponential backoff. Return generic errors.
- Lock or challenge after 5-10 failures. Log and alert on credential-stuffing spikes.
- Add CAPTCHA or proof-of-work only on abuse signals, not on every form.

## 6. Ask the user

- Which routes are public, and which roles exist?
- What password hasher and session store does the project use?
