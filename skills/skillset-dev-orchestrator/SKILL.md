---
name: skillset-dev-orchestrator
description: "Use this when a task spans multiple phases of software delivery - vague idea to spec to code to tests to security to docs to commit - or when the user says plan this end to end, run the full pipeline, coordinate skills, or asks which skill should handle this. Routes each phase to the right skill per its bundled routing matrix (`references/routing.md`) and never implements a phase itself."
license: MIT
allowed-tools: Read Glob Grep
metadata:
  version: 1.5.0
---

# Dev Orchestrator

Routes multi-phase work through the pack in pipeline order, one skill per phase, stopping for approval between phases.

This skill writes no product code. It produces a phase plan, delegates each phase to the owning skill, and records handoffs.

## When to use this

- The request spans idea, spec, code, tests, security, docs, or commits.
- The user asks which skill applies or how to sequence them.
- Two skills could match and `references/routing.md` must break the tie.

## Non-negotiable principles

1. **Route, never absorb.** Each phase runs under its owning skill; this skill holds only the sequence. See `references/pipeline.md`.
2. **Tiebreak via routing matrix.** Ambiguous tasks resolve per `references/routing.md`, never by guessing.
3. **Planning gate before implementation.** The first response to any change request is a plan, not an edit. Present `spec.md + plan.md + tasks.md` and the implementation plan in chat, then stop for explicit approval to execute. Do not edit product files or start a code phase before that approval. Incidental acknowledgements ("proceed", "go on", "continue", "go ahead", "looks good") do not count as approval to execute.
4. **Gate between phases.** Spec approval before code, green tests before security pass, docs before commit. See `references/pipeline.md`.
5. **Confirm before phase jumps.** Skipping discovery, tests, or docs needs explicit approval.
6. **No git without explicit permission.** No agent in this pack may commit, create a branch, push, open a PR, or merge without an explicit user request (`commit this`, `push`, `open a PR`). Incidental acknowledgments ("proceed", "go on", "continue", "go ahead") never authorize git actions. See `skillset-git-workflow` principle 6 and `references/routing.md` incidental guards.
7. **Language rule: chat in user language, artifacts always in English.** Respond in the chat in the same language the user writes (e.g. Spanish if they write in Spanish). Every created artifact — source code, inline comments, docs, commit messages, PR descriptions — must be in English only. Never write code comments or documentation in the user's chat language, and never mix languages inside deliverables.

## Workflow (summary)

1. **Classify** — map the request to pipeline phases per `references/pipeline.md` and `references/routing.md`.
2. **Sequence** — emit ordered phases with owning skill per phase; stop for approval.
   - Spec: `skillset-dev-feature` (four gated phases: Specify → Plan → Tasks → Implement)
   - Style: `skillset-dev-style`
   - Backend/Frontend/Visual: `skillset-dev-backend` / `skillset-dev-frontend` / `skillset-design-system`
   - Tests (TDD): `skillset-dev-tdd`
   - Review: `skillset-dev-code-review`
   - Security: `skillset-sec-appsec` (or `skillset-sec-audit` on explicit audit request)
   - Docs: `skillset-docs-project`
   - Ship: `skillset-git-workflow` (explicit request only)
   - Incremental discipline (`skillset-dev-incremental`) runs inside code phases, not as a standalone phase.
3. **Delegate** — run each phase under its skill, carrying only its handoff outputs. Agent map: Spec → `skillset-spec`; Code/Tests → `skillset-code`; Review/Security → `skillset-verify`; Docs/Ship → `skillset-ship`. Load the owning skill by ID through the host adapter; never read `skills/*/SKILL.md` from a target project.
4. **Close** — verify each phase's gate via `scripts/validate-pack.py` where applicable; hand to `skillset-git-workflow` last.

See `references/pipeline.md` for detail. Routing conflicts: see `references/routing.md`.
