# Commits

Source baseline: Conventional Commits 1.0.0 (conventionalcommits.org), Angular convention for extra types, SemVer mapping.

## 1. Format

```
type(optional scope): description

[optional body]

[optional footer(s)]
```

- `type`: `feat` (new feature), `fix` (bug fix). Others allowed: `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test`, `revert`.
- `scope`: noun for the codebase section in parentheses, e.g. `fix(parser):`.
- `description`: short imperative summary, lowercase, no trailing period.
- `body`: blank line after description, explains what and why, not how.
- `footer`: `Refs: #123`, `Reviewed-by: Name`; breaking changes as below.

## 2. SemVer mapping

- `fix:` maps to PATCH. `feat:` maps to MINOR.
- Any commit with `BREAKING CHANGE:` footer or `!` after type/scope maps to MAJOR, e.g. `feat(api)!:`.
- Other types cause no version bump unless they carry a breaking change.

## 3. Rules

- Atomic: one logical change per commit; split renames from behavior changes.
- If a change fits two types, split into two commits.
- Imperative mood: `add`, `fix`, `update` — not `added` or `adds`.
- Reference issues in footers (`Refs: #123`, `Fixes #123`), never only in the title.
- Squash-based repos: maintainers may clean titles at merge time; casual contributors still follow the format.

## 4. Reverts

- Use `revert: <original subject>` with `Refs:` to the reverted SHA(s).
- A reverted `feat` is not a `fix` unless it also patches behavior going forward.
