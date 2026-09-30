# Docs Sync (mandatory task)

Source baseline: `agents.md` standard; `skillset-docs-project` README/ADR/changelog; Keep a Changelog 1.1.0; Nygard ADRs.

## 1. Inventory these conventions (project-agnostic)

- `AGENTS.md` at root is canonical agent guidance. `CLAUDE.md` should be a thin `@AGENTS.md` import; never maintain two diverging copies.
- Tool companions if present: `GEMINI.md`, `.github/copilot-instructions.md`, `.cursor/rules`, `.vscode/instructions`. Nested `AGENTS.md` wins for its subtree.
- `README.md` at root is human quickstart. Detail lives in `docs/`, not in README bloat.
- `docs/` is the knowledge base. `AGENTS.md` stays a short router (~100 lines) with "Read when" pointers into `docs/`.
- `docs/adr/NNNN-title.md` plus `docs/adr/README.md` index for structurally significant choices. Immutable once accepted.
- `CHANGELOG.md` Keep a Changelog groups (`Added`, `Changed`, `Fixed`, `Security`) with `## [Unreleased]` at top.
- `CONTRIBUTING.md`, `.env.example`, OpenAPI/contracts, runbooks — only if the feature changes workflow, config, or contracts.

## 2. What the docs-sync task must do

- List only files that exist or are truly required by the change. Do not invent docs.
- Minimal template appended to `tasks.md`:

```
## Task N: Sync project docs
Description: Keep existing docs truthful after this feature.
Acceptance:
- [ ] README.md updated only if setup or usage changed
- [ ] AGENTS.md updated (or confirmed current); CLAUDE.md still imports it, no fork
- [ ] CHANGELOG.md Unreleased entry added under correct group
- [ ] ADR added only if decision is costly to reverse, else skipped with reason
- [ ] Contracts (.env.example, OpenAPI, data model) updated if changed
Verification:
- [ ] Every touched doc command re-tested or marked N/A
- [ ] No stale rule left that the new code violates
```

## 3. Rules

- One source of truth per fact. Complementary files are fine; duplicated content is drift.
- If `docs/` was missing, the task confirms the new `docs/features/NNN-slug/` set is linked from the router.
- If no existing doc needs changes, close the task with a one-line reason, never with fake edits.
- Wide rewrites (many files, published pages) need explicit human approval first.
