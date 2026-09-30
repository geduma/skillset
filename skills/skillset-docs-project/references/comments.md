# Comments

Covers code comments, docstrings, and API reference discipline.

## 1. Why, not what

- Explain intent, constraints, and non-obvious trade-offs; never restate the code line.
- Reference the ADR or issue for context (`See ADR-0007`), do not duplicate its reasoning.
- Public APIs get docstrings (params, returns, errors, example); internals get comments only where the why is unclear.

## 2. What to delete

- Dead code blocks, commented-out experiments, and `TODO` without owner plus issue link.
- Noise headers (`Created by X on <date>`) and apology comments — fix or file, do not narrate.
- Stale comments that contradict the code; treat them as bugs.

## 3. Freshness

- Update comments in the same diff that changes the behavior; reviewers reject doc drift.
- Prefer self-describing names over compensating comments (see `skillset-dev-style`).
