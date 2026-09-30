# Validation Gates

Source baseline: `spec-kit` checklist/analyze; `systematic-debugging` Iron Law; `planning-and-task-breakdown` verification.

## 1. Iron Law

```
NO IMPLEMENTATION WITHOUT APPROVED SPEC + PLAN + TASKS
```

If Phase 2 is not approved, no plan. If plan is not approved, no tasks. If tasks are not approved, no code.

## 2. Checklist (unit tests for requirements)

Generate 5-10 checks against `spec.md` before planning:

- Each story has Given-When-Then acceptance.
- Happy path, empty state, error state, and permission case covered.
- Non-goals explicit; no speculative features.
- Terms unambiguous; no "etc", "fast", "user-friendly" without numbers.
- If a check fails, fix `spec.md` first, never patch it in `plan.md`.

## 3. Plan (`docs/features/NNN-slug/plan.md`)

- Stack, architecture deltas, data-model changes, API contracts, test strategy.
- Dependency graph bottom-up: migrations, models, endpoints, clients, UI.
- Constitution check: project principles from `AGENTS.md` pass, or document a justified exception.
- Alternatives in one line each. No essays.

## 4. Analyze (read-only, before tasks)

- Every plan item traces to a requirement; every requirement has a plan item.
- No contradiction between spec, plan, and existing ADRs.
- Report gaps only; do not edit. Loop back to the owning artifact.

## 5. Red flags — stop and return to spec

- "Figure it out while coding", "tasks are obvious", "skip acceptance".
- Proposing files or code before spec approval.
- 3+ clarify loops on the same point means the scope is too large; split it.

| Excuse | Reality |
|---|---|
| "Simple feature, no spec needed" | Simple features drift fastest; light spec is 10 minutes. |
| "Plan while implementing" | That is typing, not planning; rework costs more. |
| "Fix the spec later" | Later means after wrong code ships. |
