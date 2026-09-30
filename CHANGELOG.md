# Changelog

All notable changes to this skill pack follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

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
