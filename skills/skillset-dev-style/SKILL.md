---
name: skillset-dev-style
description: Use this when writing new code, reviewing a diff or pull request, scaffolding files or folders, adding or fixing lint, strict type-checking, formatting, testing, logging, validation, or project structure, or when the user asks about naming, code style, clean code, folder layout, or says follow my style, review this code, organize this project, or enforce quality gates. Do not use for choosing a programming language or framework, for commit messages, for licensing, or for deployment.
license: MIT
allowed-tools: Read Edit Write Glob Grep Shell
metadata:
  version: 1.2.0
---

# Dev Style

Applies the user's accumulated coding style to any codebase without switching its language or framework: clear naming, predictable structure, and strict quality gates.

This skill is language-agnostic. It never recommends a language or framework. It applies principles to the project's current stack, using the user's existing tool classes as reference examples only.

## When to use this

- The user asks to write, refactor, or review code in their style.
- The user asks to scaffold, reorganize, or audit files and folders.
- The user asks to add or fix a linter, strict checks, formatter, tests, logger, or validator.
- A diff needs a style pass before it is considered done.

## Non-negotiable principles

1. **Never switch the stack.** Use the project's current language and framework. See `references/quality-gates.md`.
2. **Never assume what varies.** If strictness level, test command, or scope is unclear, ask. Do not silently reuse another project's choice.
3. **Names carry intent.** See `references/naming.md`.
4. **Structure is predictable.** See `references/structure.md`.
5. **Every change passes its gates.** See `references/quality-gates.md`.
6. **Fail fast, log cleanly, validate input.** See `references/safeguards.md`.
7. **Confirm before hard-to-reverse actions.** Mass renames, config overwrites, deletions: summarize first, wait for approval.

## Workflow (summary)

1. **Detect the stack** — read manifest and folders, note existing linter, checker, formatter, tests. Never propose a different language. See `references/structure.md` section 1.
2. **Apply naming and structure** — rename and place files per `references/naming.md` and `references/structure.md`. Keep diffs small.
3. **Enforce gates and safeguards** — wire lint, strict checks, format, tests, logging, validation per `references/quality-gates.md` and `references/safeguards.md`. Use `assets/` templates as starting points, adapted to the stack.
4. **Verify** — run the project's own gates. If a gate is missing, ask before inventing one. Report what ran and what failed.

See `references/naming.md`, `references/structure.md`, `references/quality-gates.md`, `references/safeguards.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
