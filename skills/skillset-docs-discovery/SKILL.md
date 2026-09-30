---
name: skillset-docs-discovery
description: Use this when shaping a vague or loose idea before any spec or code exists - feature direction, product call, business decision, scope choice - or when the user says grill this idea, sharpen the scope, challenge my assumptions, help me decide what to build, or interview me until it is committable. Do not use for recording decided docs - use skillset-docs-project.
license: MIT
allowed-tools: Read Glob Grep
metadata:
  version: 1.1.0
---

# Discovery Interview

Turns a loose idea into committable decisions through structured rounds of questions, before any spec or code.

This skill is project-agnostic. It writes no files; decisions stay in the conversation until handed to spec or docs. It adapts to any domain, not only software.

## When to use this

- The user has an idea worth taking seriously but cannot yet specify it precisely.
- The user asks to be interviewed, grilled, challenged, or sharpened on scope.
- Assumptions are implicit and need surfacing before writing a spec or ADR.
- A prior attempt stalled because the scope was too large or too vague.

## Non-negotiable principles

1. **Ask for what varies.** If goal, audience, constraints, or scope are unclear, ask. See `references/interview-rounds.md`.
2. **Rounds, not drips.** Ask the whole frontier at once, then build next rounds on answers. See `references/interview-rounds.md`.
3. **User owns scope.** Demand pushback; passive agreement is failure. See `references/interview-rounds.md`.
4. **Talk vs build split.** Verbal questions stop where a throwaway is needed. See `references/grillable.md`.
5. **Small scope per session.** Split large efforts before grilling. See `references/scope-signals.md`.
6. **Confirm before persisting.** Interview writes nothing; persisting to spec or ADR needs explicit approval.

## Workflow (summary)

1. **Frame and round** — confirm goal and scope, then ask each round as a batch per `references/interview-rounds.md`.
2. **Sort talk from build** — route feel or layout questions to a throwaway per `references/grillable.md`.
3. **Watch scope signals** — split, pause, or close per `references/scope-signals.md`.
4. **Close defensibly** — user can defend each choice; hand the same conversation to spec or `skillset-docs-project` only on approval.

See `references/interview-rounds.md`, `references/grillable.md`, `references/scope-signals.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
