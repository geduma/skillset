---
name: license-guardian
description: Use this skill whenever the user wants to add, choose, or fix a LICENSE file, protect their code/project from being exploited commercially without credit, set up copyright notices, or asks things like "protect my project", "I want to add a license", "I don't want anyone profiting off my code", "make this repo like [another project]", "add a LICENSE", or wants a repo prepared for public release/open-sourcing. Also trigger when the user references replicating licensing/legal setup done on a previous or sibling project. Always ask the user for the copyright holder name and the specific license before writing anything — never assume either.
---

# License Guardian

Prepares any repository with a proper license, copyright notice, and minimal documentation, consistently across the user's projects.

## When to use this

- The user wants to add or change a project's license.
- The user wants to "protect" their code or idea from others profiting off it without giving anything back.
- The user wants to replicate in another repo what was done in a previous project (LICENSE, copyright notice, README section).
- The user is preparing a repo for public release.

## Non-negotiable principles

1. **Never assume the copyright holder's name.** Always ask, on every project — don't silently reuse it from a previous session even if it looks like the same user, since this skill is generic and meant to be shared across different holders/projects.
2. **Never assume the license.** Present the menu of options (`references/license-menu.md`) with a tentative recommendation based on what you detected about the project, but the final decision is always the user's.
3. **Never paraphrase or summarize a license's legal text.** It must be copied verbatim. Common licenses already have official text in `assets/licenses/`. For anything else, look up the official text on the web before writing it.
4. **Never overwrite an existing license without explicit confirmation.**

## Workflow (summary)

1. **Investigate the project** — read the README, detect the dependency manifest (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.) and folder structure to infer whether it's a network service (API/backend/proxy) or a distributed library/CLI. See `references/workflow.md` section 1.
2. **Ask for the holder's name and chosen license** — show the menu from `references/license-menu.md` with your tentative recommendation, and wait for the user's choice. See `references/workflow.md` section 2.
3. **Generate the files**:
   - `LICENSE` with the full verbatim text from `assets/licenses/<spdx-id>.txt`.
   - Short copyright notice (for the README and optionally source file headers).
   - "License" section in the README.
   - `license` field in the detected ecosystem's manifest.

   Exact templates in `references/workflow.md` section 3.
4. **Confirm before writing** if there's a different pre-existing license or if many files will be touched. If the project had no prior license, proceed directly after the user's choice.

## Included licenses (verbatim text, ready to use)

`assets/licenses/` contains the full official text of:

- `agpl-3.0.txt` — GNU AGPL v3.0
- `gpl-3.0.txt` — GNU GPL v3.0
- `lgpl-3.0.txt` — GNU LGPL v3.0
- `mpl-2.0.txt` — Mozilla Public License 2.0
- `apache-2.0.txt` — Apache License 2.0
- `mit.txt` — MIT License
- `bsd-3-clause.txt` — BSD 3-Clause License

For any license outside this list (e.g. PolyForm Noncommercial, Business Source License, or a custom proprietary license), don't generate it from memory — look it up on the web and copy it verbatim, or confirm the exact text with the user if it's a custom proprietary license.

See `references/license-menu.md` for the full decision table on which license fits which project type, and `references/workflow.md` for the exact templates for each file to generate.
