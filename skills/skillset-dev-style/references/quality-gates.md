# Quality gates

Tool classes extracted from the user's projects. Apply the equivalent in the current stack. Never switch languages to match an example.

## 1. The four gates

Every change passes, in order:

1. **Linter** — catches unused code and unsafe idioms.
2. **Strict checker** — catches type and contract errors.
3. **Formatter** — ends style debates mechanically.
4. **Tests** — proves behavior did not regress.

If a gate is missing, ask before adding one. Do not invent tooling silently.

## 2. Reference behavior (adapt, do not copy verbatim)

- **Lint:** fail on unused vars with `^_` escape for intentionally unused args; warn on loose dynamic types; enforce immutable bindings (`prefer-const`, no `var` equivalent); warn on raw console output in production code.
- **Strict check:** strictest null and type mode the toolchain supports; reject unused locals and params; reject implicit fallthrough in switches; enforce consistent file casing; isolate modules where the toolchain offers it.
- **Format:** 2-space indent, LF endings, UTF-8, trim trailing whitespace, final newline. One shared config at repo root (`assets/editorconfig.template`).
- **Tests:** separate `tests/` tree mirroring `src/`; `test` runs once, `test:watch` runs during development. Prefer the runner the project already uses.

## 3. Workflow rules

- `lint`, `typecheck` (where applicable), `test`, and `build` are named scripts at the repo root or per package in a monorepo.
- Fix the root cause, not the warning. Suppress a rule only with a one-line justification comment scoped to that line.
- Keep vendor and generated output out of lint scope (`dist/`, `node_modules/`, `coverage/` equivalents).
- Frontend and backend may have separate configs but share the same strictness intent.

## 4. What to reject

- Disabling a gate to make a diff pass.
- Global suppressions without expiry or reason.
- Formatting-only churn mixed into logic diffs. Format first, then change logic.

## 5. Design quality gates (Playbook from ui-skills.com)

Applied during frontend and visual code reviews. Verified as `file:line` findings.

- **Touch targets:** minimum 44×44px on mobile; ≥24px with generous padding on desktop.
- **Line length:** body text 60–75 characters (desktop), 32–45ch (mobile).
- **Accent discipline:** one accent color per view; secondary actions neutral; brand color reserved for links and actions.
- **Depth strategy:** shadows show depth, borders show structure; never mix both on the same element.
- **Motion:** entrances use `ease-out`; exits short and subtle matching the enter path; no scale-from-zero entrances; animate only `opacity` and `transform`.
- **Layout shift:** images and frames declare `aspect-ratio`; full-width buttons stay inside page margins, not edge to edge.
- **Focus:** visible focus ring via `:focus-visible` on all interactive elements; never remove outline without replacement.
- **Color meaning:** status never conveyed by color alone — always paired with icon + label.
- **Form fields:** visible label on every field; placeholder never the sole label; errors shown directly beside each field.
- **Destructive actions:** confirmation required before delete or irreversible action.
