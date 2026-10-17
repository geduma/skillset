# Orchestration Patterns

Endorsed multi-skill orchestration patterns and anti-patterns.

## Endorsed patterns

### Sequential pipeline (default)

```
docs-discovery → dev-feature → dev-style + dev-backend/front/design → dev-tdd → dev-code-review → sec-appsec → docs-project → git-workflow
```

One phase skill active at a time. Carry only handoff outputs forward. Stop for explicit approval between phases.

### Spec-first

For any new feature, endpoint, or functional change: `skillset-dev-feature` produces `spec.md + plan.md + tasks.md` before any code phase starts. No code without approved spec.

### Test-first

For any logic change or bug fix: `skillset-dev-tdd` writes a failing test before implementation code. Bug fixes use the Prove-It pattern (reproduction test first).

### Review before merge

`skillset-dev-code-review` reviews across five axes (correctness, readability, architecture, security, performance) before `skillset-git-workflow` opens a PR or commits.

## Anti-patterns

| Anti-pattern | Why it fails |
|---|---|
| Agent absorbs another phase's job | Route, never absorb. One phase skill at a time. |
| Code phase without approved spec | Violates the SDD Iron Law. |
| Skipping tests before security | Tests are the gate before security review. |
| Skipping docs before ship | Docs must be in sync before commit. |
| `skillset-creator` running inside product delivery | Excluded from this workflow; it builds skills, never runs inside delivery. |
| Commits/push/branch without explicit request | Incidental acknowledgments ("proceed", "go on") never authorize git actions. |
| Code comments/docs in chat language | All artifacts in English only; chat may be in any language. |

## Personas (reserved P1)

- `code-reviewer` — Senior Staff Engineer, five-axis review
- `test-engineer` — QA Specialist, test strategy and coverage
- `security-auditor` — Security Engineer, vulnerability detection
- `web-performance-auditor` — Web Performance Engineer, Core Web Vitals

These are second-opinion reviewers, not phase owners.