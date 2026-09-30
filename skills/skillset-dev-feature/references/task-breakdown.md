# Task Breakdown

Source baseline: `planning-and-task-breakdown` vertical slices, sizing, checkpoints; `spec-kit` tasks phases.

## 1. Location and safety

- Default: `docs/features/NNN-slug/tasks.md` next to `spec.md` and `plan.md`.
- If the project designates another tracker (Issues, Jira, Linear, `tasks/todo.md`), use it and keep `tasks.md` as an ordered index of IDs.
- Never overwrite a file with unchecked tasks for different work. Same work means revise in place; different work means stop and ask.

## 2. Slice vertically, order by dependencies

- One slice delivers working behavior: migration plus endpoint plus UI for one story.
- Bad: all schema, then all API, then all UI. Good: US-1 end to end, then US-2.
- Foundations first, high-risk early, polish last.

## 3. Sizing

| Size | Files | Rule |
|---|---|---|
| S | 1-2 | One endpoint or component |
| M | 3-5 | One story slice |
| L | 5-8 | Split unless trivial |

- No XL tasks. If acceptance needs more than 3 bullets, split it.
- Title with "and" usually means two tasks.

## 4. Task format

```
## Task N: <short title> [P if parallelizable]
Description: <one paragraph outcome>
Acceptance:
- [ ] <testable condition>
Verification:
- [ ] <focused test + build command from AGENTS.md>
Dependencies: <None | Task N>
Files likely touched:
- `path/to/file`
Estimated scope: <S | M | L>
```

## 5. Checkpoints and approval

- Checkpoint after every 2-3 tasks: tests pass, build clean, story demoable.
- Final checkpoint is human review of spec, plan, and tasks.
- Last functional phase is always the docs-sync task per `references/docs-sync.md`.
