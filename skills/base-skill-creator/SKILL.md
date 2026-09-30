---
name: base-skill-creator
description: Use this when the user wants to create a new skill for this repository, add a reusable instruction set for a recurring task, turn a one-off explanation into something the agent will apply automatically next time, or asks to "make a skill for X". Also use when reviewing or fixing an existing skill's structure, naming, trigger description, or when a skill is too long, token-heavy, or loads unnecessary context on every call.
---

# Skill Creator

Creates new skills for this repo following a single, consistent standard, so every skill — regardless of who wrote it or what it's for — activates reliably and stays easy to maintain.

This skill is itself project-agnostic. It contains no assumptions about any specific codebase, language, or personal preference — those belong inside the skill being created, not here.

## Non-negotiable rules

1. **One skill, one responsibility.** If you catch yourself writing "and" in the skill's purpose ("handles licensing and code style and commit messages"), stop — split it into separate skills. A skill only loads when its description matches the task; a skill covering five unrelated things either never matches cleanly or gets loaded for tasks it shouldn't touch.

2. **The `description` field is the entire trigger mechanism.** Nothing else in the skill is visible to the agent until the description matches. Spend most of your effort here, not on the body. Write it as: what the skill does + concrete situations/phrases that should trigger it. Vague descriptions ("helps with code style") rarely fire; specific ones ("Use when writing or reviewing Python code: naming conventions, import ordering, docstring format, error handling") do.

3. **Never assume what the user hasn't stated.** If a new skill needs a fact that varies per user, per project, or per run (a name, a preference, a target environment), the skill's instructions must tell the agent to ask — not hardcode a default silently. Look at how `base-legal-license` in this repo handles this: it never assumes the copyright holder's name or the chosen license, it asks every time.

4. **Write skill content in English**, regardless of what language the person creating it speaks in conversation. This keeps skills portable and consistent across a mixed-language team or across agents that behave more reliably with English instructions. Exception: if a skill's entire purpose is to produce output in a specific non-English language, that's a legitimate design choice — state it explicitly in the skill, don't leave it implicit.

5. **Stay project-agnostic unless the skill is explicitly meant to be project-specific.** A skill added to this shared repo should work correctly the first time it's used in any repo — it should not reference a specific project's file paths, package names, or folder layout. If a rule truly only applies to one project, that skill belongs inside that project's own `.claude/skills/` (or equivalent), not in this shared repo.

6. **Confirm before destructive or hard-to-reverse actions.** Overwriting existing files, force-pushing, deleting data — a skill's instructions should tell the agent to summarize what it's about to do and get explicit confirmation first, unless the action is trivially reversible.

7. **Token budget is a hard constraint, not a style preference.** `SKILL.md` loads in full on every activation. Every sentence must justify its cost on every call. Target ≤60 body lines / ~800 words; hard max 100 body lines / 1500 words (enforced by `scripts/package_skill.sh`). Anything else goes to `references/` — nothing is deleted, it is moved behind a link so the agent loads it only when needed.

## Structure and token budgets

```
skills/<skill-name>/
├── SKILL.md          (required — fully loaded on every activation: keep minimal)
├── references/        (optional — loaded on demand via explicit link, not upfront)
├── assets/             (optional — copied as-is: templates, license texts)
└── scripts/            (optional — deterministic helpers, not re-derived by the model)
```

| Location | Budget (enforced) | Holds |
|---|---|---|
| `SKILL.md` body | target ≤60 lines / ~800 words; **max 100 lines / 1500 words** | Trigger context, non-negotiable principles, 3–5 step workflow summary with links. No tables, no verbatim dumps, no examples longer than 2 lines. |
| Each `references/*.md` | **max 200 lines / 2000 words**; one topic per file | Decision tables, style guides, templates, detailed steps. Split the file if it exceeds this. |
| `assets/`, `scripts/` | not counted | Verbatim content (license texts) and code. Never inline these into `SKILL.md`. |

What stays vs. what moves: `SKILL.md` answers *when to fire* and *what to do first*; `references/` answers *how, exactly, for this edge case*. Pattern to copy: `base-legal-license` in this repo (51-line `SKILL.md`, detail in `references/license-menu.md` + `references/workflow.md`, verbatim text in `assets/`).

Banned in `SKILL.md`: decision tables, full API/config dumps, duplicated examples, troubleshooting catalogs, prose paragraphs restating what a linked file already says. If a section is only needed for some activations, it belongs in `references/`.

## Frontmatter spec

```yaml
---
name: kebab-case-name
description: What it does and when to use it. Written for the agent, not for humans browsing a catalog.
---
```

Only these keys are recognized by the shared standard: `name`, `description`, `license`, `allowed-tools`, `metadata`, `compatibility`. Anything else gets ignored or rejected depending on the host tool — don't invent custom frontmatter fields.

**`name`** — must follow the collection namespace `base-<domain>-<topic>`: lowercase letters/digits/hyphens only, no leading/trailing hyphen, no double hyphens, max 64 characters. Must match the folder name exactly. `<domain>` must be one of: `sec`, `design`, `dev`, `git`, `docs`, `ops`, `legal`, `seo`. The only exception is the meta-skill itself (`base-skill-creator`), which is allowed to keep the `skill-creator` topic name because it defines this convention.

**`description`** — max 1024 characters, no `<` or `>` characters. Third person, active: "Use this when...", not "I can help you...".

## Naming convention (collision-safe)

Every skill in this collection **must** be named `base-<domain>-<topic>` so it coexists with skills from other environments, repos, or teammates without collisions.

- `base-` is the reserved collection prefix. Never omit it, never use another collection's prefix.
- `<domain>` is one of: `sec` (security), `design`, `dev` (coding conventions), `git` (version control), `docs` (documentation), `ops` (deployment/infra), `legal` (licenses).
- `<topic>` is 1-3 kebab-case words describing the single responsibility: `auth`, `api-review`, `commits`, `license`, `content`, `technical`.
- Good: `base-sec-auth`, `base-design-api`, `base-dev-commits`, `base-legal-license`.
- Bad: `security` (no prefix, collides), `dev-commits` (missing collection prefix), `base-auth` (missing domain), `base-dev-coding-and-commits` (two responsibilities, split it).
- Single-word or prefix-less names are never allowed, even while the repo is small — the cost of a later rename across every installed agent outweighs any short-term convenience.
- Why: agents merge `~/.claude/skills/`, project `.claude/skills/`, `.agents/skills/`, etc. from all sources. A generic name like `security` or `skill-creator` from two sources collides and one silently shadows the other. `base-` makes ownership obvious in flat listings and in the model-visible `name` field.

## Workflow for creating a new skill

1. **Clarify the trigger first**, before writing anything. Ask (or infer from context, if unambiguous): in what situations should this activate? What would the user actually type that should cause it to fire? Draft the `description` from this — it's the hardest part to get right and everything else depends on it.
2. **Scaffold the folder**: `skills/<name>/SKILL.md` at minimum.
3. **Write the body lean** — 3–5 procedural steps, 1–2 lines each, specific enough that a competent agent executes without guessing. Link detail (`See references/X.md section N`) instead of inlining it.
4. **Push heavy content out** to `references/`/`assets/`/`scripts/` per the budgets above. Re-read the draft and move every paragraph that isn't needed on every activation.
5. **Validate** with `scripts/package_skill.sh skills/<name>` (from the repo root) — it checks frontmatter, naming, and token-budget limits. If it fails on size, move content to `references/`, never just trim meaning.
6. **Register it**: add a row to the "Skills included" table in the repo's root `README.md`.
7. **Activate it locally**: run `./install.sh` again (idempotent — safe to rerun anytime) so the new skill's symlink gets created in every agent's discovery path. Some agents only scan for new skills at session startup — restart the coding agent's session afterward if it doesn't show up immediately.

## Self-check before considering a skill done

- Does the `name` follow `base-<domain>-<topic>` and match the folder name exactly?
- Does the `description` name concrete trigger situations, not just a topic label?
- Does the skill avoid hardcoding anything the user should be asked instead?
- Is the body free of assumptions specific to one project?
- Is `SKILL.md` within budget (target ≤60 lines, max 100) with detail pushed to `references/` and linked, not inlined?
- Would a stranger who has never seen this repo understand when and how to use it, just from SKILL.md?
- Does `scripts/package_skill.sh` validate it cleanly?
