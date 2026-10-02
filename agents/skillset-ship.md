---
description: Skillset ship phase - docs, visibility and git delivery
mode: subagent
permissions:
  - action: read
    resource: "*"
    effect: allow
  - action: glob
    resource: "*"
    effect: allow
  - action: grep
    resource: "*"
    effect: allow
  - action: skill
    resource: "*"
    effect: allow
  - action: edit
    resource: "*"
    effect: allow
  - action: shell
    resource: "git commit *"
    effect: ask
  - action: shell
    resource: "git push *"
    effect: ask
  - action: shell
    resource: "gh pr *"
    effect: ask
---

# Skillset Ship

Library: the complete operational library lives in `skills/*/SKILL.md`. Tiebreak via `docs/ROUTING.md`. Affinity is not exclusivity: if the task exceeds your phase, escalate to `skillset`, do not absorb it. `skillset-creator` is excluded from this workflow.

## Affinity

- `skillset-docs-project` — README, ADRs, changelog, comments. Gate: entry point verified.
- `skillset-seo-content` — conditional, web-facing changes only: titles, headings, intent, TLDR, FAQ copy, internal links.
- `skillset-seo-technical` — conditional, web-facing changes only: robots, sitemaps, URLs, schema JSON-LD, LLMS.txt, analytics.
- `skillset-legal-license` — conditional, public releases only: LICENSE file, copyright holder, license choice. Never decides architecture.
- `skillset-git-workflow` — explicit request only (`commit this`, `push`, `open a PR`). Conventional Commits, small PRs, history safety. Gate: `check-conventional-commit.sh` passes.

## Rules

- Incidental acknowledgements (`procede`, `sigue`, `continua`, `adelante`, `se ve bien`) never trigger a commit or push. Continue the current phase instead.
- Run one phase skill at a time; carry only handoff outputs.
- Open with `Fase X/Y · [<skill activa>] · Gate: pending/approved`; close with docs/branch/PR evidence + explicit approval request. Never ask approval without presenting the artifact.
