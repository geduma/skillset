# Foundation Adapters

Craft (`craft.md`) is generic and mandatory. Foundations are swappable. Apple HIG (`foundations.md`) is the default adapter, not a requirement.

## How to swap

1. Detect or ask the target system first: Apple HIG, Material 3, Fluent 2, brand tokens, or no system (greenfield).
2. Keep these invariant across adapters: content-first hierarchy, one accent role, systemic tokens, contrast in light/dark, desktop/mobile behavior.
3. Map roles, do not copy values:

| Role | HIG default | Material 3 | Fluent 2 |
|---|---|---|---|
| Background / surface | `var(--bg)` adaptive | `surface` / `surface-container` | `layer-fill` |
| Text primary / secondary | HIG text roles | `on-surface` / `on-surface-variant` | `text-primary` / `text-secondary` |
| Accent (one) | `#007AFF` adapted to brand | `primary` | `accent` |
| Shape | fixed / capsule / adaptive | `corner-small/medium/large` | `corner-radius` scale |
| Elevation | depth via material, not borders | tonal elevation | depth + shadow ramp |

## Rules

- Never mix two adapters' values in one UI (e.g. HIG radii with Material elevation).
- Liquid Glass (`liquid-glass.md`) applies only to the HIG adapter or an explicit glass request; never force it onto Material/Fluent.
- Typography: system stack by default (`typography-icons.md`); SF is HIG-only, Roboto is Material-only.
- When no system exists, derive tokens from the domain (see `craft.md` section 1) and record them as the project's adapter.
