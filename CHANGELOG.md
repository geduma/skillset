# Changelog

All notable changes to this skill pack follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

## [1.5.0] - 2026-11-04

### Added

- Host-agnostic agent architecture: `agents/*.md` is now the tool-neutral source of truth, and `adapters/<host>/agents/*.md` is generated from it by `scripts/build-adapters.py`. Supported adapters: `opencode`, `claude`, `codex`, `generic`.
- `install.sh --tool <host>` and `uninstall.sh --tool <host>`: install or remove one host adapter (`opencode|claude|codex|generic|all`). `--tool all` remains the default.
- `docs/ADAPTERS.md`: host matrix, invocation syntax, and enforcement differences.
- Validator gates for canonical agent neutrality, adapter presence, adapter drift, and installer coverage.

### Changed

- Agent bodies no longer reference host-specific APIs (`subagent`, `permissions`, `skill` tool, `mode`). The same workflow, phase map, and planning gate are preserved in every adapter.
- `install.sh` no longer links the OpenCode agent files into every tool's agent directory; each host receives its own adapter.
- `skillset-dev-orchestrator` routing and pipeline docs now say "host adapter" instead of a specific tool name.

### Fixed

- The pack no longer breaks when installed into Claude Code, Codex, Cursor, or Copilot: those hosts receive frontmatter and delegation syntax they understand, with a sequential fallback when native subagents are unavailable.
- OpenCode behavior is unchanged: the same permissions, last-match ordering, and planning gate are preserved in `adapters/opencode/`.

## [1.4.0] - 2026-11-04

### Added

- `install.sh --prune` (opt-in): prunes stale LEGOS symlinks pointing inside the repo whose source no longer exists; leaves manual/third-party links untouched. Portable bash 3.2 (loop + `readlink` + `test -e`, no `find -xtype` / `readlink -f`).
- `install.sh --force` (explicit, `--copy` refresh): replaces managed real files/dirs with fresh copies; without it the skip protector is kept. Warns it may overwrite manual edits, never default.

### Fixed

- SDD spec gate: `agents/skillset.md` requires Phase 1 with `spec.md + plan.md + tasks.md` before any code and forbids approval requests without presented artifacts (paths + summary in chat). `agents/skillset-spec.md` defines a mandatory load → inventory → write → present + gate workflow.
- Planning gate is now an execution rule, not just prose: `skillset` presents `spec.md + plan.md + tasks.md` and the implementation plan, asks "Approve this plan to start implementation?", and stops. It may not edit product files or call `skillset-code` until the user explicitly approves execution. `skillset-spec` records `Status: approved` in `plan.md`; `skillset-code` refuses to start without it. Trivial changes get a lightweight plan plus approval. Mirrored in `skillset-dev-orchestrator` principles, `references/pipeline.md`, and `docs/ROUTING.md`.
- Structural planning gate: the primary `skillset` agent can edit only `docs/**` and has no implementation shell. Product edits must run in `skillset-code` after `plan.md` shows `Status: approved`. The gate is enforced by permissions, not only by prose.
- Permission ordering: `subagent: * deny` and `edit: * deny` were placed after the specific allows. OpenCode uses the last matching rule, so those broad denies blocked every subagent launch and every `docs/**` edit. Broad denies now precede specific allows.
- Frontmatter validity: quoted all 24 `description` values. `skillset-dev-backend`, `skillset-dev-code-review`, and `skillset-dev-feature` had unquoted `: ` and failed YAML parsing, which can make a skill undiscoverable.
- Workflow parity: the primary agent pipeline now matches the canonical order — adds `skillset-dev-tdd` (phase 4) and `skillset-dev-code-review` (phase 5). Bug reports route to `skillset-dev-testing` under `skillset-verify`, never to `skillset-dev-feature`.
- Delegation: all agents now explain how to call the `subagent` tool (target agent ID + complete handoff), require one phase at a time, and stop with a clear report when the tool or a target agent is unavailable (the primary does not implement inline). `skillset-verify` gains `dev-code-review` ownership.
- Skill loading: agents load skills by exact ID with the `skill` tool instead of reading source-repo paths (`skills/*/SKILL.md`, `docs/ROUTING.md`) that do not exist in target projects.
- Artifact language: the global language rule is embedded in all five agents — chat in the user's language, every artifact (code, comments, docs, commit messages, PR descriptions) in English only.
- Permissions: `skillset-code` rules reordered (broad `ask` first, specific allows after) and made stack-agnostic; `git commit/push/merge/rebase` and `gh pr` denied. `skillset-verify` can edit source for security fixes and denies git delivery. `skillset-ship` allows read-only git, asks for delivery, and denies force-push/hard-reset.

### Changed

- Documentation language rule: every Markdown file skillset generates in any project is always English; chat explanations follow the user's conversation language. Clarified in `README.md`; fixed mixed-language entries in this changelog.
- Visible per-phase progress: `skillset.md`, `skillset-code/verify/ship.md` and `pipeline.md` require opening with `Phase X/Y · [skill] · Gate: pending/approved · Artifacts:` and closing with evidence + explicit approval.
- Routing matrix is now bundled at `skills/skillset-dev-orchestrator/references/routing.md` so installed packs can route without the source repo. `docs/ROUTING.md` remains the repo mirror; `scripts/validate-pack.py` fails if the two drift.
- `scripts/validate-pack.py` now validates `agents/*.md` (frontmatter, permission rules, global rules, routing pointers, subagent IDs, and pipeline coverage) in addition to skills.

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
- `skillset-git-workflow` evals completed to 5 should-trigger + 5 should-NOT-trigger, including 2 incidental cases ("proceed", vague continuation) locking principle 6 (no auto-commit/push).

### Changed

- `docs/ROUTING.md`: bugfix ownership clarified (interim `dev-testing`), `dev-feature` vs `dev-testing` overlap row added, new "Incidental guards" section (vague acknowledgements never auto-trigger `git-workflow`), P1 placeholders for `skillset-dev-debugging` / `skillset-ops-deploy`.
- `skillset-dev-orchestrator` pipeline: phase 4 notes interim bugfix ownership, phase 7 requires explicit request (never on incidental "proceed"), P1 reservations listed.
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
