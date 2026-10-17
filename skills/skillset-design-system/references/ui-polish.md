# UI Polish & Craft

Fine visual detail work for interfaces that feel intentional, not generated. Adapted from `better-ui`, `impeccable`, `baseline-ui`, and `deslop` in the UI Skills catalog. Applies on top of `craft.md` (which sets intent and universal anti-patterns).

This file covers the "last 10%" of visual quality: hover states, shadows, borders, micro-interactions, optical alignment, and anti-slop guards.

## 1. Hover and active states

- Every interactive element (button, link, card action, chip) needs a visible hover state.
- Hover should change one thing: color, underline, shadow lift, or scale — never all at once.
- Active/press feedback: subtle scale to 0.96–0.98, 100–150ms, ease-out.
- Disabled states: lower opacity (≈40–50%), cursor not-allowed, no hover/active effects.
- Focus rings are mandatory on all interactive elements; never remove outlines without a `:focus-visible` replacement.

## 2. Shadows and elevation

- Shadows show depth; borders show structure. Do not mix depth strategies randomly.
- No dramatic drop shadows (e.g. `box-shadow: 0 25px 50px rgba(0,0,0,0.25)`). Use soft, layered elevation: small offset (2–6px), low blur (4–12px), low opacity (8–15%).
- One elevation token per layer level (raised, sheet, modal, overlay). Do not invent ad-hoc shadow values per component.
- Dark mode: shadows should darken or disappear; do not use black shadows on dark surfaces.

## 3. Borders and structure

- Borders are structural, not decorative. No thick decorative borders (2px+) for visual weight.
- Border color: one neutral token, light enough to disappear until structure is needed.
- Border radius: consistent scale (sm/md/lg/full). Nested radius formula: `inner radius = outer radius − padding`.
- Images: neutral thin outline instead of tinted ring when a border is needed.

## 4. Micro-interactions

- Press/toast/toggle feedback: use `ease-out`, not springs (springs can wobble on feedback).
- Entrances: stagger hero animations ~100ms on first load only, not on routine interactions.
- Exits: short and subtle (small `translateY`, fade out), matching the enter path.
- Menus/popovers: animate from their trigger; fade out on close, do not slide far off-screen.
- Icon state changes: cross-fade with opacity + scale + blur for smoother feedback.
- Avoid glow effects on primary actions; use contrast and spacing instead.

## 5. Optical alignment

- Align icons by eye, not geometrically; nudge when optical centering looks better.
- Match icon stroke weight to text: ~2px stroke beside semibold text, ~1.5px beside regular text.
- Use outline icons by default; filled icon only for the active/selected state.
- Tighten heading line-height (~1.1 for short headings).
- Tune tracking (letter-spacing) for large display text: slightly tighter.
- Cap body line length: 60–75 characters (desktop), 32–45ch (mobile).

## 6. Anti-slop guards (always wrong regardless of context)

- Dramatic drop shadows such as `box-shadow: 0 25px 50px`.
- Arbitrary asymmetric padding without intent.
- Thick decorative borders (2px+) for visual weight.
- Multiple competing accent colors; keep one per view.
- Mixing depth strategies randomly (borders plus shadows on the same element).
- Inconsistent spacing scale.
- Placeholder text used as the only form field label.
- Glow effects on primary buttons.

## 7. Self-check before showing

- Swap test: replace typeface/layout with the usual default — would anyone notice? Where not, you defaulted.
- Squint test: blur eyes. Hierarchy still readable? Nothing jumps out harshly?
- Signature test: point to components where the product signature appears.
- Token test: read CSS variables aloud. They belong to this product world, not any project.

## 8. Output format

Report visual findings as terse `file:line` notes, grouped by blocking then polish:

```
components/Button.tsx:14 missing hover state on primary variant
components/Card.tsx:28 dramatic drop shadow violates elevation guard
components/Input.tsx:42 placeholder used as sole label (accessibility blocker)
```

See `craft.md` for intent foundations and `motion-systems.md` for motion detail. Routing conflicts: see `docs/ROUTING.md`.
