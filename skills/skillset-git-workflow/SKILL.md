---
name: skillset-git-workflow
description: Use this when creating branches, writing commit messages, following Conventional Commits, opening or reviewing pull requests, resolving merge conflicts, choosing merge versus squash versus rebase, or setting up branch protection. Also use when the user says commit this, open a PR, review my PR, or fix my git history. Do not use for code style, lint, or formatting gates - use skillset-dev-style.
license: MIT
allowed-tools: Read Shell Glob Grep
metadata:
  version: 1.2.0
---

# Git Workflow

Runs a clean branch-based workflow in any repo: short branches, conventional commits, small reviewable PRs, safe history.

This skill is project-agnostic. It adapts to the repo's default branch and host (GitHub, GitLab, or other) and never hardcodes branch names or ticket systems.

## When to use this

- The user asks to commit, branch, push, open, review, or merge a PR.
- The user asks about Conventional Commits, commit scope, or breaking changes.
- A merge conflict or messy history needs cleanup.
- Branch protection or merge policy needs setup.

## Non-negotiable principles

1. **One branch per change.** Short-lived topic branch from the default branch. See `references/branches.md`.
2. **Conventional Commits always.** Type, optional scope, description; breaking changes via footer or mark. See `references/commits.md`.
3. **Small PRs win.** One intent per PR, linked issue, green checks before merge. See `references/pull-requests.md`.
4. **Never rewrite published history silently.** Rebase only local commits; revert instead of force-pushing shared branches. See `references/history-safety.md`.
5. **Confirm before destructive git.** Force-push, reset hard, history rewrite, branch deletion: summarize first, wait for approval.
6. **No auto-commit/push.** Default: never `commit`/`push` without an explicit request; propose the diff and wait. Override: see `references/commits.md` section 5.

## Workflow (summary)

1. **Branch** — create a descriptive topic branch from updated default. See `references/branches.md` section 1.
2. **Commit** — atomic commits in Conventional Commits format per `references/commits.md`.
3. **Open PR** — small scope, template body, request review, keep checks green per `references/pull-requests.md`.
4. **Merge safely** — resolve conflicts, pick merge strategy, delete branch after merge per `references/history-safety.md`.

See `references/branches.md`, `references/commits.md`, `references/pull-requests.md`, `references/history-safety.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
