# ADRs

Source baseline: Michael Nygard Documenting Architecture Decisions (Cognitect 2011); adr.github.io; GDS Way on ADRs.

## 1. When to write one

- Structurally significant choices: stack, data model, API shape, auth, infra, or anything costly to reverse.
- One record per decision; small reversible choices do not need ADRs.

## 2. Location and naming

- Path: `docs/adr/` in the repo that the decision affects; Markdown, reviewed in a PR like code.
- Files: `NNNN-short-title.md`, monotonic numbering, e.g. `0001-use-postgres-for-ledger.md`.
- Drafts may use PR status as lifecycle; accepted records become immutable — supersede with a new ADR, never rewrite.

## 3. Nygard template (keep short)

```
# <Title: decision, not problem>
Status: Accepted
Context: <facts forcing the decision>
Decision: <what we will do>
Consequences: <good + bad outcomes>
```

- Context states forces and constraints; Decision is one clear choice; Consequences lists trade-offs honestly.
- Alternatives considered belong in Context briefly — a sentence each, not essays.

## 4. Index

- Keep `docs/adr/README.md` as the decision log index linking every ADR with its status.
