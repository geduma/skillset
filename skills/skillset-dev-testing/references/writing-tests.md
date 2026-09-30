# Writing Tests

Source baseline: Fowler Arrange/Act/Assert; FIRST principles (Fast, Independent, Repeatable, Self-validating, Timely).

## 1. Structure (AAA)

- Arrange: build inputs and fakes. Act: call once. Assert: check observable outcome.
- One behavior per test; name states the behavior: `rejects_expired_token`, not `test_auth_2`.
- Keep tests independent and order-free; no shared mutable fixtures between cases.

## 2. Doubles

- Prefer fakes (in-memory DB, fake clock) over mocks; wrap wall-clock, randomness, and I/O behind injectable seams.
- Mock at module boundaries, not internals; assert outcomes, not call sequences, unless the sequence is the contract.
- Never hit real network, real time, or production services from unit tests.

## 3. Data

- Build minimal valid fixtures per test (factories/builders over shared dumps).
- Cover: happy path, empty, boundary, invalid input, unauthorized, conflict, and timeout where applicable.
- Keep golden/snapshot files small and reviewed; snapshot churn without behavior change is a smell.

## 4. Layout

- Mirror `src/` under the project's existing test tree; use the runner already present.
- If no runner exists, ask before adding one — do not invent tooling silently.
