---
name: skillset-dev-feature
description: Use this when creating a new feature, endpoint, user story, or functional change from a vague or clear request. Use when the user says new feature, add functionality, plan implementation, write spec, break down tasks, clarify requirements, or estimate scope. Do not use for bug fixes or vague pre-spec idea shaping - use skillset-dev-testing or skillset-docs-discovery. Do not use for recording decided docs - use skillset-docs-project.
license: MIT
allowed-tools: Read Edit Write Glob Grep
metadata:
  version: 1.3.0
---

# Feature Spec and Plan

Turns a feature request into an approved spec, technical plan, and ordered tasks with a mandatory docs-sync task, before any code.

This skill defines process only. It writes planning artifacts under `docs/` and never implements the feature itself.

## When to use this

- The user asks for a new feature, endpoint, flow, or functional change.
- Requirements are vague, incomplete, or need scoping and use-case coverage.
- An estimate, breakdown, or implementation plan is needed before coding.

## Non-negotiable principles

1. **No implementation without approved spec.** Spec, plan, and tasks are reviewed before code. See `references/validation-gates.md`.
2. **Read-only first.** Inventory code and docs before writing anything. See `references/spec-template.md`.
3. **Ask for what varies.** Stack, scope, and constraints are asked, never silently defaulted. See `references/spec-template.md`.
4. **Light by default.** Two-page spec, one clarify round; scale only on blocker risk. See `references/validation-gates.md`.
5. **Docs stay in sync.** Every plan ends with a task updating existing project docs. See `references/docs-sync.md`.
6. **Confirm before overwriting plans.** Existing incomplete plans need explicit approval. See `references/task-breakdown.md`.

## Workflow (summary)

1. **Inventory** — check `docs/`, agent files, README, changelog, and codebase patterns per `references/docs-sync.md` and `references/spec-template.md`.
2. **Specify** — write `what` and `why` with stories, scope, and edge cases per `references/spec-template.md`.
3. **Plan and validate** — write `how` plus read-only consistency check per `references/validation-gates.md`.
4. **Break down and gate** — ordered tasks, checkpoints, and mandatory docs-sync task per `references/task-breakdown.md` and `references/docs-sync.md`. Stop for human approval before implementation.

See `references/spec-template.md`, `references/validation-gates.md`, `references/task-breakdown.md`, `references/docs-sync.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
