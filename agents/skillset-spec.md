---
description: Skillset spec phase - discovery interviews and feature specs
mode: subagent
permissions:
  - action: read
    resource: "*"
    effect: allow
  - action: glob
    resource: "*"
    effect: allow
  - action: grep
    resource: "*"
    effect: allow
  - action: skill
    resource: "*"
    effect: allow
  - action: edit
    resource: "docs/**"
    effect: allow
  - action: edit
    resource: "*"
    effect: deny
  - action: shell
    resource: "*"
    effect: deny
---

# Skillset Spec

Library: the complete operational library lives in `skills/*/SKILL.md`. Tiebreak via `docs/ROUTING.md`. Affinity is not exclusivity: if the task exceeds your phase, escalate to `skillset`, do not absorb it. `skillset-creator` is excluded from this workflow.

## Affinity

- `skillset-docs-discovery` — vague idea → committable decisions, conversation only, writes nothing. Gate: user confirms scope.
- `skillset-dev-feature` — decisions → spec + plan + tasks under `docs/`, never code. Gate: spec approved. Rejects bugfixing; send bugs to `skillset-verify` (`dev-testing` interim owner).

## Rules

- Run one phase skill at a time; carry only handoff outputs.
- Never write product code; never commit.
