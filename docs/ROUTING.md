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
4. Tests failing, flaky, or missing? → `skillset-dev-testing`.
   Bug reports needing reproduce → bisect → fix → regression test also route here
   until `skillset-dev-debugging` exists (P1). `skillset-dev-feature` explicitly
   rejects bugfixing; do not send bugs there.
5. Security question?
   - Preventive hardening checklist → `skillset-sec-appsec`.
   - Formal hunt with `findings.json` + `REPORT.md` → `skillset-sec-audit`.
6. Recording a decided outcome (README, ADR, changelog, comments)? → `skillset-docs-project`.
7. Branch, commit, PR, merge, history? → `skillset-git-workflow`.
8. License file, copyright notice, public release? → `skillset-legal-license`.
9. Search visibility?
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
| `seo-content` vs `seo-technical` | words on the page (titles, headings, FAQ copy, links) | crawlability (robots, sitemaps, canonicals, schema, LLMS.txt, analytics) |
| `legal-license` vs everything | LICENSE file, copyright holder, license choice | all other concerns defer; license skill never decides architecture |

## Pipeline order (orchestrator default)

`docs-discovery` → `dev-feature` → `dev-style` + `dev-backend`/`dev-frontend`/`design-system` → `dev-testing` → `sec-appsec` (`sec-audit` only on request) → `docs-project` → `git-workflow`. Conditional auto-add (not explicit-only): `legal-license` on public release, `seo-*` on web-facing changes. `skillset-creator` is excluded from this workflow.

## Incidental guards (no auto-trigger)

Vague acknowledgements never activate a skill on their own:

- "procede", "sigue", "continua", "haz lo que creas", "adelante" → continue the
  current phase under the already-active skill. Do NOT load `skillset-git-workflow`
  and do NOT `commit`/`push`. Commits require an explicit request per
  `skillset-git-workflow` principle 6 (`commit this`, `push`, session opt-in).
- Code review comments like "se ve bien" → no skill switch, no commit.
- Deploy, ops, or environment questions (Docker, systemd, healthchecks, env parity)
  have no owning skill yet (P1 `skillset-ops-deploy`); do not force them into
  `dev-style` or `git-workflow`. Handle inline and flag as unowned.

## Reserved (P1, not yet created)

- `skillset-dev-debugging`: owns reproduce → bisect → fix → regression test.
  Until then, `skillset-dev-testing` is the interim owner.
- `skillset-ops-deploy`: owns native/docker/service deploys, healthchecks, env parity.
