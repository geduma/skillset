# Skill Routing Matrix (canonical)

Read this when two skills could match. The orchestrator (`skillset-dev-orchestrator`) follows it. Each `SKILL.md` links here as tiebreaker; `description` remains the trigger, this doc resolves conflicts.

## Decision tree

1. Vague idea, no spec, scope unclear? → `skillset-docs-discovery`. Writes nothing.
2. Feature/endpoint/story with at least a goal? → `skillset-dev-feature`. Produces spec + plan + tasks, never code.
3. Writing/reviewing code?
   - Naming, structure, lint, typecheck, format, logging, validation scaffolding → `skillset-dev-style`.
   - REST URIs, methods, status codes, errors, pagination, versioning, OpenAPI → `skillset-dev-backend`.
   - Components, state split, fetching, forms, routing, rendering perf → `skillset-dev-frontend`.
   - Pixels, hierarchy, tokens, visual identity → `skillset-design-system`.
4. Writing or fixing tests? → `skillset-dev-tdd` for test-first development (red-green-refactor, Prove-It pattern).
   → `skillset-dev-testing` for test strategy, flaky/slow tests, bug reproduction, debugging, coverage.
   Bug reports needing reproduce → bisect → fix → regression test route to `skillset-dev-testing`
   until `skillset-dev-debugging` exists (P1). `skillset-dev-feature` explicitly
   rejects bugfixing; do not send bugs there.
5. Reviewing code before merge? → `skillset-dev-code-review` for five-axis review (correctness, readability, architecture, security, performance).
6. Security question?
   - Preventive hardening checklist → `skillset-sec-appsec`.
   - Formal hunt with `findings.json` + `REPORT.md` → `skillset-sec-audit`.
6. Recording a decided outcome (README, ADR, changelog, comments)? → `skillset-docs-project`.
7. Implementing a feature incrementally? → `skillset-dev-incremental` for thin vertical slices (implement → test → verify → commit).
8. Branch, commit, PR, merge, history? → `skillset-git-workflow`.
9. License file, copyright notice, public release? → `skillset-legal-license`.
10. Search visibility?
   - Titles, headings, intent, TLDR, FAQ copy, internal links → `skillset-seo-content`.
   - robots.txt, sitemaps, URLs, schema JSON-LD, LLMS.txt, GA4/GSC → `skillset-seo-technical`.
10. New reusable instruction set for this repo? → `skillset-creator`.

## Overlap boundaries

| Pair | A wins when | B wins when |
|---|---|---|
| `dev-style` vs `dev-testing` | lint, typecheck, format, naming, structure, quality gates | test strategy, AAA tests, mocks, flakes, reproduce-bisect-regress |
| `dev-style` vs `git-workflow` | code style inside files | commit message format, branches, PRs, merge strategy, history |
| `dev-frontend` vs `design-system` | components, state, fetching, forms, routing, perf, a11y code | visual hierarchy, spacing, tokens, color world, signature, glass |
| `dev-backend` vs `sec-appsec` | resource modeling, status codes, pagination, versioning, contracts | secrets, auth/session, DB/RLS, input validation, rate limits, headers, TLS |
| `sec-appsec` vs `sec-audit` | preventive baseline, no formal report artifacts | user asked for audit/pentest/hunt, `findings.json` + reports required |
| `docs-discovery` vs `dev-feature` | no committable goal yet, needs interview rounds | goal exists, needs spec + plan + tasks under `docs/` |
| `dev-feature` vs `dev-testing` | new functionality needing spec + plan + tasks | bug report needing reproduce-bisect-fix-regress, even without existing tests |
| `dev-feature` vs `docs-project` | planning a change before code | recording a decided outcome (ADR, changelog, README) |
| `docs-project` vs `git-workflow` | README/ADR/changelog/comments content | commit message shape, PR process |
| `dev-tdd` vs `dev-testing` | write a failing test first, red-green-refactor loop | test strategy, flaky/slow tests, bug reproduction, debugging, coverage |
| `dev-code-review` vs `dev-style` | five-axis pre-merge review (correctness, readability, architecture, security, performance) | lint, typecheck, format, naming, structure, quality gates inside files |
| `dev-incremental` vs `dev-backend`/`dev-frontend` | slicing strategy and increment cycle for multi-file changes | backend API design or frontend component logic within a slice |
| `seo-content` vs `seo-technical` | words on the page (titles, headings, FAQ copy, links) | crawlability (robots, sitemaps, canonicals, schema, LLMS.txt, analytics) |
| `legal-license` vs everything | LICENSE file, copyright holder, license choice | all other concerns defer; license skill never decides architecture |

## Pipeline order (orchestrator default)

`docs-discovery` → `dev-feature` → `dev-style` + `dev-backend`/`dev-frontend`/`design-system` → `dev-tdd` → `dev-code-review` → `sec-appsec` (`sec-audit` only on request) → `docs-project` → `git-workflow`. Conditional auto-add (not explicit-only): `legal-license` on public release, `seo-*` on web-facing changes. `skillset-creator` is excluded from this workflow. `skillset-dev-incremental` runs inside code phases as the implementation discipline (not a standalone pipeline phase).

## Incidental guards (no auto-trigger)

Vague acknowledgements never activate a skill on their own:

- "proceed", "go on", "continue", "do what you think is best", "go ahead" → continue the
  current phase under the already-active skill. Do NOT load `skillset-git-workflow`
  and do NOT `commit`/`push`. Commits require an explicit request per
  `skillset-git-workflow` principle 6 (`commit this`, `push`, session opt-in).
- Code review comments like "looks good" → no skill switch, no commit.
- Deploy, ops, or environment questions (Docker, systemd, healthchecks, env parity)
  have no owning skill yet (P1 `skillset-ops-deploy`); do not force them into
  `dev-style` or `git-workflow`. Handle inline and flag as unowned.

## Reserved (P1, not yet created)

- `skillset-dev-debugging`: owns reproduce → bisect → fix → regression test.
  Until then, `skillset-dev-testing` is the interim owner.
- `skillset-ops-deploy`: owns native/docker/service deploys, healthchecks, env parity.

## Global Operating Rules (apply to every skill in the pack)

| Rule | Requirement |
|------|-------------|
| Chat language | Respond to the user in the same language they write (Spanish, English, etc.). |
| Artifact language | All created artifacts — source code, inline comments, docs, commit messages, PR descriptions — must be in English only. Never write code comments or documentation in the user's chat language. Never mix languages inside a deliverable. |
| No git without permission | No commit, branch, push, or PR without an explicit user request. Incidental acknowledgments ("proceed", "go on", "continue", "go ahead") never authorize git actions. |
