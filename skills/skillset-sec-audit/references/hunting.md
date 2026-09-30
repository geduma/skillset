# Coverage-Led Hunting

Goal: cover every ledger unit once with isolated hunters, then close gaps.

## 1. Assign hunters

- One hunter per ledger unit. Hunters do not share state.
- Each hunter records: unit id, checks run, files read, result of pass, candidate, or blocked.
- Update the ledger status to covered only with evidence; otherwise gap with reason.

## 2. Hunt method

- Follow user-controlled data from entrypoint to sink: params, headers, uploads, webhooks, queue payloads.
- Check auth first, then object auth, then injection, then logic abuse.
- Prefer reading code over running it. Do not execute target code without a sandbox.

## 3. Coverage critics

- After the first pass, run a fresh critic per area: which units lack auth checks, which inputs never reach a sink review, which tenants were never crossed?
- Reassign hunters only to gaps. Multiple runs are additive: reuse prior ledgers, revalidate changed files.

## 4. Candidate rules

- File a candidate only with file, lines, entrypoint, and observed effect.
- Mark blocked leads with the exact missing fact, for example no DB access to confirm RLS bypass.
- Run `scripts/validate-coverage-ledger.cjs` after each ledger update.

## 5. Out of scope

Memory-safety and binary, AI/LLM prompt injection, desktop and mobile IPC, and cloud and IaC misconfiguration belong to other audits. Note them as such, do not expand this hunt.
