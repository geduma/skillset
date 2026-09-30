# Components and State

Framework-agnostic component rules. Adapt syntax to the detected stack.

## 1. Component architecture

- One job per component. If props pass through more than 3 levels unused, introduce context, store slice, or restructure.
- Prefer composition over configuration: `children` or slots over `headerVariant` or `bodyPadding` props.
- Keep presentational components pure; push side effects to containers, loaders, actions, or composables.
- File placement follows the project convention. Never invent a new top-level folder without asking.

## 2. Server vs client state

- **Server state:** remote data with caching, dedup, retry, stale time. Use the project data library (Query, SWR, loader, Pinia, signals). Never copy server data into local state without a sync rule.
- **Client state:** UI-only — selection, filters in URL when shareable, dialog open, draft input. Keep it local first.
- **Global store:** only for complex client state shared app-wide. Default to local state plus URL.
- URL holds shareable view state: page, filter, sort, selected tab. Everything else stays in memory.
- Reflect filters, tabs, pagination, and expanded panels in the URL so views are deep-linkable and shareable.
- Use real links for navigation to preserve open-in-new-tab and assistive tech behavior.
- Destructive actions need confirmation or an undo window, never immediate execution.

## 3. Data flow rules

- Unidirectional flow. Events go up, data goes down.
- Derive, do not sync: use computed or memo for filtered lists, totals, visibility.
- Side effects live in one place per framework: effect, watcher, loader, or subscription with cleanup.
- Cancel stale requests on navigation or new input; ignore late responses.

## 4. Resilience

- Never leave a view without a state: loading skeleton, error with retry, empty with action, success.
- Keep form drafts and scroll position on error. Never clear user input on failure.
- Log with context: component, action, request id. No silent catch.
