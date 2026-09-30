# Motion and Accessibility

Motion sells the layer model; accessibility keeps it usable.

## 1. Motion principles

- One orchestrated moment beats scattered micro-animation. Animate page load with staggered reveals; keep the rest quiet.
- Glass reacts to touch with light and flex, then settles. On web: subtle scale 0.97-1.0 plus shadow change, 150-300ms.
- Preserve the floating-layer illusion: content moves under glass; glass itself barely moves.
- Durations: hover 150ms, press 100ms, sheet 250-300ms, page reveal staggered 50ms steps.
- Use CSS transitions and transforms (opacity, transform) only. Never animate blur radius per frame.
- List animated properties explicitly; never transition all properties at once.
- Set a correct transform origin; wrap SVG shapes in a grouping element with centered origin.
- Keep animations interruptible: respond to new input mid-animation.
- Motion longer than about 5 seconds alongside other content needs pause, stop, or hide controls.
- Honor reduced-motion settings with a reduced variant or disabled motion, including muted decorative loops.

## 2. Interaction patterns

- Acknowledge every tap within 100ms with visible feedback.
- Prefer direct manipulation: inline edit over separate forms, drag over steppers where sensible.
- Forgiving UI: confirm destructive acts, offer undo, keep form input on error.
- Progressive disclosure: summary first, details on demand, advanced settings last.
- Desktop gets hover and keyboard shortcuts; mobile gets swipe and long-press equivalents.
- Buttons and links need a hover state; interactive states stay more prominent than rest.

## 3. Accessibility baseline (WCAG 2.1 AA)

- Contrast minimum 4.5:1 for body text, 3:1 for large text and UI affordances.
- Never convey meaning by color alone. Pair status with icon plus label.
- Visible focus ring on all interactive elements. Keep logical heading order and labeled inputs.
- Never remove outlines without a focus-visible replacement; prefer focus-visible over always-on focus.
- Group focus styling for compound controls; keep sticky layers from covering the focused element.
- Touch targets minimum 44x44pt on mobile; pointer targets minimum 24px with generous padding on desktop.
- Support `prefers-reduced-motion` by disabling parallax and large transitions, and Increased Contrast by switching glass to solid.
- Contrast tools and link-purpose checks pair well with this file when auditing.

## 4. Audit output

- Report as terse `file:line` findings, one per issue, grouped by critical then minor.
- Example: `components/Card.tsx:42 low contrast body on glass in dark mode`.
