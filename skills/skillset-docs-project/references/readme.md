# README

Source baseline: community README conventions (GitHub docs on READMEs); keep install copy-paste runnable.

## 1. Required sections

- Title plus one-line purpose; badges only if they reflect real checks.
- Quickstart: prerequisites, install, minimal run — every command tested before writing.
- Usage: one canonical example with expected output.
- Configuration: env vars and defaults in a table; link `.env.example`, never real secrets.
- License pointer plus link to CONTRIBUTING and CHANGELOG.

## 2. Rules

- File is `README.md` at repo root; keep it scannable — detail goes to `docs/`, not into bloat.
- All commands runnable from a fresh clone; state OS and toolchain versions.
- Screenshots only for UI changes; keep them current or drop them.
- Never document behavior the code does not have; fix the code or the doc, do not let them drift.

## 3. Onboarding check

- Fresh-clone test: clone to a temp dir, follow the README verbatim, report the first failing step.
- If setup exceeds ~10 minutes, add a troubleshooting section with exact errors and fixes.
