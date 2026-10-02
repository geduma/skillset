# skillset

Personal collection of *skills* (`SKILL.md`) and *agents* (`agents/*.md`) for AI coding agents — Claude Code, Codex CLI, OpenCode, Cursor, VSCode/Copilot, and any other tool that supports these open formats.

Version `1.3.0` (see `VERSION` and `CHANGELOG.md`). Every skill carries `metadata.version`, `allowed-tools`, trigger evals in `evals/`, and a routing pointer to `docs/ROUTING.md`. Validate with `python3 scripts/validate-pack.py`.

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
├── agents/               (tool-agnostic source of truth: skillset, skillset-spec/code/verify/ship)
├── docs/
│   └── ROUTING.md        (canonical routing matrix for all skills and agents)
├── scripts/
│   └── package_skill.sh
├── dist/              (generated — packaged .skill files, git-ignored)
├── install.sh         (links skills/ + agents/ into every tool's discovery paths)
├── uninstall.sh
└── README.md
```

`agents/` mirrors the `skills/` philosophy: one tool-agnostic source of truth, symlinked by `install.sh` into each tool's agent discovery path. `skillset-creator` is excluded from the multiagent workflow — it builds skills, never runs inside product delivery.

All skill content (SKILL.md, references, assets) is written in **English**, regardless of the language used to develop this repo or talk to the agent day to day — this keeps skills portable across agents and consistent if this repo is ever shared. Individual skills may of course produce project-specific output in another language when that's literally their job (e.g. a skill whose purpose is generating Spanish-language documentation) — but the skill's own instructions stay in English.

---

## 1. Installing on a new machine

```bash
git clone <your-repo-url> ~/skillset
cd ~/skillset
./install.sh --global
```

`install.sh` creates symlinks from `skills/<name>/` and `agents/<name>.md` into every coding agent's discovery path:

| Agent | Project skills | Global skills | Project agents | Global agents |
|---|---|---|---|---|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` | `.claude/agents/` | `~/.claude/agents/` |
| Codex CLI | `.codex/skills/` | `~/.codex/skills/` | `.codex/agents/` | `~/.codex/agents/` |
| OpenCode | `.opencode/skills/` | `~/.config/opencode/skills/` | `.opencode/agents/` | `~/.config/opencode/agents/` |
| Shared standard (also read by Codex and OpenCode) | `.agents/skills/` | `~/.agents/skills/` | `.agents/agents/` | `~/.agents/agents/` |
| Cursor | `.cursor/skills/` | `~/.cursor/skills/` | `.cursor/agents/` | `~/.cursor/agents/` |
| VSCode/Copilot | `.github/skills/` | *(no global support)* | `.github/agents/` | *(no global support)* |

Other useful variants:

```bash
./install.sh                        # project-only skills + agents, for the repo you're currently in
./install.sh --global skillset-legal-license   # install just one skill
./install.sh --global skillset      # install just one agent
./install.sh --global --skills-only # only skills
./install.sh --global --agents-only # only agents
./install.sh --global --copy        # copy instead of symlink (Windows/WSL symlink issues)
./install.sh --global --prune       # also prune stale LEGOS symlinks (opt-in, never default)
./install.sh --global --copy --force # replace real files/dirs with fresh copies (explicit, may overwrite manual edits)
```

Run this once per machine. After that, every project you open with any of these agents sees all your skills without any per-project setup.

To work a feature end to end, select the `skillset` agent and say `implementar feature X` — it classifies the request per `docs/ROUTING.md` and delegates each pipeline phase to `skillset-spec`, `skillset-code`, `skillset-verify` and `skillset-ship` (see "Agents included" below).

## 2. Updating skills when you update the repo

Because `install.sh` creates **symlinks**, not copies, the discovery paths always point straight at the files inside your cloned `skillset` folder. This means:

- **Editing an existing skill** (yours, or pulled from a teammate/another machine): just `git pull` inside `~/skillset`. The symlinks already exist and point at those files — there's nothing else to run, the change is live in your next agent session immediately.
- **Adding a brand-new skill** (a new folder under `skills/`): after `git pull`, run `./install.sh --global` again. It's idempotent and safe to rerun anytime — it only creates symlinks that don't already exist, it won't touch or duplicate the ones that do.
- **Removing a deleted skill** (folder removed from `skills/` or `agents/`): run `./install.sh --global --prune`. Without `--prune` stale symlinks are kept; with `--prune` only LEGOS symlinks whose source no longer exists are removed — manual or third-party content is untouched.
- **Refreshing `--copy` installs**: plain `--copy` never overwrites a real file/dir (skip protector). Add `--force` (`--copy --force`) to explicitly replace managed destinations — it may overwrite manual edits, so it is never default.
- **Agent session freshness**: some agents only scan their skills directory at session startup. If a newly installed or updated skill doesn't seem to be recognized, start a new session (restart Claude Code / Codex / OpenCode) to force a rescan.

So the day-to-day loop is: edit or `git pull` → commit/push if you made local changes → `./install.sh --global` only when a new skill folder was added.

## 2b. Pinning versions across workstations

This repo is a **base library shared by every machine**, not a per-project dependency. A `description` change alters agent behavior in all your projects at once. Treat updates accordingly:

- **Pin stable machines:** `git checkout v1.2.0` inside `~/skillset` keeps a workstation on a known-good pack. `git checkout main && git pull` moves it forward when you decide.
- **Trial on one machine first:** pull `main` on a single workstation, work a full day, then propagate to the rest. Never roll an untested pack to all machines at once.
- **Bump on behavior change:** any `description`, routing, or principle change requires a `VERSION` bump and a `CHANGELOG.md` entry — cosmetic doc fixes don't.

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
| `skillset-docs-discovery` | Discovery interview: turns vague ideas into committable decisions via rounds before any spec or docs. |
| `skillset-dev-feature` | Feature spec and plan: light SDD spec, validated plan, ordered tasks under docs/features, mandatory docs-sync task. |
| `skillset-dev-orchestrator` | Pipeline router: classifies multi-phase work, sequences discovery → feature → code → tests → security → docs → ship per `docs/ROUTING.md`. |

## Agents included

Tool-agnostic source of truth under `agents/`, linked by `install.sh` into each tool's agent path. One primary + four subagents; every agent sees the full skill library via `docs/ROUTING.md` (affinity is not exclusivity — out-of-phase work escalates to `skillset`). `skillset-creator` is excluded from this workflow.

| Agent | Mode | Affinity |
|---|---|---|
| `skillset` | primary | Entry point: `implementar feature X` → classify, sequence, delegate, verify gates. |
| `skillset-spec` | subagent | `docs-discovery` + `dev-feature`. Read-only except `docs/**`, no shell. |
| `skillset-code` | subagent | `dev-style` + `dev-backend`/`dev-frontend` + `design-system`. No `git push`. |
| `skillset-verify` | subagent | `dev-testing` + `sec-appsec` (+ `sec-audit` only on explicit audit request). |
| `skillset-ship` | subagent | `docs-project` + conditional `seo-*`/`legal-license` + `git-workflow` (explicit `commit/push/PR` only). |

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
- [x] `skillset-docs-discovery` — vague-idea interview, rounds, talk-vs-build split.
- [x] `skillset-dev-feature` — light feature spec, validated plan, tasks, docs-sync.
