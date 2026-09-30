# Non-negotiable Rules

The nine rules every skill in this collection must follow. The `SKILL.md` lists them in one line each; this file is the normative detail.

## 1. One skill, one responsibility

If you catch yourself writing "and" in the skill's purpose ("handles licensing and code style and commit messages"), stop — split it into separate skills. A skill only loads when its description matches the task; a skill covering five unrelated things either never matches cleanly or gets loaded for tasks it shouldn't touch.

## 2. The description is the entire trigger mechanism

Nothing else in the skill is visible to the agent until the description matches. Spend most of your effort here, not on the body. Write it as: what the skill does + concrete situations/phrases that should trigger it. Vague descriptions ("helps with code style") rarely fire; specific ones ("Use when writing or reviewing Python code: naming conventions, import ordering, docstring format, error handling") do.

## 3. Never assume what the user hasn't stated

If a new skill needs a fact that varies per user, per project, or per run (a name, a preference, a target environment), the skill's instructions must tell the agent to ask — not hardcode a default silently. Look at how `skillset-legal-license` in this repo handles this: it never assumes the copyright holder's name or the chosen license, it asks every time.

## 4. Write skill content in English

Regardless of what language the person creating it speaks in conversation. This keeps skills portable and consistent across a mixed-language team or across agents that behave more reliably with English instructions. Exception: if a skill's entire purpose is to produce output in a specific non-English language, that's a legitimate design choice — state it explicitly in the skill, don't leave it implicit.

## 5. Stay project-agnostic unless explicitly project-specific

A skill added to this shared repo should work correctly the first time it's used in any repo — it should not reference a specific project's file paths, package names, or folder layout. If a rule truly only applies to one project, that skill belongs inside that project's own `.claude/skills/` (or equivalent), not in this shared repo.

## 6. Confirm before destructive or hard-to-reverse actions

Overwriting existing files, force-pushing, deleting data — a skill's instructions should tell the agent to summarize what it's about to do and get explicit confirmation first, unless the action is trivially reversible.

## 7. Token budget is a hard constraint, not a style preference

`SKILL.md` loads in full on every activation. Every sentence must justify its cost on every call. Target ≤60 body lines / ~800 words; hard max 100 body lines / 1500 words (enforced by `scripts/package_skill.sh`). Anything else goes to `references/` — nothing is deleted, it is moved behind a link so the agent loads it only when needed.

## 8. Every skill is versioned, scoped, and routed

Frontmatter must carry `license`, `allowed-tools` (minimum tools the skill needs), and `metadata.version` matching the repo `VERSION` file (semver). Body must link `docs/ROUTING.md` as the conflict tiebreaker. Multi-phase work routes via `skillset-dev-orchestrator`, never by absorbing other skills' jobs.

## 9. Every skill ships trigger evals

`evals/trigger-tests.md` with at least 5 should-trigger prompts and a should-NOT-trigger section routing elsewhere. Run `scripts/validate-pack.py` before considering a skill done; it enforces rules 7–9 at pack level.
