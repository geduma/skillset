# Host adapters

The workflow in this pack is tool-agnostic. The same five agents, phase map, planning gate, and handoff rules apply in every supported host. Only two things change per host:

1. **Frontmatter** — the metadata the host reads to register an agent.
2. **Invocation syntax** — how the agent loads a skill and delegates a phase.

Both live in `adapters/<host>/`, generated from the canonical files in `agents/`.

## Architecture

```
agents/<name>.md                  canonical: neutral frontmatter + workflow body
adapters/<host>/manifest.json     host frontmatter + adapter note
adapters/<host>/agents/<name>.md  generated: host frontmatter + canonical body + host note
```

- `agents/` is the single source of truth. Edit it, never the generated files.
- `scripts/build-adapters.py` regenerates every adapter and supports `--check` for drift detection.
- `scripts/validate-pack.py` runs the drift check and rejects host-specific tokens in canonical agents.
- `install.sh --tool <host>` installs the matching adapter; `--tool all` installs every host.

## Supported hosts

| Host | Adapter | Skill loading | Delegation | Gate enforcement |
|---|---|---|---|---|
| OpenCode | `opencode` | `skill` tool | `subagent` tool | `permissions` by path (strongest) |
| Claude Code | `claude` | `Skill` tool | `Task` tool (`subagent_type`) | `tools` allowlist + prompt |
| Codex CLI | `codex` | installed `SKILL.md` or native loader | phase prompt or sequential | sandbox + approval + prompt |
| Generic (Cursor, Copilot, others) | `generic` | installed `SKILL.md` | sequential role switch | prompt only |

The planning gate, agent map, and handoff rules are identical in all four. Where a host cannot enforce a rule structurally, the adapter states that the rule is a mandatory instruction rather than a runtime guarantee.

## Install

```bash
./install.sh --global --tool opencode   # one host
./install.sh --global --tool claude
./install.sh --global --tool codex
./install.sh --global --tool generic
./install.sh --global --tool all        # default
```

Use `--tool` with `uninstall.sh` to remove one host. `--copy`, `--prune`, and `--force` work as before.

## Regenerate after editing agents

```bash
python3 scripts/build-adapters.py           # write adapters
python3 scripts/build-adapters.py --check   # fail on drift
python3 scripts/validate-pack.py            # full pack validation
```

Commit both `agents/` and `adapters/`: adapters are generated but versioned so installs do not require Python.

## Add a host

1. Create `adapters/<host>/manifest.json` with `host`, per-agent `frontmatter`, and a `note` explaining skill loading, delegation, and enforcement.
2. Add the host to `HOSTS` in `scripts/build-adapters.py` and to the target mapping in `install.sh` / `uninstall.sh`.
3. Run `python3 scripts/build-adapters.py`.
4. Add the host to `docs/ADAPTERS.md`, `README.md`, and the validator's `HOSTS` tuple.
5. Run `python3 scripts/validate-pack.py`.

## Limitations

- **OpenCode** is the only adapter with path-level write enforcement. Claude Code, Codex, and generic hosts rely on the `tools` allowlist, sandbox settings, or the prompt.
- **Nested delegation:** some hosts do not allow a subagent to spawn another subagent. In that case the `skillset` agent runs the phase sequentially under the phase agent's instructions; the handoff and gate remain mandatory.
- **Sequential fallback:** if a host has no subagent mechanism, the phase agent runs in the same session under its own instructions. The handoff and gate remain mandatory; the primary must not skip the phase.
- **No host-specific content in `agents/`:** the validator rejects `subagent`, `permissions`, `skill` tool, `mode: primary`, `mode: subagent`, `OpenCode`, and `opencode` in canonical agent bodies.
