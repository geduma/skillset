---
name: skillset-dev-orchestrator
description: Use this when a task spans multiple phases of software delivery - vague idea to spec to code to tests to security to docs to commit - or when the user says plan this end to end, run the full pipeline, coordinate skills, or asks which skill should handle this. Routes each phase to the right skill per docs/ROUTING.md and never implements a phase itself.
license: MIT
allowed-tools: Read Glob Grep
metadata:
  version: 1.3.0
---

# Dev Orchestrator

Routes multi-phase work through the pack in pipeline order, one skill per phase, stopping for approval between phases.

This skill writes no product code. It produces a phase plan, delegates each phase to the owning skill, and records handoffs.

## When to use this

- The request spans idea, spec, code, tests, security, docs, or commits.
- The user asks which skill applies or how to sequence them.
- Two skills could match and `docs/ROUTING.md` must break the tie.

## Non-negotiable principles

1. **Route, never absorb.** Each phase runs under its owning skill; this skill holds only the sequence. See `references/pipeline.md`.
2. **Tiebreak via routing matrix.** Ambiguous tasks resolve per `docs/ROUTING.md`, never by guessing.
3. **Gate between phases.** Spec approval before code, green tests before security pass, docs before commit. See `references/pipeline.md`.
4. **Confirm before phase jumps.** Skipping discovery, tests, or docs needs explicit approval.

## Workflow (summary)

1. **Classify** — map the request to pipeline phases per `references/pipeline.md` and `docs/ROUTING.md`.
2. **Sequence** — emit ordered phases with owning skill per phase; stop for approval.
3. **Delegate** — run each phase under its skill, carrying only its handoff outputs.
4. **Close** — verify each phase's gate via `scripts/validate-pack.py` where applicable; hand to `skillset-git-workflow` last.

See `references/pipeline.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
