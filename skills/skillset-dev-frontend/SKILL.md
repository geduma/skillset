---
name: skillset-dev-frontend
description: "Use this when building, refactoring, or reviewing frontend application code in any framework - components, client state, server state, data fetching, forms, routing, rendering CSR SSR RSC, loading error empty states, or frontend performance and correctness, or when user says fix UI bug, wire API to view, optimize re-renders, add form validation. Do not use for visual craft, tokens, or Apple-style look - use skillset-design-system. Do not use for generic naming, lint, or formatting gates - use skillset-dev-style."
---

# Frontend Engineering

Builds correct, fast, accessible frontend application logic in any stack without switching frameworks.

This skill is framework-agnostic. It detects the current framework and adapts patterns to it, and never hardcodes project paths or package names.

## When to use this

- The user builds, refactors, or reviews components, views, state, fetching, forms, or routing.
- The user reports a UI bug, missing state, waterfall, re-render storm, or broken form flow.
- The user asks to wire an API to a view or to optimize frontend performance.
- A diff needs a frontend-correctness pass before release.

## Non-negotiable principles

1. **Never switch the stack.** Use the detected framework and router. See `references/components-state.md`.
2. **Never assume what varies.** If scope, data source, auth model, or target devices are unclear, ask. See `references/forms-data.md`.
3. **Separate server and client state.** Remote data is cached; UI state stays local. See `references/components-state.md`.
4. **Complete state model.** Every view handles loading, error, empty, and success. See `references/forms-data.md`.
5. **Fast by default.** Budgets for bundle, waterfall, and re-renders hold on every change. See `references/rendering-performance.md`.
6. **Accessible and verified.** Keyboard, focus, labels, and reduced motion pass; report as `file:line`. See `references/a11y-testing.md`.
7. **Confirm before wide rewrites.** Many files, store migration, or router change: summarize first, wait for approval.

## Workflow (summary)

1. **Detect the stack** — manifest, router, data library, existing components and tests. Ask only for what you cannot infer.
2. **Apply architecture and states** — components, state split, fetching, forms per `references/components-state.md` and `references/forms-data.md`.
3. **Harden rendering and access** — performance plus security-compatible patterns per `references/rendering-performance.md` and `references/frontend-security.md`.
4. **Verify** — run the project's own tests, typecheck, and lint; check a11y and states per `references/a11y-testing.md`. Report what ran and what failed.

See `references/components-state.md`, `references/rendering-performance.md`, `references/forms-data.md`, `references/a11y-testing.md`, `references/frontend-security.md` for detail.
