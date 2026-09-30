# Strategy Pyramid

Source baseline: Martin Fowler Test Pyramid (martinfowler.com/bliki/TestPyramid.html, after Mike Cohn 2009); Google Testing Blog on E2E costs.

## 1. The mix

- Unit (base, most): single module, in-memory, milliseconds. Business rules live here.
- Service/contract (middle): module plus real adapter seam (API layer, DB, queue) or provider contract. No browser.
- E2E/UI (tip, fewest): critical user journeys only through the real UI stack.

## 2. Why this shape

- E2E tests are brittle, slow, and costly to record and maintain; UI changes break them in bulk.
- A high-level failure means two bugs: one in code, one missing lower-level test. Replicate every E2E-caught bug with a unit test so it stays dead.
- Exception: if high-level tests are fast, reliable, and cheap to change, the pyramid flattens — but that must be measured, not assumed.

## 3. Assignment rules

- New business rule: unit test first.
- Cross-module wiring: service/contract test.
- Login-to-checkout happy path: E2E. Edge cases of the same flow: unit, not more E2E.
- Third-party services: contract test against a fake or dedicated test instance, never production.

## 4. Naming the layers

- Agree per-team names (unit/integration/contract/E2E) once; the split of scope matters more than the labels.
