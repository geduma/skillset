# Foundations

Core HIG principles plus color, shape, and desktop/mobile layout. Source: https://developer.apple.com/design/human-interface-guidelines/

## 1. Three principles

- **Clarity:** few elements, legible text, recognizable controls. Remove decoration that does not aid the task.
- **Deference:** UI floats above content and yields to it. Controls serve the content, never compete with it.
- **Depth:** distinct functional layers with hierarchy. Use elevation and material, not extra borders.

## 2. Color

Follow adaptive color: https://developer.apple.com/design/human-interface-guidelines/foundations/color

- Support Light, Dark, and Increased Contrast from one token set. Never ship a fixed hex for text or surfaces.
- Use CSS variables for background, text, accent, status. Example: `var(--bg)`.
- Key roles: background, secondary background, primary text, secondary text, accent, destructive, success.
- Standard iOS accent reference is `#007AFF`; adapt it to brand but keep one dominant accent with sharp usage.
- Check contrast in both modes before delivery (see motion-accessibility.md).

## 3. Shapes

- **Fixed:** constant corner radius for predictable cards and dialogs.
- **Capsule:** radius equals half the height. Use for pills, toggles, small buttons.
- **Adaptive:** radius follows the container. Use for sheets and large panels.
- Keep nested shapes concentric. Match device-like rounding on mobile; use smaller radii on dense desktop panels.

| Use | Desktop | Mobile |
|---|---|---|
| Card radius | 12-16px | 16-24px |
| Button | 8-10px or capsule | capsule preferred |
| Sheet/dialog | 16px, centered | large radius top, full-width |

## 4. Layout desktop vs mobile

Source layout: https://developer.apple.com/design/human-interface-guidelines/layout

- **Desktop:** sidebar + toolbar, multi-column, hover affordances, centered max-width 1024-1280px, generous whitespace.
- **Mobile:** single column, bottom tab bar, full-width sheets, respect safe areas and notch. No hover; 44pt minimum touch targets.
- Ask if scope is unclear: desktop-only, mobile-only, or responsive both.
- Breakpoints (adapt to project): mobile <768px, tablet 768-1023px, desktop >=1024px.
- Never hide primary actions behind hover on mobile. Never stretch desktop multi-column into a narrow phone without collapsing.

## 5. Official entry points

- Get started: https://developer.apple.com/design/get-started/
- Resources and kits: https://developer.apple.com/design/resources/
