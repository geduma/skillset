# Suite Hygiene

Keeps the suite fast, trusted, and enforced.

## 1. De-flake

- Quarantine flaky tests immediately so `main` stays green; file a tracked issue with failure rate and seed.
- Common causes: shared state, real time, unordered async, external services, oversized fixtures.
- Delete or rewrite tests that stay flaky; a skipped-forever test is dead weight.

## 2. Speed

- Keep unit tests in milliseconds; parallelize by file where the runner supports it.
- Split slow service/E2E suites into a separate CI job so fast feedback is not blocked.
- Record-playback UI scripts are a last resort — prefer programmed drivers with explicit waits.

## 3. Enforcement

- Tests run in CI on every PR with clear pass/fail; no merging on red without owner override.
- Coverage is a spot-check for missing areas, never a merge target to game.
- Keep generated output (`coverage/`, snapshots diffs) out of review noise; review intent, not artifacts.
