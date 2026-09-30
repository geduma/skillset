# Debugging

No fixes without root cause investigation first. Complete each phase before the next.

## 1. Root cause investigation

- Read error messages and stack traces completely; note files, lines, and codes.
- Reproduce consistently with exact steps and environment. If not reproducible, gather more data instead of guessing.
- Check recent changes: diff, commits, dependencies, config, environment differences.
- For multi-component systems, instrument each boundary: log what enters and exits, verify config propagation, check state per layer. Run once to locate the failing layer, then investigate only that layer.
- For deep stacks, trace backward: where did the bad value originate, what caller passed it, repeat until the source is found. Fix at the source.

## 2. Pattern analysis

- Find a similar working example in the same codebase.
- When applying a pattern, read the reference implementation completely before adapting it.
- List every difference between working and broken, however small; check dependencies, settings, and assumptions.

## 3. Hypothesis and testing

- State one hypothesis: what the root cause is and why, in one sentence.
- Test with the smallest single-variable change. Never stack multiple fixes.
- If it fails, form a new hypothesis with the new evidence. Admit what is not understood and research or ask.
- If fewer than three fixes failed, return to phase 1. If three or more failed, question the architecture with the user before any further fix.

## 4. Fix and lock

- Write the smallest failing test before touching production code; confirm it fails for the right reason.
- Apply one root-cause fix without bundled refactoring.
- Rerun the related suite plus typecheck and lint; report what ran and what failed.
- For intermittent bugs, measure failure rate before and after. If truly environmental, document the investigation and add handling plus logging.

## 5. Ask the user

- Exact reproduction steps and environment if missing.
- Whether the fix may change behavior others rely on.
- Approval before questioning architecture or rewriting broadly. See `references/red-flags.md`.
