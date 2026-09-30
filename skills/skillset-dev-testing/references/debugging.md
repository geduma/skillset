# Debugging

Turns bug reports into locked regression tests.

## 1. Reproduce first

- Restate expected versus actual behavior with exact steps, input, and environment.
- Write the smallest failing test before touching production code; confirm it fails for the right reason.
- If the bug came from a high-level test, replicate it at the lowest layer that still fails.

## 2. Bisect

- Narrow with divide and conquer: recent commits (`git bisect`), feature flags, or minimal input reduction.
- Change one variable at a time; keep notes of what was ruled out.
- Check the seams first: boundaries, null/empty, time zones, encoding, concurrency, and stale caches.

## 3. Fix and lock

- Fix the root cause, not the symptom; add the regression test alongside the fix.
- Rerun the full related suite plus linter and typecheck; report what ran and what failed.
- For intermittent bugs, loop the suspect test until the failure rate is measured before and after.

## 4. Ask the user

- Exact reproduction steps and environment if missing.
- Whether the fix may change behavior others rely on (needs a breaking-change note).
