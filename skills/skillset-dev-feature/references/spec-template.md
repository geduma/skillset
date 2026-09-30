# Spec Template (light by default)

Source baseline: GitHub `spec-kit` specify/clarify; BMAD `bmad-prd` Fast path; INVEST stories; Given-When-Then acceptance.

## 1. Inventory first (read-only, no code)

- Check target project: `docs/` exists, else plan to create it.
- Read agent files if present: `AGENTS.md` (canonical), `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, nested `AGENTS.md`. See `references/docs-sync.md`.
- Read `README.md`, `CHANGELOG.md`, `docs/adr/`, existing contracts and data models.
- Note stack, patterns, and constraints actually in use. Never invent them.

## 2. Ask once, in one batch (max 5 questions)

- Goal, primary user, scope in/out, stack constraints, success metric.
- If the user already answered, skip. Mark every inference as `[ASSUMPTION]`.
- One round by default. Second round only for phase-blockers.

## 3. Write `docs/features/NNN-slug/spec.md`

```
# Feature: <name>
Status: Draft | Approved
Context: <problem, user, why now>
Non-goals: <explicitly out of scope>
User stories:
- US-1 <INVEST title>
  Acceptance:
  - Given <ctx> When <action> Then <outcome>
Scope:
- Functional: <numbered F-1, F-2>
- Non-functional: <perf, security, observability>
Edge cases: <empty, error, permission, concurrency>
Open questions: <owner + revisit condition>
Assumptions: [ASSUMPTION] <text>
```

## 4. Rules

- `what` and `why` only. No tables of endpoints, no file lists here.
- Stories are INVEST-small and vertically testable.
- Length scales with stakes: hobby ~2 pages, internal 5-8, launch as long as FRs require; overflow goes to addendum, never padding.
- Functional vs technical separation: tech choices live in `plan.md`, not here.
