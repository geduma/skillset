# Pipeline

## 1. Phase map

| # | Phase | Owning skill | Input | Output | Gate |
|---|---|---|---|---|---|
| 0 | Discovery | `skillset-docs-discovery` | vague idea | committable decisions (conversation only) | user confirms scope |
| 1 | Spec | `skillset-dev-feature` | decisions | `docs/features/NNN-slug/spec.md + plan.md + tasks.md`, presented in chat | files exist + spec summary visible in chat + explicit approval, no code yet |
| 2 | Style | `skillset-dev-style` | plan | named, placed, gated code conventions | lint/typecheck/format pass |
| 3a | Backend | `skillset-dev-backend` | plan | resources, methods, errors, contracts | OpenAPI consistent |
| 3b | Frontend | `skillset-dev-frontend` | plan | components, state, forms, fetching | tests + a11y pass |
| 3c | Visual | `skillset-design-system` | plan | tokens, hierarchy, components styling | craft self-checks pass |
| 4 | Tests (TDD) | `skillset-dev-tdd` | code | failing test → minimal implementation → refactor | suite green, tests written first |
| 5 | Review | `skillset-dev-code-review` | code + tests | five-axis review + severity labels | Critical/Required resolved |
| 6 | Security | `skillset-sec-appsec` (`sec-audit` only on explicit audit request) | code + tests | hardening notes or `findings.json` + reports | `validate-findings.cjs` passes for audits |
| 7 | Docs | `skillset-docs-project` | code + decisions | README/ADR/changelog/comments | entry point verified |
| 8 | Ship | `skillset-git-workflow` (explicit request only, never on incidental "proceed") | everything above | branch + Conventional Commits + PR | `check-conventional-commit.sh` passes |

Off-pipeline: `skillset-legal-license` (conditional — auto-add on public release), `skillset-seo-content` / `skillset-seo-technical` (conditional — auto-add on web-facing changes). `skillset-creator` is excluded from this workflow (meta-skill for building skills, never runs inside product delivery). `skillset-dev-incremental` runs inside code phases as the implementation discipline (implement → test → verify → commit per slice), not a standalone pipeline phase. Reserved P1: `skillset-dev-debugging`, `skillset-ops-deploy` (see `docs/ROUTING.md`).

## 2. Rules

- Run at most one phase skill at a time; carry only handoff outputs forward.
- Every phase message opens with `Phase X/Y · [<skill>] · Gate: pending/approved · Artifacts: <paths>`; an approval request without presented artifacts is invalid.
- Never skip phase 1 (Spec) for features, phase 4 before 5, or 6 before 7, without explicit user approval.
- Single-phase requests bypass the pipeline: route directly per `docs/ROUTING.md`.
- Trivial changes (typo, one-line copy) use at most two phases; do not force the full loop.
- **No git without explicit permission.** No agent may commit, create a branch, push, open a PR, or merge without an explicit user request. Incidental acknowledgments ("proceed", "go on", "continue", "go ahead") never authorize git actions.
- **Language rule.** Respond to the user in their chat language. All created artifacts — source code, inline comments, docs, commit messages, PR descriptions — must be in English only.