# Components

Apply foundations and glass to common web patterns, with desktop and mobile variants.

## 1. Navigation

- Desktop: sidebar for sections plus top toolbar for search and actions.
- Mobile: bottom tab bar with 3-5 destinations plus top bar for title and one action.
- Glass applies to the bar container, not each item. Active item uses accent plus label; inactive uses neutral icon.

## 2. Buttons and inputs

- Primary: filled accent, white text, capsule or 10px radius. Secondary: tinted fill. Tertiary: plain text.
- `cursor-pointer` on all clickable elements. Pressed state scales slightly; disabled state lowers opacity, never relies on hue alone.
- Inputs: filled secondary background, 10px radius, visible label above, error text below with icon. Never placeholder-only.
- Desktop shows shortcuts and hover hints; mobile uses large 48px height inputs with full-width layout.

## 3. Cards, sheets, dialogs

- Cards: solid surface, 12-16px desktop and 16-24px mobile, one shadow level. Glass only when floating above scrolling content.
- Sheets: mobile slides from bottom full-width; desktop centers as dialog max-width 480-640px.
- Alerts and onboarding use left-aligned title and body per 2025 HIG direction.

## 4. Lists and data

- Desktop tables with sticky header; mobile collapses rows into stacked cards.
- Long lists use `content-visibility: auto` for rendering, not pagination by default.
- Charts need labels plus values, never color-only legends.

## 5. Pre-delivery checklist

- Visual: one accent, consistent radii, no emoji icons, borders visible in both modes.
- Glass: single layer, legible text, solid fallback present.
- Responsive: no horizontal scroll at 360px, no hover-only actions on mobile, sidebar collapses correctly on desktop.
- Type: two families max, roles consistent, 17px-equivalent minimum for mobile body.
- Motion and a11y: transitions 150-300ms, reduced-motion path works, contrast passes, focus visible, inputs labeled.
