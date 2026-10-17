# Performance Checklist

Measure-first performance review for frontend and backend.

## Frontend

- [ ] Core Web Vitals targets: LCP < 2.5s, CLS < 0.1, INP < 200ms
- [ ] No N+1 data fetching in components
- [ ] No unnecessary re-renders (memo, useCallback, useMemo where needed)
- [ ] Images optimized (correct format, size, alt text, lazy loading)
- [ ] Bundle size budget respected; no large unused dependencies
- [ ] Pagination on list endpoints consumed by frontend

## Backend

- [ ] No N+1 query patterns
- [ ] No unbounded loops or unconstrained data fetching
- [ ] Synchronous operations moved to async where blocking
- [ ] Pagination on every list endpoint (defaults + max limit)
- [ ] Database queries indexed on filtered/sorted columns
- [ ] Large objects not created in hot paths

## General

- [ ] Performance measured before optimizing (no guessing)
- [ ] Profiling data available for claimed regressions
- [ ] Performance tests or budgets in CI if performance is a requirement

## Red flags

- Optimizing without measurement
- N+1 queries or fetches
- Unbounded data fetching without pagination
- Synchronous blocking operations in async contexts
- Bundle bloat from unused dependencies