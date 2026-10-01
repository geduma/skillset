---
name: skillset-legal-license
description: Use this skill whenever the user wants to add, choose, or fix a LICENSE file, protect their code/project from being exploited commercially without credit, set up copyright notices, or asks things like "protect my project", "I want to add a license", "I don't want anyone profiting off my code", "make this repo like [another project]", "add a LICENSE", or wants a repo prepared for public release/open-sourcing. Also trigger when the user references replicating licensing/legal setup done on a previous or sibling project. Always ask the user for the copyright holder name and the specific license before writing anything — never assume either.
license: MIT
allowed-tools: Read Write Edit Glob WebFetch
metadata:
  version: 1.2.0
---

# License Guardian

Prepares any repository with a proper license, copyright notice, and minimal documentation, consistently across projects.

## When to use this

- The user wants to add or change a project's license, or prepare a repo for public release.
- The user wants to "protect" code from others profiting off it without giving back.
- The user wants to replicate a licensing setup from a previous project.

## Non-negotiable principles

1. **Never assume holder or license.** Always ask both, every project. See `references/workflow.md` section 2.
2. **Never paraphrase legal text.** Copy verbatim from `assets/licenses/` or the official web source. See `references/licenses.md`.
3. **Never overwrite silently.** Existing license or many touched files: summarize first, wait for approval.

## Workflow (summary)

1. **Investigate** — README, manifest, structure; infer service vs library for a tentative pick. See `references/workflow.md` section 1 and `references/license-menu.md`.
2. **Ask** — holder name plus license menu choice; wait for decision. See `references/workflow.md` section 2.
3. **Generate** — `LICENSE` verbatim, README notice and section, manifest field per `references/workflow.md` section 3.
4. **Confirm before writing** when a prior license exists or many files change; otherwise proceed after choice.

See `references/license-menu.md`, `references/workflow.md`, `references/licenses.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
