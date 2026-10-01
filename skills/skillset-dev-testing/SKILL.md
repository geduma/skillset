---
name: skillset-dev-testing
description: Use this when planning test strategy, writing or fixing unit integration contract or end-to-end tests, choosing what to mock, fighting flaky or slow tests, reproducing a bug, or setting up test naming and layout. Also use when the user says test this, add coverage, debug this failure, or why is this test flaky. Do not use for lint, typecheck, or formatting gates - use skillset-dev-style. Do not use for security audits - use skillset-sec-audit.
license: MIT
allowed-tools: Read Edit Write Glob Grep Shell
metadata:
  version: 1.2.0
---

# Testing and Debugging

Builds a balanced, deterministic test portfolio in any stack and turns bug reports into regression tests.

This skill is project-agnostic. It uses the project's existing runner and layout and never switches frameworks or hardcodes paths.

## When to use this

- The user asks for a test plan, more coverage, or a test for a specific behavior.
- Tests are slow, flaky, or fail non-deterministically.
- A bug needs reproduction, bisection, and a regression test.
- A diff needs a testing pass before merge.

## Non-negotiable principles

1. **Pyramid first.** Many fast unit tests, fewer service tests, few E2E tests. See `references/strategy-pyramid.md`.
2. **Deterministic always.** No wall-clock, random, or network dependence in unit tests. See `references/writing-tests.md`.
3. **No fix without root cause.** Reproduce, trace, and confirm before changing code; failing test first, then the fix. See `references/debugging.md` and `references/red-flags.md`.
4. **Test behavior, not implementation.** Refactors stay green. See `references/writing-tests.md`.
5. **Quarantine flakes, do not ignore them.** Track, fix, or delete — never leave red. See `references/suite-hygiene.md`.
6. **Confirm before mass test rewrites.** New runner, snapshot churn, or fixture migration needs approval.

## Workflow (summary)

1. **Plan the mix** — assign each behavior to unit, contract/service, or E2E per `references/strategy-pyramid.md`.
2. **Write the test** — Arrange/Act/Assert, hermetic doubles per `references/writing-tests.md`.
3. **Debug the failure** — investigate root cause, test one hypothesis, fix, lock with regression test per `references/debugging.md` and `references/red-flags.md`.
4. **Keep the suite green** — de-flake, speed up, enforce in CI per `references/suite-hygiene.md`.

See `references/strategy-pyramid.md`, `references/writing-tests.md`, `references/debugging.md`, `references/red-flags.md`, `references/suite-hygiene.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
