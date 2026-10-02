# Changelog

All notable changes to this skill pack follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- `install.sh --prune` (opt-in): prunes stale LEGOS symlinks pointing inside the repo whose source no longer exists; leaves manual/third-party links untouched. Portable bash 3.2 (loop + `readlink` + `test -e`, no `find -xtype` / `readlink -f`).
- `install.sh --force` (explicit, `--copy` refresh): replaces managed real files/dirs with fresh copies; without it the skip protector is kept. Warns it may overwrite manual edits, never default.

### Fixed

- SDD spec gate: `agents/skillset.md` exige Fase 1 con `spec.md + plan.md + tasks.md` antes de código y prohíbe pedir aprobación sin artefactos presentados (paths + resumen en chat). `agents/skillset-spec.md` define workflow mandatorio load → inventory → escribir → presentar + gate. Documentado en `docs/features/002-sdd-spec-gate/`.

### Changed

- Progreso visible por fase: `skillset.md`, `skillset-code/verify/ship.md` y `pipeline.md` exigen abrir con `Fase X/Y · [skill] · Gate: pending/approved · Artefactos:` y cerrar con evidencia + aprobación explícita.

## [1.3.0] - 2026-10-01

### Added

- Tool-agnostic `agents/` source of truth: `skillset` (primary) + `skillset-spec`, `skillset-code`, `skillset-verify`, `skillset-ship` (subagents). Every agent sees the full skill library via `docs/ROUTING.md`; affinity is not exclusivity. `skillset-creator` excluded from the workflow.
- `install.sh` / `uninstall.sh` now link both `skills/` and `agents/` into each tool's discovery paths (Claude Code, Codex CLI, OpenCode, shared `.agents`, Cursor, VSCode/Copilot), with `--skills-only` / `--agents-only` and single-item install. Fixed `GROUPS` name collision with bash's reserved group-list variable (renamed to `INSTALL_GROUPS`).

### Changed

- `docs/ROUTING.md` pipeline order: `legal-license` (public release) and `seo-*` (web-facing changes) are conditional auto-add phases, no longer explicit-only. `skillset-creator` marked excluded.
- `skillset-dev-orchestrator` pipeline reference updated to match (conditional phases + creator exclusion).

## [1.2.0] - 2026-10-01

### Fixed

- `skillset-dev-feature` description no longer points at non-existent "systematic debugging"; bugfixing routes to `skillset-dev-testing` (interim owner until P1 `skillset-dev-debugging`).
- `skillset-git-workflow` evals completed to 5 should-trigger + 5 should-NOT-trigger, including 2 incidental cases ("procede", vague continuation) locking principle 6 (no auto-commit/push).

### Changed

- `docs/ROUTING.md`: bugfix ownership clarified (interim `dev-testing`), `dev-feature` vs `dev-testing` overlap row added, new "Incidental guards" section (vague acknowledgements never auto-trigger `git-workflow`), P1 placeholders for `skillset-dev-debugging` / `skillset-ops-deploy`.
- `skillset-dev-orchestrator` pipeline: phase 4 notes interim bugfix ownership, phase 7 requires explicit request (never on incidental "procede"), P1 reservations listed.
- Eval standard fixed across `skillset-creator` (SKILL + `rules.md` + `workflow.md`), `scripts/package_skill.sh`, `scripts/validate-pack.py`: minimum 5+3, 5+5 with incidentals for high-risk skills; validator now enforces >=3 should-NOT-trigger cases.

## [1.1.0] - 2026-09-30

### Added

- New skill `skillset-dev-orchestrator`: end-to-end pipeline `discovery -> feature -> style/backend/frontend -> testing -> appsec -> docs -> git` with routing to `docs/ROUTING.md`.
- Canonical routing matrix in `docs/ROUTING.md`: overlap boundaries and decision tree for all skills.
- Per-skill trigger evals in `skills/<name>/evals/trigger-tests.md` (5 should-trigger, 3 should-not-trigger each).
- Executable harness layer: `scripts/validate-pack.py` (pack-level gates), `scripts/checks/check-conventional-commit.sh`, `scripts/checks/check-adr.sh`.
- `VERSION` file and this changelog; `metadata.version` + `allowed-tools` + `license` frontmatter on every skill.
- `skills/skillset-design-system/references/adapters.md`: how to swap the default Apple HIG foundation for Material, Fluent, or brand tokens while keeping generic craft.
- `skills/skillset-legal-license/references/licenses.md`: verbatim license inventory moved out of `SKILL.md`.

### Changed

- `skillset-legal-license/SKILL.md` trimmed from 51 to ~34 body lines; license list now linked, not inlined.
- `skillset-design-system` de-biased: distinctive craft is primary, Apple HIG is the default foundation adapter rather than a requirement; description now triggers on non-Apple design systems too.
- `scripts/package_skill.sh`: now warns on missing `metadata.version`, `allowed-tools`, `evals/trigger-tests.md`, and missing routing pointer; validates semver format.
- `skillset-creator` rules/workflow/frontmatter docs: new requirements for version, tools, evals, and routing pointer.

### Fixed

- Frontmatter drift across skills (inconsistent keys); all skills now carry the same key set.
