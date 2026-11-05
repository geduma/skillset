---
name: skillset-code
description: Skillset code phase - style, backend, frontend, design system and TDD implementation after an approved spec
---

# Skillset Code

## Global rules (always apply)

1. **Chat language vs artifact language.** Reply in the user's chat language. Every artifact you create — source code, identifiers, inline comments, docs, commit messages, PR descriptions — must be written in English only. Never write comments or docs in Spanish or any other chat language, and never mix languages inside one deliverable.
2. **Load skills before acting.** Load the exact `skillset-*` ID through the host adapter. Do not work from memory and do not skip a skill because a repo path is missing.
3. **No git without explicit permission.** Never commit, create a branch, push, open a PR, or merge. This phase never touches git history.
4. **Route, never absorb.** If the task exceeds this phase, escalate to `skillset`; never run security audits, formal reviews, or docs phases here.
5. **Status block.** Open every message with `Phase X/Y · [active skill] · Gate: pending/approved · Artifacts: <paths or —>`.

Routing conflicts: load the `skillset-dev-orchestrator` skill (`references/routing.md`); do not guess.

## Affinity

- `skillset-dev-style` — naming, structure, lint/typecheck/format, logging, validation scaffolding. Gate: project gates pass.
- `skillset-dev-backend` — REST resources, methods, status codes, errors, pagination, versioning, OpenAPI contracts. Gate: contracts consistent.
- `skillset-dev-frontend` — components, state split, fetching, forms, routing, rendering perf, loading/error/empty states. Gate: tests + a11y pass.
- `skillset-design-system` — tokens, hierarchy, visual identity, craft self-checks. Gate: no generic output.
- `skillset-dev-tdd` — red-green-refactor while implementing logic or fixing behavior. Gate: failing test first, suite green.
- `skillset-dev-incremental` — thin vertical slices inside a code phase (implement → test → verify). Not a standalone phase.

## Workflow (mandatory)

1. **Load skill** — load the owning `skillset-*` ID through the host adapter before editing. Read its `references/`. Never read the source repo's `skills/` tree; that path only exists in the source repo.
2. **Confirm the handoff and approval** — the approved `spec.md`, `plan.md`, and `tasks.md` must exist, and `plan.md` must show `Status: approved` (or the handoff must state `Approved: yes` with the date). If approval is missing, stop and escalate to `skillset`; do not start coding.
3. **Implement in thin slices** — one behavior at a time. Use `skillset-dev-tdd` for logic and bug behavior. Keep each slice compiling and tested before the next.
4. **Run gates** — project lint, typecheck/format, and the relevant test command. Report exact commands and results.
5. **Close the phase** — list files touched, gates passed, and remaining risks; request explicit approval for the next phase. Never ask approval without presenting the diff/output.

## Rules

- Run one phase skill at a time; carry only handoff outputs.
- **No implementation without an approved plan.** The initial step is always planning; this agent only runs after the user explicitly approved execution.
- Never commit or push; never skip tests.
- If a gate command is not permitted by the host adapter, request permission instead of bypassing it.
- If the required skill cannot be loaded, stop and report the missing skill ID instead of improvising.

## Host adapter (generic)

- **Load a skill:** read the installed `SKILL.md` for the exact ID under the host's skills directory (for example `.agents/skills/<id>/SKILL.md`).
- **Delegate:** switch the active role to the phase agent file. If the host supports subagents, use that mechanism.
- **Enforcement:** prompt-only. The planning gate and write-path limits are mandatory instructions, not runtime guarantees.
- **If a phase agent is unavailable:** run the phase sequentially; do not skip it.
