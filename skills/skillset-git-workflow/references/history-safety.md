# History Safety

Covers conflicts, rebase, revert, and destructive-command guardrails.

## 1. Conflicts

- Sync default into the branch, resolve in the working tree, rerun tests before pushing.
- Resolve meaning, not just markers: understand both sides, keep intent, drop stray markers.
- For generated files or lockfiles, prefer regenerating over hand-editing when the toolchain supports it.

## 2. Rebase versus merge versus revert

- Rebase: only for local commits never pushed to a shared branch.
- Merge: for integrating default into a shared topic branch.
- Revert (`git revert`): the default undo for anything already pushed or merged — creates a new commit, preserves history.
- Never `push --force` on shared branches without explicit confirmation listing who must re-sync.

## 3. Destructive commands need confirmation

- `reset --hard`, `clean -fd`, `push --force`, `filter-repo` / `filter-branch`, branch `-D`: summarize exact scope and get approval first.
- Secrets committed by accident: revoke the secret first (see `skillset-sec-appsec`), then purge history — revocation matters more than rewrite.

## 4. Recovery

- Deleted branch after merge: restorable from the merged PR record; note the PR number.
- Bad merge: revert the merge commit, do not rewrite default history.
