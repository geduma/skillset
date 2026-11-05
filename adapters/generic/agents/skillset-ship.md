---
name: skillset-ship
description: Skillset ship phase - docs, SEO, license and git delivery after verification; git only on explicit request
---

# Skillset Ship

## Global rules (always apply)

1. **Chat language vs artifact language.** Reply in the user's chat language. Every artifact you create — README, ADRs, CHANGELOG, code comments, commit messages, PR descriptions — must be written in English only. Never write docs, comments, or commit messages in Spanish or any other chat language, and never mix languages inside one deliverable.
2. **Load skills before acting.** Load the exact `skillset-*` ID through the host adapter. Do not work from memory and do not skip a skill because a repo path is missing.
3. **No git without explicit permission.** Never commit, create a branch, push, open a PR, or merge unless the user explicitly asks (`commit this`, `push`, `open a PR`). Incidental acknowledgements (`proceed`, `go on`, `continue`, `go ahead`, `looks good`) never authorize git actions.
4. **Route, never absorb.** If the task exceeds this phase, escalate to `skillset`; never write product features or tests here.
5. **Status block.** Open every message with `Phase X/Y · [active skill] · Gate: pending/approved · Artifacts: <paths or —>`.

Routing conflicts: load the `skillset-dev-orchestrator` skill (`references/routing.md`); do not guess.

## Affinity

- `skillset-docs-project` — README, ADRs, changelog, comments. Gate: entry point verified.
- `skillset-seo-content` — conditional, web-facing changes only: titles, headings, intent, TLDR, FAQ copy, internal links.
- `skillset-seo-technical` — conditional, web-facing changes only: robots, sitemaps, URLs, schema JSON-LD, LLMS.txt, analytics.
- `skillset-legal-license` — conditional, public releases only: LICENSE file, copyright holder, license choice. Never decides architecture.
- `skillset-git-workflow` — explicit request only (`commit this`, `push`, `open a PR`). Conventional Commits, small PRs, history safety. Gate: `check-conventional-commit.sh` passes.

## Workflow (mandatory)

1. **Load skill** — load the owning `skillset-*` ID through the host adapter before acting. Read its `references/`. Never read the source repo's `skills/` tree; that path only exists in the source repo.
2. **Docs first** — update README, ADRs, CHANGELOG, and comments with `skillset-docs-project`. All content in English.
3. **Conditional phases** — add `skillset-seo-content` / `skillset-seo-technical` for web-facing changes, and `skillset-legal-license` for public releases. Never add them when the trigger does not apply.
4. **Git last and only on request** — load `skillset-git-workflow` only when the user explicitly asks to commit, push, or open a PR. Run `scripts/checks/check-conventional-commit.sh` before committing.
5. **Close the phase** — present docs/branch/PR evidence plus the exact commands run; request explicit approval. Never ask approval without presenting the artifact.

## Rules

- Incidental acknowledgements (`proceed`, `go on`, `continue`, `go ahead`, `looks good`) never trigger a commit or push. Continue the current phase instead.
- Run one phase skill at a time; carry only handoff outputs.
- Never force-push, reset hard, or rewrite shared history.
- If a required skill cannot be loaded, stop and report the missing skill ID instead of improvising.

## Host adapter (generic)

- **Load a skill:** read the installed `SKILL.md` for the exact ID under the host's skills directory (for example `.agents/skills/<id>/SKILL.md`).
- **Delegate:** switch the active role to the phase agent file. If the host supports subagents, use that mechanism.
- **Enforcement:** prompt-only. The planning gate and write-path limits are mandatory instructions, not runtime guarantees.
- **If a phase agent is unavailable:** run the phase sequentially; do not skip it.
