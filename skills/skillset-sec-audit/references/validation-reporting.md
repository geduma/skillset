# Validation and Reporting

Goal: disprove before confirming, then report from verified records only.

## 1. Candidate validation

- Assign each unique candidate to a fresh verifier that did not hunt it.
- The verifier tries to disprove: wrong sink, auth actually enforced, input never reaches code, impact not observable.
- Verdicts: confirmed needs full source trace plus bounded impact; needs-validation keeps the exact unresolved fact and no severity; rejected records why it failed.

## 2. Structured output

- Write `findings.json` with three arrays: confirmed, needs_validation, rejected.
- Each record has: id, title, severity for confirmed only, unit id, file, lines, entrypoint, evidence, impact.
- Run `scripts/validate-findings.cjs` in Phase 4 and after every replacement.

## 3. Independent record verification

- A fresh agent rechecks every final source claim. Material replacements get another independent verifier.
- Derive reports only from verified records plus the coverage ledger.

## 4. Reports

- `REPORT.md`: scope, method, counts, top confirmed issues with fixes, hardening notes.
- `FINDINGS-DETAIL.md`: one section per confirmed finding with reproduction and fix.
- `NEEDS-VALIDATION.md`: blocked leads with exact next check, never presented as confirmed.

## 5. Confirm before publishing

Summarize counts and files to write, wait for approval if the output dir is inside the repo or shared externally. Additive runs reuse prior findings and revalidate changed sources.
