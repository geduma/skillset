# Frontmatter and Naming

## 1. Frontmatter spec

```yaml
---
name: kebab-case-name
description: What it does and when to use it. Written for the agent, not for humans browsing a catalog.
license: MIT
allowed-tools: Read Glob Grep
metadata:
  version: 1.1.0
---
```

Only these keys are recognized by the shared standard: `name`, `description`, `license`, `allowed-tools`, `metadata`, `compatibility`. Anything else gets ignored or rejected depending on the host tool — don't invent custom frontmatter fields.

**`name`** — must follow the collection namespace `skillset-<domain>-<topic>`: lowercase letters/digits/hyphens only, no leading/trailing hyphen, no double hyphens, max 64 characters. Must match the folder name exactly. `<domain>` must be one of: `sec`, `design`, `dev`, `git`, `docs`, `ops`, `legal`, `seo`. The only exception is the meta-skill itself (`skillset-creator`), which is allowed to keep the short name because it defines this convention.

**`description`** — max 1024 characters, no `<` or `>` characters. Third person, active: "Use this when...", not "I can help you...".

**`license`** — SPDX identifier, `MIT` for this pack unless the skill bundles third-party text.

**`allowed-tools`** — minimum tool set the skill needs (e.g. `Read Glob Grep` for routing-only, add `Edit Write` for generating skills, add `Shell` for running gates). Never grant more than the workflow requires.

**`metadata.version`** — semver matching the repo `VERSION` file. Bump together; `scripts/validate-pack.py` fails on drift.

## 2. Naming convention (collision-safe)

Every skill in this collection **must** be named `skillset-<domain>-<topic>` so it coexists with skills from other environments, repos, or teammates without collisions.

- `skillset-` is the reserved collection prefix. Never omit it, never use another collection's prefix.
- `<domain>` is one of: `sec` (security), `design`, `dev` (coding conventions), `git` (version control), `docs` (documentation), `ops` (deployment/infra), `legal` (licenses), `seo` (search).
- `<topic>` is 1-3 kebab-case words describing the single responsibility: `auth`, `api-review`, `workflow`, `backend`, `testing`, `project`, `license`, `content`, `technical`.
- Good: `skillset-sec-appsec`, `skillset-dev-style`, `skillset-git-workflow`, `skillset-legal-license`.
- Bad: `security` (no prefix, collides), `dev-commits` (missing collection prefix), `skillset-auth` (missing domain), `skillset-dev-coding-and-commits` (two responsibilities, split it).
- Single-word or prefix-less names are never allowed, even while the repo is small — the cost of a later rename across every installed agent outweighs any short-term convenience.
- Why: agents merge `~/.claude/skills/`, project `.claude/skills/`, `.agents/skills/`, etc. from all sources. A generic name like `security` or `skill-creator` from two sources collides and one silently shadows the other. `skillset-` makes ownership obvious in flat listings and in the model-visible `name` field.
