# Pull Requests

Source baseline: GitHub Flow PR guidance + GitHub Docs on pull requests, branches, and status checks.

## 1. Size and title

- Keep PRs small and single-purpose; under ~400 changed lines is a good ceiling.
- Title follows commit style: `feat(auth): add refresh-token rotation`.
- Body states problem, approach, test evidence, and linked issue (`Fixes #123` for auto-close).

## 2. Body template (adapt, do not hardcode the tracker)

```
Summary: <what and why>
Issue: Fixes #<id>
Type: feat | fix | docs | refactor | test | chore (+ breaking y/n)
Testing: <commands run + result>
Screenshots: <if UI change>
```

## 3. Review rules

- Request review from owners of touched areas; use draft PRs for early feedback.
- Reviewers comment on lines, suggest code where possible, approve only when checks pass.
- Author responds to every thread; pushes fixes as new commits during review, squashes only at merge if policy says so.
- Never merge with failing checks or unresolved threads without explicit owner approval.

## 4. Merge strategy

- Default: squash-and-merge for topic branches to keep default history linear and conventional.
- Use regular merge only when preserving per-commit history matters (releases, multi-part features).
- After merge: delete the topic branch; history stays in the PR record.
