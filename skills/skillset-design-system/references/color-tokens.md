# Color Tokens

Strategic color systems for interfaces that feel dull, monochrome, or visually flat. Adapted from `better-colors` in the UI Skills catalog.

Applies on top of `craft.md` (color world intent) and `typography-icons.md` (copy/voice). This file covers the technical side: OKLCH workspace, palette generation, contrast, gamut, dark mode, and token layering.

## 1. Work in OKLCH

- Convert hex/rgb/hsl → OKLCH as the authoring space. OKLCH is perceptually uniform: changing lightness keeps hue stable.
- OKLCH syntax: `oklch(L% C H)` where L = lightness (0–100), C = chroma (color intensity), H = hue (0–360).
- Use OKLCH for design tokens; export to hex/rgb only for legacy browser support if needed.

## 2. Palette generation

- Start from domain colors (5+ colors that exist naturally in the product world, not abstract warm/cool).
- Generate tints/shades by adjusting lightness (L) while holding hue and chroma roughly constant.
- Check contrast ratios at every step: 4.5:1 minimum for body text, 3:1 for large text and UI affordances (WCAG 2.1 AA).
- Handle gamut boundaries (Display P3): know which colors are out of gamut for sRGB and provide fallbacks.

## 3. Dark mode

- Do not invert light mode ciegamente. Adjust chroma and luminancia per surface.
- Dark surfaces: lower lightness, not pure black (#000). Use very dark gray/blue/violet depending on domain.
- Accent colors in dark mode: raise lightness slightly so they remain visible and pass contrast.
- Text on dark: off-white, never pure white (#fff) for body; reduces halation.

## 4. Token layering (primitive → semantic → component)

```
primitive:    --color-ink-900, --color-brand-500, --color-surface-100
semantic:     --color-fg-primary, --color-bg-card, --color-accent
component:    --color-button-primary-bg, --color-button-primary-hover, --color-input-border
```

- Primitive tokens: raw OKLCH values, named by hue/lightness role.
- Semantic tokens: meaning (foreground, background, accent, danger, success).
- Component tokens: specific to a component state (button primary hover, input focus border).
- Components consume semantic tokens, never primitives directly (except foundational elements).

## 5. Contrast and accessibility

- Minimum 4.5:1 for body text, 3:1 for large text (18pt+ or 14pt bold) and UI affordances.
- Never convey meaning by color alone: pair status with icon + label.
- Link-purpose: links must be distinguishable from surrounding text without color (underline + color).
- Test contrast in both light and dark modes.

## 6. Accent discipline

- One accent color per view. Keep secondary actions neutral.
- Reserve brand color for links and actions; keep headings neutral.
- Muted text: enough contrast to stay readable, but clearly secondary.

## 7. Self-check

- Token test: read CSS variables aloud. Do they belong to this product world, or are they generic `--gray-700` / `--surface-2`?
- Squint test: blur eyes. Is the accent doing meaningful work, or just decoration?
- Grayscale test: convert to grayscale. Does hierarchy still work without color?

See `craft.md` for color world intent and `ui-polish.md` for how color interacts with shadows/borders. Routing conflicts: see `docs/ROUTING.md`.
