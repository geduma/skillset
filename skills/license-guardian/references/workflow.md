# Detailed workflow

## 1. Read the project before asking anything

Before showing the license menu, inspect the repo so you arrive informed:

- `README.md` / `README` — to understand what the project does and whether it already mentions a license.
- Whatever dependency manifest exists: `package.json` (Node), `pyproject.toml`/`setup.py` (Python), `Cargo.toml` (Rust), `go.mod` (Go), `composer.json` (PHP), `*.csproj`/`*.sln` (.NET), `Gemfile` (Ruby).
- Folder structure (`src/`, `docker/`, routes like `/api`, `routes/`, `server.js`, `main.go`, etc.) — this tells you whether it's a **network service** (backend, API, proxy) vs. a **library/CLI** for local use.
- If a `LICENSE`/`LICENSE.txt`/`COPYING` file already exists — don't overwrite it without confirming with the user first; it may have been placed intentionally, different from what you're about to propose.

With this, arrive at the conversation with the user already holding a tentative recommendation (see `license-menu.md`), not asking blind.

## 2. Ask what you can't infer

Never assume these two facts — always ask, even if you already used them for another project in this same session:

1. **Name of the copyright holder** — real name or alias, exactly as the user wants it to appear legally. Clarify the difference if asked: an alias is legally valid for the notice, but the real name makes it easier to prove ownership if there's ever a formal dispute.
2. **Chosen license** — using the menu in `license-menu.md`. Present your tentative recommendation from step 1, but let the user decide or change it.

You can infer without asking:
- **Year** — use the current year, unless the user indicates otherwise (e.g. if the project started earlier).
- **Project name** — from `package.json`, `README.md`, or the repo name.

## 3. Generate the files

### a) `LICENSE`
Copy the full text verbatim from `assets/licenses/<spdx-id-lowercase>.txt` (e.g. `agpl-3.0.txt`, `mit.txt`) as-is, without summarizing or paraphrasing — these are legal texts, they must go verbatim. For MIT and BSD-3-Clause, replace the `[year]` and `[fullname]` placeholders with the user's data. For the GNU licenses (AGPL/GPL/LGPL) and Apache/MPL, the body text has no placeholders — the year and name only go in the short notice (next point), not in the legal body.

If the user chooses a license not in `assets/licenses/` (e.g. PolyForm Noncommercial, BUSL), look up the official text on the web before writing it — never generate it from memory or paraphrase it; copy it verbatim from the official source.

### b) Short copyright notice (for the README footer and/or source file headers)

Base template (adjust the license name based on what was chosen):

```
<Project name>
Copyright (C) <year> <copyright holder>

This program is free software: you can redistribute it and/or modify
it under the terms of the <License name> as published by
the Free Software Foundation, either version <N> of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
<License name> for more details.

You should have received a copy of the <License name>
along with this program. If not, see <https://www.gnu.org/licenses/>.
```

For MIT/Apache-2.0/BSD, use an equivalent short notice (copyright + reference to LICENSE), without the "WITHOUT ANY WARRANTY" block that's specific to GNU licenses.

Offer the user (don't do it without confirming) to add this notice as a comment at the top of the main source files — it's optional, recommended by the FSF but not mandatory.

### c) License section in the README

Add near the top of the README (or at the end, following whatever convention the project already has) something like:

```markdown
## License

This project is licensed under the <Name> — see [LICENSE](LICENSE) for details.
```

### d) License field in the manifest

Update the corresponding field based on the detected ecosystem:

| File | Field |
|---|---|
| `package.json` | `"license": "<SPDX-ID>"` (e.g. `"AGPL-3.0-or-later"`) |
| `pyproject.toml` | `[project] license = {text = "<SPDX-ID>"}` or `license = "<SPDX-ID>"` depending on the standard used (PEP 621 vs Poetry) |
| `Cargo.toml` | `license = "<SPDX-ID>"` |
| `composer.json` | `"license": "<SPDX-ID>"` |
| `go.mod` | Go has no license field in the manifest; the `LICENSE` file alone is enough |
| `.csproj` | `<PackageLicenseExpression><SPDX-ID></PackageLicenseExpression>` |

## 4. Confirm before writing

Before creating or overwriting files, summarize in a short list what you're about to create/modify (LICENSE, README, manifest, and source file headers if applicable) and wait for confirmation if the project already had a different license or if you're about to touch many source files at once. If the project had no prior license and it's only LICENSE + README + manifest, you can proceed directly after the choice in step 2.
