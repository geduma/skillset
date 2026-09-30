# Branches

Source baseline: GitHub Flow (docs.github.com/en/get-started/using-github/github-flow) — branch, change, PR, review, merge, delete.

## 1. Naming and lifetime

- Branch from the updated default branch (`main` or the repo's default; check first, never assume `master`).
- Format: `type/short-intent`, e.g. `feat/user-pagination`, `fix/login-timeout`, `docs/readme-quickstart`.
- Types mirror commit types: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`.
- One intent per branch. Unrelated changes get separate branches so reviews stay small.
- Short-lived: sync with default frequently, merge as soon as approved, delete after merge.

## 2. Sync rules

- Update the branch with the default branch before opening a PR and before merging.
- Prefer merge of default into topic branch for shared branches; rebase only for purely local branches.
- If the branch is stale or conflicts, resolve early — never let a branch drift for weeks.

## 3. Protection

- Default branch is protected: no direct pushes, require PR + approving review + green checks.
- Require up-to-date branch before merging where the host supports it.
- Confirm with the user before changing protection rules or merge policies.

## 4. Ask the user

- What is the repo's default branch and host if not visible?
- Should this branch target a release branch instead of default?
