# Definition of Done

Project-wide standing bar that every change clears, contrasted with per-task acceptance criteria. A task is not done until both its acceptance criteria *and* this global bar pass.

## Standing bar (every change)

- [ ] Every new behavior has a corresponding test (unit, integration, or E2E per the test pyramid)
- [ ] The full test suite passes, run with the repository's own test command
- [ ] The build succeeds (the repository's build command)
- [ ] Type checking passes, where the stack has one
- [ ] Linting passes (the repository's lint command)
- [ ] No secrets, credentials, or tokens in code, comments, or commit history
- [ ] All artifacts (code, comments, docs, commit messages, PR descriptions) are in English
- [ ] No dead code left behind; orphaned elements listed and approval requested before deletion
- [ ] Change is committed atomically with a descriptive Conventional Commits message
- [ ] Docs in sync: README, AGENTS.md, CHANGELOG, ADR, contracts updated if the change affects them
- [ ] Security baseline checked: input validated at boundaries, auth/authorization in place, dependencies reviewed

## Per-task acceptance criteria

Each task in `tasks.md` carries its own acceptance criteria (Given-When-Then or testable bullets). The Definition of Done is the floor; acceptance criteria are the ceiling for that specific task.

## Relationship to skills

- `skillset-dev-tdd` owns the test requirement (every behavior has a test).
- `skillset-dev-style` owns lint, typecheck, format, and naming gates.
- `skillset-dev-code-review` owns the five-axis review before merge.
- `skillset-sec-appsec` owns the security baseline check.
- `skillset-docs-project` owns docs-in-sync.
- `skillset-git-workflow` owns atomic commits and branch hygiene.

## Language rule

All artifacts produced under this Definition of Done — source code, inline comments, documentation, commit messages, PR descriptions — must be in English only. The chat conversation with the user may be in any language, but deliverables are always English.