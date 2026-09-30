# Creation Workflow

## 1. Steps

1. **Clarify the trigger first**, before writing anything. Ask (or infer from context, if unambiguous): in what situations should this activate? What would the user actually type that should cause it to fire? Draft the `description` from this — it's the hardest part to get right and everything else depends on it.
2. **Scaffold the folder**: `skills/<name>/SKILL.md` at minimum.
3. **Write the body lean** — 3–5 procedural steps, 1–2 lines each, specific enough that a competent agent executes without guessing. Link detail (`See references/X.md section N`) instead of inlining it.
4. **Push heavy content out** to `references/`/`assets/`/`scripts/` per the budgets in `structure-budgets.md` section 2. Re-read the draft and move every paragraph that isn't needed on every activation.
5. **Validate** with `scripts/package_skill.sh skills/<name>` (from the repo root) — it checks frontmatter, naming, and token-budget limits. If it fails on size, move content to `references/`, never just trim meaning.
6. **Register it**: add a row to the "Skills included" table in the repo's root `README.md`.
7. **Activate it locally**: run `./install.sh` again (idempotent — safe to rerun anytime) so the new skill's symlink gets created in every agent's discovery path. Some agents only scan for new skills at session startup — restart the coding agent's session afterward if it doesn't show up immediately.
8. **Route and evaluate**: link `docs/ROUTING.md` in the body, add `evals/trigger-tests.md` (5 should-trigger + should-NOT-trigger), set `metadata.version` to `VERSION`, then run `python3 scripts/validate-pack.py`.
9. **Roll out as a base library**: this pack ships to every workstation via `git pull`. Bump `VERSION` + `CHANGELOG.md` on any behavior change (`description`, routing, principles), trial on one machine first, then propagate. Never auto-commit or auto-push — commits are manual, by the human.

## 2. Self-check before considering a skill done

- Does the `name` follow `skillset-<domain>-<topic>` and match the folder name exactly?
- Does the `description` name concrete trigger situations, not just a topic label?
- Does the skill avoid hardcoding anything the user should be asked instead?
- Is the body free of assumptions specific to one project?
- Is `SKILL.md` within budget (target ≤60 lines, max 100) with detail pushed to `references/` and linked, not inlined?
- Would a stranger who has never seen this repo understand when and how to use it, just from SKILL.md?
- Does `scripts/package_skill.sh` validate it cleanly?
- Does `python3 scripts/validate-pack.py` pass (version, evals, routing pointer)?
- Is `VERSION`/`CHANGELOG.md` bumped for behavior changes, and is the rollout trial-first?
