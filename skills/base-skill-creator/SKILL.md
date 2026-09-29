---
name: skill-creator
description: Use this when the user wants to create a new skill for this repository, add a reusable instruction set for a recurring task, turn a one-off explanation into something the agent will apply automatically next time, or asks to "make a skill for X". Also use when reviewing or fixing an existing skill's structure, naming, or trigger description.
---

# Skill Creator

Creates new skills for this repo following a single, consistent standard, so every skill — regardless of who wrote it or what it's for — activates reliably and stays easy to maintain.

This skill is itself project-agnostic. It contains no assumptions about any specific codebase, language, or personal preference — those belong inside the skill being created, not here.

## Non-negotiable rules

1. **One skill, one responsibility.** If you catch yourself writing "and" in the skill's purpose ("handles licensing and code style and commit messages"), stop — split it into separate skills. A skill only loads when its description matches the task; a skill covering five unrelated things either never matches cleanly or gets loaded for tasks it shouldn't touch.

2. **The `description` field is the entire trigger mechanism.** Nothing else in the skill is visible to the agent until the description matches. Spend most of your effort here, not on the body. Write it as: what the skill does + concrete situations/phrases that should trigger it. Vague descriptions ("helps with code style") rarely fire; specific ones ("Use when writing or reviewing Python code: naming conventions, import ordering, docstring format, error handling") do.

3. **Never assume what the user hasn't stated.** If a new skill needs a fact that varies per user, per project, or per run (a name, a preference, a target environment), the skill's instructions must tell the agent to ask — not hardcode a default silently. Look at how `license-guardian` in this repo handles this: it never assumes the copyright holder's name or the chosen license, it asks every time.

4. **Write skill content in English**, regardless of what language the person creating it speaks in conversation. This keeps skills portable and consistent across a mixed-language team or across agents that behave more reliably with English instructions. Exception: if a skill's entire purpose is to produce output in a specific non-English language, that's a legitimate design choice — state it explicitly in the skill, don't leave it implicit.

5. **Stay project-agnostic unless the skill is explicitly meant to be project-specific.** A skill added to this shared repo should work correctly the first time it's used in any repo — it should not reference a specific project's file paths, package names, or folder layout. If a rule truly only applies to one project, that skill belongs inside that project's own `.claude/skills/` (or equivalent), not in this shared repo.

6. **Confirm before destructive or hard-to-reverse actions.** Overwriting existing files, force-pushing, deleting data — a skill's instructions should tell the agent to summarize what it's about to do and get explicit confirmation first, unless the action is trivially reversible.

## Structure of a skill

```
skills/<skill-name>/
├── SKILL.md          (required — the only file the agent always reads first)
├── references/        (optional — markdown docs loaded on demand, not upfront)
├── assets/             (optional — templates, boilerplate files, license texts, etc.)
└── scripts/            (optional — executable helpers the agent can run)
```

- **SKILL.md** should stay readable in one sitting — keep the body under ~500 lines. If it's growing past that, you're not being disciplined about pushing detail into `references/`.
- **references/** holds anything the agent only needs when the skill actually activates and the task needs that specific detail — decision tables, style guides, API references. Link to these from SKILL.md; don't inline them.
- **assets/** holds files used mostly as-is: license texts, config templates, boilerplate snippets. The agent copies/adapts these rather than generating them from scratch.
- **scripts/** holds deterministic code (validation, formatting, packaging) that shouldn't be re-derived by the model every time.

## Frontmatter spec

```yaml
---
name: kebab-case-name
description: What it does and when to use it. Written for the agent, not for humans browsing a catalog.
---
```

Only these keys are recognized by the shared standard: `name`, `description`, `license`, `allowed-tools`, `metadata`, `compatibility`. Anything else gets ignored or rejected depending on the host tool — don't invent custom frontmatter fields.

**`name`** — kebab-case, lowercase letters/digits/hyphens only, no leading/trailing hyphen, no double hyphens, max 64 characters. Should match the folder name exactly.

**`description`** — max 1024 characters, no `<` or `>` characters. Third person, active: "Use this when...", not "I can help you...".

## Naming convention

Prefix by domain once the repo has more than a handful of skills, so the flat list stays navigable: `dev-*` for coding-convention skills, `git-*` for version-control workflows, `docs-*` for documentation generation, `ops-*` for deployment/infra. Single-word names are fine while the repo is small — don't over-engineer prefixes on day one, but don't resist them once navigation gets harder either.

## Workflow for creating a new skill

1. **Clarify the trigger first**, before writing anything. Ask (or infer from context, if unambiguous): in what situations should this activate? What would the user actually type that should cause it to fire? Draft the `description` from this — it's the hardest part to get right and everything else depends on it.
2. **Scaffold the folder**: `skills/<name>/SKILL.md` at minimum.
3. **Write the body** — the actual instructions, workflow, or rules the agent should follow once the skill is active. Keep it procedural and specific enough that a competent agent could execute it without guessing.
4. **Push heavy content out** to `references/`/`assets/`/`scripts/` as described above, and link to it from the body.
5. **Validate** with `scripts/package_skill.sh skills/<name>` (from the repo root) — it checks frontmatter validity, naming, and length limits before anything is packaged.
6. **Register it**: add a row to the "Skills included" table in the repo's root `README.md`.
7. **Activate it locally**: run `./install.sh` again (idempotent — safe to rerun anytime) so the new skill's symlink gets created in every agent's discovery path. Some agents only scan for new skills at session startup — restart the coding agent's session afterward if it doesn't show up immediately.

## Self-check before considering a skill done

- Does the `description` name concrete trigger situations, not just a topic label?
- Does the skill avoid hardcoding anything the user should be asked instead?
- Is the body free of assumptions specific to one project?
- Would a stranger who has never seen this repo understand when and how to use it, just from SKILL.md?
- Does `scripts/package_skill.sh` validate it cleanly?
