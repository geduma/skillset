# Motion Systems

Purposeful interface motion: when to animate, which tool, which properties, curves, durations, interruption, and exit. Adapted from `animate`, `improve-animations`, `animation-systems`, `feel`, and `12-principles-of-animation` in the UI Skills catalog.

Applies on top of `motion-accessibility.md` (which sets durations and accessibility baseline). This file adds the decision system: should it animate at all, and how to make it feel physical rather than canned.

## 1. Should it animate at all? (decision order)

Decide in this order before writing any animation code:

1. **Purpose** — what does the motion communicate? (state change, hierarchy, spatial relationship, feedback)
2. **Tool** — CSS transitions for state toggles; CSS keyframes for loops; WAAPI/JS for gesture-driven or physics-based motion.
3. **Properties** — animate only `opacity` and `transform` (composite-only). Never animate `blur`, `width`, `height`, `top`, `left` per frame.
4. **Curve and duration** — `ease-out` for entrances and feedback; springs only when a physical "feel" is requested.
5. **Interruption** — respond to new input mid-animation; animations must be interruptible.
6. **Exit** — match the enter path; keep exits short and subtle.

Default answer for routine UI (tab switches, routine clicks): **instant, no animation**. Animate first-load entrances and meaningful state changes only.

## 2. Durations and easing (reference)

| Moment | Duration | Easing | Notes |
|--------|----------|--------|-------|
| Hover | 150ms | ease-out | Subtle, immediate |
| Press / tap | 100ms | ease-out | Acknowledge within 100ms |
| Sheet / drawer open | 250–300ms | ease-out | Physical but quick |
| Page reveal (staggered) | 50ms steps | ease-out | First load only |
| Toast / feedback | 150–200ms | ease-out | No spring wobble |
| Exit / close | 150ms | ease-out | Short, matching enter |

## 3. Physics-based motion ("feel")

When a user describes how something should *feel* ("heavy toggle", "magnetic drawer", "card thrown into a corner", "knob with detents"), use a physical model instead of durations and curves:

- Mass, stiffness, damping define the spring.
- Force fields: magnets, friction, walls.
- Output can be exported to Framer Motion, react-spring, SwiftUI, Compose, or CSS `linear()`.
- Include a test rig that plots position, velocity, and force field, overlaying model prediction on measured motion.

Do not use physics for routine UI; reserve for interactions where the metaphor matters.

## 4. Animation systems (not one-offs)

When building coherent motion across a product, define a system:

- Named easing tokens (`ease-out-quick`, `ease-out-smooth`, `spring-gentle`, `spring-crisp`).
- Named duration tokens (fast 100–150ms, normal 250–300ms, slow 400–500ms).
- Stagger step token (~50–100ms) for list reveals.
- Reduced-motion variant for every animated token.

## 5. Performance

- Animate composite-only properties (`opacity`, `transform`).
- Keep motion off the main thread when the page is busy.
- Use `will-change` sparingly, only on elements that will animate soon; remove after animation ends.
- Avoid animating `blur` radius per frame — expensive paint.
- List animated properties explicitly; never `transition: all`.

## 6. Reduced motion and accessibility

- Honor `prefers-reduced-motion`: disable parallax, large transitions, and muted decorative loops.
- Offer a reduced variant (fade instead of slide, instant instead of spring).
- Motion longer than ~5 seconds alongside other content needs pause, stop, or hide controls.
- Increased Contrast: switch glass/blur to solid backgrounds.

## 7. Find animation opportunities

Audit for high-conviction motion:

- First-load page reveals (staggered).
- State changes that need spatial context (modal open, sheet expand).
- Feedback on user action (press, toggle, submit).
- Drag/swipe/sheet gestures with momentum.

Reject: noise animation, repeated loops on routine UI, entrance-from-scale-zero, anything that slows the user down.

See `motion-accessibility.md` for accessibility baseline and WCAG rules. Routing conflicts: see `docs/ROUTING.md`.
