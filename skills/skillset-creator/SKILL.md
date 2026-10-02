---
name: skillset-creator
description: Use this when the user wants to create a new skill for this repository, add a reusable instruction set for a recurring task, turn a one-off explanation into something the agent will apply automatically next time, or asks to "make a skill for X". Also use when reviewing or fixing an existing skill's structure, naming, trigger description, or when a skill is too long, token-heavy, or loads unnecessary context on every call.
license: MIT
allowed-tools: Read Write Edit Glob
metadata:
  version: 1.3.0
---

# Skill Creator

Creates new skills for this repo following a single, consistent standard, so every skill activates reliably and stays easy to maintain.

This skill is itself project-agnostic. It contains no assumptions about any specific codebase, language, or personal preference — those belong inside the skill being created, not here.

## When to use this

- The user asks to create, review, or fix a skill in this repo.
- An existing skill is too long, misnamed, or never triggers correctly.

## Non-negotiable principles

1. **One skill, one responsibility.** Split on "and". See `references/rules.md` section 1.
2. **Description is the trigger.** Concrete situations and phrases, never vague labels. See `references/rules.md` section 2.
3. **Never assume what varies.** Tell the agent to ask. See `references/rules.md` section 3.
4. **English content, project-agnostic.** Portable across agents and repos. See `references/rules.md` sections 4-5.
5. **Confirm before destructive actions.** Summarize first, wait for approval. See `references/rules.md` section 6.
6. **Token budget is hard.** Target ≤60 body lines / ~800 words; max 100 / 1500. See `references/structure-budgets.md` section 2.
7. **Naming is collision-safe.** `skillset-<domain>-<topic>` matching the folder. See `references/frontmatter-naming.md` section 2.
8. **Versioned, scoped, routed.** `license`, `allowed-tools`, `metadata.version` (= `VERSION`); body links `docs/ROUTING.md`. See `references/rules.md` section 8.
9. **Trigger evals required.** `evals/trigger-tests.md` with 5 should-trigger + 3 should-NOT-trigger (5+5 with incidentals for high-risk skills). See `references/rules.md` section 9.

## Workflow (summary)

1. **Clarify the trigger** — draft the `description` first per `references/workflow.md` section 1.
2. **Scaffold and write lean** — 3–5 steps with links, detail in `references/`, never inlined.
3. **Apply frontmatter and naming** — keys, version, tools per `references/frontmatter-naming.md`.
4. **Validate, register, activate** — `package_skill.sh`, README row, `install.sh`, plus evals and `validate-pack.py` per `references/workflow.md`.

See `references/rules.md`, `references/structure-budgets.md`, `references/frontmatter-naming.md`, `references/workflow.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
