---
name: base-sec-audit
description: Use this when the user asks for a security audit, vulnerability hunt, penetration test of code, find security vulnerabilities, review this codebase for exploits, or wants findings with REPORT.md and findings.json. For preventive hardening without a formal audit, use base-sec-appsec instead.
---

# Security Audit

Runs a structured, evidence-backed audit of app, API, or backend code as a multi-phase hunt with independent verification. Adapted from the Cloudflare security-audit-skill harness (MIT) and OWASP ASVS.

This skill is project-agnostic and language-agnostic. It never executes untrusted target code without an OS-enforced sandbox.

## When to use this

- The user asks to audit, pentest, or hunt vulnerabilities in a codebase or folder.
- The user wants verified findings with severity, evidence, and report artifacts.
- Security questions alone use guidance mode; report artifacts require full audit mode.

## Non-negotiable principles

1. **Only confirm boundary failures.** Unproven leads stay as needs-validation. See `references/validation-reporting.md`.
2. **Adversarial validation.** The verifier is never the hunter. See `references/validation-reporting.md`.
3. **Severity requires impact.** Likelihood times observed impact, not checklist deviation.
4. **Defense in depth gaps are hardening notes**, not vulnerabilities.
5. **Confirm before running target code.** Without a sandbox with no network and scratch-only writes, keep leads as needs-validation.

## Workflow (summary)

1. **Recon** — map architecture, trust boundaries, and coverage ledger. See `references/reconnaissance.md`.
2. **Hunt** — assign isolated hunters per ledger unit, record checks. See `references/hunting.md`.
3. **Attack classes** — apply app/API patterns in `references/attack-classes-app-api.md`. Memory-safety, AI/LLM, desktop/IPC, and cloud/IaC are out of scope here.
4. **Validate and report** — disprove candidates, write verified records, derive reports. Run `scripts/validate-coverage-ledger.cjs` and `scripts/validate-findings.cjs` after each update. See `references/validation-reporting.md`.
5. **Confirm output dir** before writing outside the target; default is an ignored audit folder.

See `references/reconnaissance.md`, `references/hunting.md`, `references/attack-classes-app-api.md`, `references/validation-reporting.md` for detail.
