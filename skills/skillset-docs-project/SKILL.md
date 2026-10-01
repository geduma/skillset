---
name: skillset-docs-project
description: Use this when writing, reviewing, or fixing project documentation such as README quickstarts, Architecture Decision Records, CHANGELOG entries, CONTRIBUTING guides, or code comments and API docstrings. Also use when the user says document this, write an ADR, update the changelog, or onboard new contributors. Do not use for vague pre-spec idea shaping - use skillset-docs-discovery. Do not use for code style or tests - use skillset-dev-style or skillset-dev-testing. Do not use for commit message format - use skillset-git-workflow.
license: MIT
allowed-tools: Read Write Edit Glob Grep
metadata:
  version: 1.2.0
---

# Project Docs

Keeps README, ADRs, changelog, and code comments accurate and discoverable in any repo.

This skill is project-agnostic. It adapts to the repo's language and layout and never invents product names or decisions.

## When to use this

- The user asks to write, update, or review README, ADR, CHANGELOG, or CONTRIBUTING.
- A new dependency, API, or architecture choice needs recording.
- A release needs notes or an onboarding path needs checking.
- Code comments or docstrings are missing, stale, or noisy.
- If the idea is still vague, run `skillset-docs-discovery` first; this skill records decided outcomes only.

## Non-negotiable principles

1. **Docs live with code.** Markdown in the repo, reviewed like code. See `references/readme.md`.
2. **One ADR per significant decision.** Context, options, decision, consequences — immutable once accepted. See `references/adr.md`.
3. **Changelog is for humans, not git log dumps.** Grouped by type, latest first. See `references/changelog.md`.
4. **Comments explain why, never restate what.** No noise, no dead blocks. See `references/comments.md`.
5. **Never invent facts.** If install steps, versions, or rationale are unverified, test them or ask.
6. **Confirm before wide doc rewrites.** Many files or published pages need approval.

## Workflow (summary)

1. **Check the entry point** — README install and usage actually run per `references/readme.md`.
2. **Record decisions** — new ADR for significant choices per `references/adr.md`.
3. **Log changes** — Unreleased section plus release notes per `references/changelog.md`.
4. **Tidy comments** — why-not-what pass per `references/comments.md`.

See `references/readme.md`, `references/adr.md`, `references/changelog.md`, `references/comments.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
