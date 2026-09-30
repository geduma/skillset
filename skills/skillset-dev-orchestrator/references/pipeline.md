# Pipeline

## 1. Phase map

| # | Phase | Owning skill | Input | Output | Gate |
|---|---|---|---|---|---|
| 0 | Discovery | `skillset-docs-discovery` | vague idea | committable decisions (conversation only) | user confirms scope |
| 1 | Spec | `skillset-dev-feature` | decisions | spec + plan + tasks under `docs/` | spec approved, no code yet |
| 2 | Style | `skillset-dev-style` | plan | named, placed, gated code conventions | lint/typecheck/format pass |
| 3a | Backend | `skillset-dev-backend` | plan | resources, methods, errors, contracts | OpenAPI consistent |
| 3b | Frontend | `skillset-dev-frontend` | plan | components, state, forms, fetching | tests + a11y pass |
| 3c | Visual | `skillset-design-system` | plan | tokens, hierarchy, components styling | craft self-checks pass |
| 4 | Tests | `skillset-dev-testing` | code | pyramid tests + regression locks | suite green, flakes quarantined |
| 5 | Security | `skillset-sec-appsec` (`sec-audit` only on explicit audit request) | code + tests | hardening notes or `findings.json` + reports | `validate-findings.cjs` passes for audits |
| 6 | Docs | `skillset-docs-project` | code + decisions | README/ADR/changelog/comments | entry point verified |
| 7 | Ship | `skillset-git-workflow` | everything above | branch + Conventional Commits + PR | `check-conventional-commit.sh` passes |

Off-pipeline: `skillset-legal-license` (release prep), `skillset-seo-content` / `skillset-seo-technical` (search visibility), `skillset-creator` (new skill).

## 2. Rules

- Run at most one phase skill at a time; carry only handoff outputs forward.
- Never skip phase 4 before 5, or 6 before 7, without explicit user approval.
- Single-phase requests bypass the pipeline: route directly per `docs/ROUTING.md`.
- Trivial changes (typo, one-line copy) use at most two phases; do not force the full loop.
