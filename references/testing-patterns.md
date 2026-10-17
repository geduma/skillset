# Testing Patterns

Project-agnostic; adapt syntax to the detected stack.

## Test pyramid

```
          ╱╲
         ╱  ╲         E2E Tests (~5%)
        ╱    ╲        Full user flows, real browser
       ╱──────╲
      ╱        ╲      Integration Tests (~15%)
     ╱          ╲     Component interactions, API boundaries
    ╱────────────╲
   ╱              ╲   Unit Tests (~80%)
  ╱                ╲  Pure logic, isolated, milliseconds each
 ╱──────────────────╲
```

- **Unit (~80%):** pure logic, isolated, milliseconds each, no I/O/network/database.
- **Integration (~15%):** API boundaries, component interactions, test DB on localhost.
- **E2E (~5%):** critical user flows only, real browser, multi-machine OK.

## Test sizes (resource model)

| Size | Constraints | Speed | Example |
|------|------------|-------|---------|
| Small | Single process, no I/O, no network, no DB | Milliseconds | Pure function tests |
| Medium | Multi-process OK, localhost only, no external services | Seconds | API tests with test DB |
| Large | Multi-machine OK, external services allowed | Minutes | E2E tests, staging integration |

## Writing good tests

### Test state, not interactions

Assert on outcomes, not internal method calls. State-based tests survive refactors; interaction-based tests break on every implementation change.

### DAMP over DRY

Duplication in tests is acceptable when it makes each test independently understandable. A test should read like a specification.

### Prefer real > fake > stub > mock

Use mocks only when the real implementation is too slow, non-deterministic, or has side effects you can't control.

### Arrange-Act-Assert

Structure every test with clear setup, action, and assertion phases.

### One assertion per concept

Each test verifies one behavior. Name tests descriptively (`it('rejects empty titles', ...)` not `it('test 3', ...)`).

## Test anti-patterns

| Anti-Pattern | Fix |
|---|---|
| Testing implementation details | Test inputs and outputs |
| Flaky tests (timing, order-dependent) | Deterministic assertions, isolated state |
| Testing framework code | Only test YOUR code |
| Snapshot abuse | Use sparingly, review every change |
| No test isolation | Each test sets up and tears down its own state |
| Mocking everything | Prefer real > fake > stub > mock |

## Common rationalizations

| Rationalization | Reality |
|---|---|
| "I'll write tests after the code works" | You won't. Tests written after test implementation, not behavior. |
| "This is too simple to test" | Simple code gets complicated. The test documents expected behavior. |
| "Tests slow me down" | Tests slow you now. They speed you up on every future change. |
| "I tested it manually" | Manual testing doesn't persist. |
| "The code is self-explanatory" | Tests ARE the specification. |

## Red flags

- Writing code without corresponding tests
- Tests passing on first run (may not test what you think)
- Bug fixes without reproduction tests
- Tests that don't describe expected behavior
- Skipping tests to make the suite pass