# Structure and Token Budgets

## 1. Layout

```
skills/<skill-name>/
├── SKILL.md          (required — fully loaded on every activation: keep minimal)
├── references/        (optional — loaded on demand via explicit link, not upfront)
├── assets/             (optional — copied as-is: templates, license texts)
└── scripts/            (optional — deterministic helpers, not re-derived by the model)
```

## 2. Budgets (enforced by `scripts/package_skill.sh`)

| Location | Budget (enforced) | Holds |
|---|---|---|
| `SKILL.md` body | target ≤60 lines / ~800 words; **max 100 lines / 1500 words** | Trigger context, non-negotiable principles, 3–5 step workflow summary with links. No tables, no verbatim dumps, no examples longer than 2 lines. |
| Each `references/*.md` | **max 200 lines / 2000 words**; one topic per file | Decision tables, style guides, templates, detailed steps. Split the file if it exceeds this. |
| `assets/`, `scripts/` | not counted | Verbatim content (license texts) and code. Never inline these into `SKILL.md`. |

## 3. What stays vs. what moves

`SKILL.md` answers *when to fire* and *what to do first*; `references/` answers *how, exactly, for this edge case*. Pattern to copy: `skillset-legal-license` in this repo (short `SKILL.md`, detail in `references/license-menu.md` + `references/workflow.md`, verbatim text in `assets/`).

## 4. Banned in `SKILL.md`

Decision tables, full API/config dumps, duplicated examples, troubleshooting catalogs, prose paragraphs restating what a linked file already says. If a section is only needed for some activations, it belongs in `references/`.
