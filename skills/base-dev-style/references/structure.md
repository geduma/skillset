# Structure

Predictable layout observed across the user's projects, expressed without assuming a language.

## 1. Detect before touching

- Read the manifest (`package.json`, `pyproject.toml`, `go.mod`, etc.), the top-level folders, and `docs/`.
- Note existing entry points (`src/index.*`, `src/main.*`), config location, and test runner. Adapt; do not restructure to match another project.

## 2. Canonical layout

- `src/` holds runtime code only. Group by role, not by layer count:
  - `config/` — load, normalize, validate configuration. One module owns defaults plus environment overrides.
  - `routes/` + `handlers/` — transport thin layer; no business logic.
  - `services/` — business logic, one domain per file.
  - `middleware/` — cross-cutting request pipeline pieces.
  - `db/` + repositories — persistence boundary; queries live here, not in handlers.
  - `utils/` — pure, dependency-free helpers only. If it needs I/O, it is not a util.
  - `types/` — shared contracts and interfaces.
- `tests/` or `test/` mirrors `src/`. Unit tests next to the domain they cover.
- `scripts/` holds deterministic helpers (bootstrap, prestart, maintenance). Not business logic.
- `docs/` holds `AGENTS.md` (agent operating notes) and `PRD.md` (what the project does).
- `config/` holds a single validated config file plus `*.example.*` templates. Never commit real secrets.
- `docker/` holds container files. `frontend/` stays separate and self-served when present.

## 3. Placement rules

- New code goes where its role lives, not where the author opened the editor.
- Shared code used by two domains moves down to `utils/`, `types/`, or a `shared/` package. No cross-imports between siblings.
- Config keys use dotted paths (`server.port`, `security.encryptionKey`) with a single normalization point that fills defaults with nullish coalescing.
- Runtime version is pinned once (`engines` plus lockfile plus version file where the ecosystem supports it).

## 4. What to reject

- Flat dumps of 30 files in one folder.
- Business logic inside route handlers or UI components.
- Duplicate config loaders per module; there is exactly one.
- Committed secrets, local-only paths, or machine-specific overrides.
