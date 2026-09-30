# skillset

Personal collection of *skills* (`SKILL.md`) for AI coding agents — Claude Code, Codex CLI, OpenCode, Cursor, VSCode/Copilot, and any other tool that supports the open `SKILL.md` standard.

## Why this repo exists

`SKILL.md` is an open format: a folder of instructions an agent loads only when the current task needs it (this avoids bloating every conversation with rules that don't apply). Each agent looks for it in a different path, but the content itself is identical and portable without changes. This repo keeps **a single source of truth** per skill under `skills/`, and uses symlinks so it shows up automatically wherever each agent expects to find it.

```
skillset/
├── skills/
│   ├── skillset-creator/       (meta-skill: how to build new skills for this repo)
│   ├── skillset-legal-license/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── assets/
│   └── <future skills>/
├── scripts/
│   └── package_skill.sh
├── dist/              (generated — packaged .skill files, git-ignored)
├── install.sh
├── uninstall.sh
└── README.md
```

All skill content (SKILL.md, references, assets) is written in **English**, regardless of the language used to develop this repo or talk to the agent day to day — this keeps skills portable across agents and consistent if this repo is ever shared. Individual skills may of course produce project-specific output in another language when that's literally their job (e.g. a skill whose purpose is generating Spanish-language documentation) — but the skill's own instructions stay in English.

---

## 1. Installing on a new machine

```bash
git clone <your-repo-url> ~/skillset
cd ~/skillset
./install.sh --global
```

`install.sh` creates symlinks from `skills/<name>/` into every coding agent's discovery path:

| Agent | Project path | Global path |
|---|---|---|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| Codex CLI | `.codex/skills/` | `~/.codex/skills/` |
| OpenCode | `.opencode/skills/` | `~/.config/opencode/skills/` |
| Shared standard (also read by Codex and OpenCode) | `.agents/skills/` | `~/.agents/skills/` |
| Cursor | `.cursor/skills/` | `~/.cursor/skills/` |
| VSCode/Copilot | `.github/skills/` | *(no global support)* |

Other useful variants:

```bash
./install.sh                        # project-only, for the repo you're currently in
./install.sh --global skillset-legal-license   # install just one skill
./install.sh --global --copy        # copy instead of symlink (Windows/WSL symlink issues)
```

Run this once per machine. After that, every project you open with any of these agents sees all your skills without any per-project setup.

## 2. Updating skills when you update the repo

Because `install.sh` creates **symlinks**, not copies, the discovery paths always point straight at the files inside your cloned `skillset` folder. This means:

- **Editing an existing skill** (yours, or pulled from a teammate/another machine): just `git pull` inside `~/skillset`. The symlinks already exist and point at those files — there's nothing else to run, the change is live in your next agent session immediately.
- **Adding a brand-new skill** (a new folder under `skills/`): after `git pull`, run `./install.sh --global` again. It's idempotent and safe to rerun anytime — it only creates symlinks that don't already exist, it won't touch or duplicate the ones that do.
- **Agent session freshness**: some agents only scan their skills directory at session startup. If a newly installed or updated skill doesn't seem to be recognized, start a new session (restart Claude Code / Codex / OpenCode) to force a rescan.

So the day-to-day loop is: edit or `git pull` → commit/push if you made local changes → `./install.sh --global` only when a new skill folder was added.

## 3. Automatic use — no need to ask per task

This is the core design of the `SKILL.md` standard, not something you configure: skills are **model-invoked**, not manually invoked. Once installed, your coding agent reads only the short `name` + `description` of every installed skill at the start of a session (a few dozen tokens each). When you give it a task, it compares that task against every available description and loads the full skill only if one matches — automatically, without you naming the skill.

This means the entire mechanism lives in how well each skill's `description` is written. A skill with a vague description ("helps with licensing") may not fire reliably; one written with concrete trigger phrases ("Use this whenever the user wants to add a LICENSE file, protect their code from commercial exploitation, or asks 'add a license to this repo'") fires exactly when it should. The `skillset-creator` meta-skill in this repo exists specifically to keep this discipline consistent every time you add a new one — see `skills/skillset-creator/SKILL.md`.

If a skill never seems to trigger on its own, the fix is almost always to rewrite its `description` with more specific, realistic trigger phrasing — not to start manually reminding the agent to use it every time.

---

## Adding a new skill

Don't do this from scratch — use the meta-skill itself: tell your agent something like *"use the skillset-creator skill to help me create a new skill for X"*, and it will follow the rules and workflow documented in `skills/skillset-creator/SKILL.md` (one responsibility per skill, English content, project-agnostic, proper frontmatter, validation, registration).

Manual summary:

1. `mkdir -p skills/<name>`, write `skills/<name>/SKILL.md` with valid frontmatter (`name`, `description`).
2. Push heavy content into `references/`, `assets/`, or `scripts/` inside that same folder.
3. Validate: `./scripts/package_skill.sh skills/<name>`.
4. Add a row to the "Skills included" table below.
5. `./install.sh` again to activate it across all agents.

## Packaging a skill as `.skill` (for uploading to claude.ai)

Terminal/IDE agents (Claude Code, Codex, OpenCode, Cursor) read the **raw folder** directly via `install.sh` — no packaging needed. But claude.ai's web interface and the Skills API expect a `.skill` file (a `.zip` with specific validation rules):

```bash
./scripts/package_skill.sh skills/skillset-legal-license
# → dist/skillset-legal-license.skill
```

The script validates before packaging (no dependency on any Anthropic-internal tooling — just `python3` + `pyyaml` + `zip`):

- Exactly one `SKILL.md`, with no other `SKILL.md` nested inside.
- Valid YAML frontmatter, with only these keys allowed: `name`, `description`, `license`, `allowed-tools`, `metadata`, `compatibility`.
- `name` in kebab-case, max 64 characters, following `skillset-<domain>-<topic>` (`sec`, `design`, `dev`, `git`, `docs`, `ops`, `legal`, `seo`).
- `description` with no `<` or `>`, max 1024 characters.
- Token budget (hard): `SKILL.md` body max 100 lines / 1500 words (target ≤60 / ~800); each `references/*.md` max 200 lines / 2000 words. Detail goes to `references/`, never inlined.

## Skills included

| Skill | What it does |
|---|---|
| `skillset-creator` | Meta-skill: teaches the agent the rules and workflow for creating new skills in this repo. |
| `skillset-legal-license` | Analyzes a project, asks for the copyright holder and desired license (with a decision menu), and generates LICENSE, copyright notice, and updates the README/manifest. |
| `skillset-dev-style` | Applies language-agnostic dev style: intent-first naming, predictable structure, strict lint/type/format/test gates, and fail-fast safeguards. Never switches languages. |
| `skillset-seo-content` | Audits on-page SEO content: meta titles/descriptions, H1/H2/H3, search intent, TLDR, TOC, tables/lists, FAQ, internal linking and topic clusters, CTA placement. |
| `skillset-seo-technical` | Handles technical SEO: robots.txt, sitemaps and GSC, URLs, indexation including paginated paths, image naming/alt, FAQ/LocalBusiness schema, LLMS.txt, GA4/GSC wiring. |
| `skillset-sec-appsec` | Applies preventive AppSec baseline to apps, APIs, and backends: secrets, DB/RLS, auth/sessions, validation/XSS/uploads, rate limiting, headers, TLS, dependencies. |
| `skillset-sec-audit` | Runs structured security audits with coverage ledger, isolated hunting, adversarial validation, and verified findings plus reports. |
| `skillset-design-system` | Apple HIG-based web UI foundations with optional Liquid Glass, plus intentional craft (intent, signature, anti-generic checks): foundations, glass, typography, motion, accessibility, components. |
| `skillset-dev-frontend` | Framework-agnostic frontend engineering: components, server vs client state, rendering and performance, forms and data, a11y and testing, security-compatible patterns. |
| `skillset-git-workflow` | Branch-based workflow: topic branches, Conventional Commits, small PRs, review and merge policy, conflict and history safety. |
| `skillset-dev-backend` | Backend API design: noun resources, method semantics, status codes, RFC 9457 errors, pagination/filtering, versioning and OpenAPI contracts. |
| `skillset-dev-testing` | Test strategy and debugging: pyramid mix, AAA hermetic tests, reproduce-bisect-regress, de-flaking and CI enforcement. |
| `skillset-docs-project` | Project docs: runnable README, Nygard ADRs, Keep a Changelog + SemVer, why-not-what comments. |

## Personal roadmap

- [x] `skillset-dev-style` — naming, structure, quality gates, and safeguards (language-agnostic).
- [x] `skillset-seo-content` — on-page SEO and content optimization.
- [x] `skillset-seo-technical` — crawlability, indexation, schema, LLMS.txt, and measurement.
- [x] `skillset-sec-appsec` — preventive AppSec baseline.
- [x] `skillset-sec-audit` — structured security audit harness.
- [x] `skillset-design-system` — Apple HIG foundations plus craft.
- [x] `skillset-dev-frontend` — frontend application engineering.
- [x] `skillset-git-workflow` — branches, Conventional Commits, PRs, history safety.
- [x] `skillset-dev-backend` — REST resources, methods, errors, pagination, versioning.
- [x] `skillset-dev-testing` — pyramid, AAA tests, debugging, suite hygiene.
- [x] `skillset-docs-project` — README, ADRs, changelog, comments.
