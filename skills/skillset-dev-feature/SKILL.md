---
name: skillset-dev-feature
description: Turns a feature request into an approved spec, technical plan, and ordered tasks with a mandatory docs-sync task, before any code. Use when the user asks for a new feature, endpoint, flow, or functional change; when requirements are vague, incomplete, or need scoping and use-case coverage; or when an estimate, breakdown, or implementation plan is needed before coding. Follows a four-phase gated workflow: Specify → Plan → Tasks → Implement. Do not use for bug fixes or vague pre-spec idea shaping - use skillset-dev-testing or skillset-docs-discovery. Do not use for recording decided docs - use skillset-docs-project.
license: MIT
allowed-tools: Read Edit Write Glob Grep
metadata:
  version: 1.4.0
---

# Feature Spec and Plan

Turns a feature request into an approved spec, technical plan, and ordered tasks with a mandatory docs-sync task, before any code.

This skill defines process only. It writes planning artifacts under `docs/features/NNN-slug/` and never implements the feature itself.

## When to use this

- The user asks for a new feature, endpoint, flow, or functional change.
- Requirements are vague, incomplete, or need scoping and use-case coverage.
- An estimate, breakdown, or implementation plan is needed before coding.
- The request bundles several independently testable capabilities (triggers Phase 0 Scope Check).

## Non-negotiable principles

1. **No implementation without approved spec + plan + tasks.** Code starts only after all three are approved. See `references/validation-gates.md`.
2. **Four gated phases.** Specify → Plan → Tasks → Implement. The turn ends after saving `spec.md`; human approval arrives in a later turn before `plan.md` is written. See `references/spec-template.md` section "Stop after writing the spec".
3. **Phase 0 Scope Check (multi-capability).** When one request bundles several independently testable capabilities, propose a capability map (module ids, dependency direction, build order) before writing any spec. Approve the map first, then recurse per module in dependency order. See `references/spec-template.md` phase 0.
4. **Read-only first.** Inventory code and docs before writing anything. See `references/docs-sync.md` and `references/spec-template.md`.
5. **Ask for what varies.** Stack, scope, and constraints are asked, never silently defaulted. Mark every inference as `[ASSUMPTION]`. See `references/spec-template.md`.
6. **Light by default.** Two-page spec, one clarify round; scale only on blocker risk. See `references/validation-gates.md`.
7. **Docs stay in sync.** Every plan ends with a task updating existing project docs. See `references/docs-sync.md`.
8. **Confirm before overwriting plans.** Existing incomplete plans need explicit approval. See `references/task-breakdown.md`.
9. **Language rule.** Respond to the user in their chat language. All created artifacts — `spec.md`, `plan.md`, `tasks.md`, code, comments, docs — must be in English only. Never write planning artifacts in the user's chat language.

## Workflow (summary)

### Phase 0: Scope Check (only for multi-capability requests)

Most requests describe one capability. Skip this phase and go straight to Specify.

**Detection.** Decompose before specifying when a single requirement bundles several independently testable capabilities:

- The requirement names distinct capabilities with their own consumers or data (e.g. identity, billing, notifications, reporting)
- Acceptance criteria cluster into groups that could ship and be verified separately
- One capability could be cut or replaced without rewriting the others' requirements

**Propose a capability map before writing any spec.** Small and reviewable — a module table plus a build order:

```markdown
# Capability Map: [Initiative Name]

| Module id | Responsibility | Depends on |
|---|---|---|
| identity | Accounts, sessions, SSO | — |
| billing | Plans, invoices, payments | identity |
| notifications | Email and webhook fan-out | identity |
| reporting | Usage dashboards | billing, notifications |

Build order: identity → billing, notifications → reporting
```

- Stable module ids: kebab-case, chosen once, never renamed mid-initiative.
- Dependency direction, no cycles. If two modules each need the other, they are one module.
- The human reviews module boundaries, dependency direction, and build order before any module spec is written.
- Save the approved map at the project root; each module spec named by module id (`SPEC-identity.md`, `SPEC-billing.md`). The map is the index of what exists.

Then recurse: Specify → Plan → Tasks → Implement for each module in dependency order.

### Phase 1: Specify

Start with a high-level vision. Ask clarifying questions until requirements are concrete.

**Surface assumptions immediately.**

```
ASSUMPTIONS I'M MAKING:
1. [assumption about requirements]
2. [assumption about architecture]
3. [assumption about scope]
→ Correct me now or I'll proceed with these.
```

**Write `docs/features/NNN-slug/spec.md` covering six core areas:**

1. **Objective** — What are we building and why? Who is the user? What does success look like?
2. **Commands** — Full executable commands with flags (build, test, lint, dev).
3. **Project Structure** — Where source, tests, and docs live.
4. **Code Style** — One real code snippet showing style beats three paragraphs of description. Naming conventions, formatting rules, examples of good output.
5. **Testing Strategy** — Framework, test locations, coverage expectations, test levels (unit/integration/E2E).
6. **Boundaries** — Three-tier system:
   - **Always do:** Run tests before commits, follow naming conventions, validate inputs
   - **Ask first:** Database schema changes, adding dependencies, changing CI config
   - **Never do:** Commit secrets, edit vendor directories, remove failing tests without approval

**Spec template:**

```markdown
# Spec: [Project/Feature Name]

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

**Stop after writing the spec (CRITICAL).** Once the spec is saved:

1. Summarize it in chat: Status, Context, Non-goals, User Stories + Acceptance, Open Questions.
2. Ask the human to approve it or request changes.
3. **STOP YOUR TURN IMMEDIATELY.** Do NOT start Phase 2, invoke `planning-and-task-breakdown`, or write code in this turn. Planning starts only after the human approves the spec in a later turn.

### Phase 2: Plan

With the validated spec, generate a technical implementation plan:

1. Identify major components and their dependencies
2. Determine implementation order (what must be built first)
3. Note risks and mitigation strategies
4. Identify what can be built in parallel vs sequential
5. Define verification checkpoints between phases

Save to `docs/features/NNN-slug/plan.md`. The plan should be reviewable: the human reads it and says "yes" or "change X."

Follow `skillset-planning-and-task-breakdown` for dependency-graph mapping and vertical-slicing mechanics; if bullets diverge, that skill takes precedence.

### Phase 3: Tasks

Break the plan into discrete, implementable tasks:

- Each task completable in a single focused session
- Each task has explicit acceptance criteria
- Each task includes a verification step (test, build, manual check)
- Tasks ordered by dependency, not perceived importance
- No task touches more than ~5 files

Save to `docs/features/NNN-slug/tasks.md`.

**Task template:**

```markdown
## Task N: <short title> [P if parallelizable]
Description: <one paragraph outcome>
Acceptance:
- [ ] <testable condition>
Verification:
- [ ] <focused test + build command>
Dependencies: <None | Task N>
Files likely touched:
- `path/to/file`
Estimated scope: <S | M | L>
```

### Phase 4: Implement

Execute tasks one at a time following `skillset-dev-incremental` and `skillset-dev-tdd`. Use `skillset-dev-context-engineering` to load the right spec sections and source files at each step rather than flooding the agent with the entire spec. Downstream code skills own implementation; this skill stops at the gate.

## Keeping the Spec Alive

The spec is a living document:

- Update when decisions change (update spec first, then implement)
- Update when scope changes (features added or cut reflected in spec)
- Commit the spec alongside the code
- Reference the spec in PRs (link back to the spec section each PR implements)

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "This is simple, I don't need a spec" | Simple tasks don't need long specs, but they still need acceptance criteria. A two-line spec is fine. |
| "I'll write the spec after I code it" | That's documentation, not specification. The spec's value is forcing clarity before code. |
| "The spec will slow us down" | A 15-minute spec prevents hours of rework. |
| "Requirements will change anyway" | That's why the spec is a living document. An outdated spec is still better than no spec. |
| "The user knows what they want" | Even clear requests have implicit assumptions. The spec surfaces them. |
| "I'll decompose during planning" | Planning slices tasks within a spec. Module boundaries and dependency direction must be decided before the spec is written, not after. |

## Red Flags

- Starting to write code without any written requirements
- Asking "should I just start building?" before clarifying what "done" means
- Implementing features not mentioned in any spec or task list
- Making architectural decisions without documenting them
- Skipping the spec because "it's obvious what to build"
- Writing the spec and starting the plan or code in the same turn
- One spec whose requirements span several independently testable capabilities without an approved capability map

## Verification

Before proceeding to implementation, confirm:

- [ ] The spec covers all six core areas (Objective, Commands, Project Structure, Code Style, Testing Strategy, Boundaries)
- [ ] The human has reviewed and approved the spec in chat
- [ ] The turn ended after saving the spec; approval came in a later turn
- [ ] Success criteria are specific and testable
- [ ] Boundaries (Always / Ask First / Never) are defined
- [ ] The spec is saved to `docs/features/NNN-slug/spec.md`
- [ ] If the request bundles several independently testable capabilities, a capability map (module ids, dependency direction, build order) was approved before any module spec was written
- [ ] All planning artifacts are in English (regardless of chat language)

See `references/spec-template.md`, `references/validation-gates.md`, `references/task-breakdown.md`, `references/docs-sync.md` for detail. Routing conflicts: see `docs/ROUTING.md`.