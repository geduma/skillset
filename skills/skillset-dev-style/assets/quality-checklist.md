# Quality-gate checklist (adapt to the project's stack)

Copy this into the task plan, not into the repo. Check each item or record why it does not apply.

- [ ] Linter runs on changed code, zero errors. Suppressions are line-scoped with a reason.
- [ ] Strict checker runs at its strictest viable setting, zero errors.
- [ ] Formatter applied. No logic mixed into format-only diffs.
- [ ] Tests for changed behavior exist and pass (`test` script, not only `watch`).
- [ ] Config changes include `*.example.*` updates, no real secrets committed.
- [ ] Logs use the structured logger. No raw console output on hot paths.
- [ ] Inputs validated at the boundary. Errors follow the project's existing shape.
- [ ] Timeouts, retries, and caps are named constants.
