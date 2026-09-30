# Typography and Icons

SF family behavior plus web fallbacks and SF Symbols usage. Sources: https://developer.apple.com/fonts/ and https://developer.apple.com/sf-symbols/

## 1. Typeface

- Primary is SF Pro (neutral sans, 9 weights, 150+ languages). HIG guide: https://developer.apple.com/design/human-interface-guidelines/typography
- Variants: SF Pro Rounded for friendly headers, SF Compact for small sizes, SF Mono for code, New York serif as alternative display.
- On web SF is rarely installed. Stack: `-apple-system, BlinkMacSystemFont, SF Pro Text, Inter, Segoe UI, sans-serif`. Never force a download; adapt to system fonts.
- 2025 direction: bolder body for clarity, left-aligned type in alerts and onboarding.

## 2. Scale

- Reference points: Body 17pt, Large Title 34pt. Map to web with `clamp()` for fluid scaling.
- Suggested web scale: 12 / 14 / 17 / 20 / 24 / 34 for caption through large title.
- Use named roles (title, headline, body, footnote), not raw pixel values scattered in code.
- Desktop: tighter leading, wider measure (60-75ch). Mobile: larger line-height, narrower measure (32-45ch), Dynamic Type must not break layout.

## 3. Rules

- Pick one display face plus one body face. Never mix three or more families.
- Stay distinctive. Banned defaults: Inter-only, Roboto, Arial, system-only stacks, purple-on-white clichés.
- Buttons, labels, inputs, and errors each get one consistent style across desktop and mobile.
- Minimum body on mobile is effectively 17px equivalent; never shrink critical text to fit.

## 4. Icons with SF Symbols

- Library of 7000+ symbols: https://developer.apple.com/sf-symbols/ HIG: https://developer.apple.com/design/human-interface-guidelines/icons
- Four render modes: Monochrome, Hierarchical, Palette, Multicolor. Default to Monochrome; use Hierarchical for subtle emphasis.
- On web use inline SVG with matching stroke weight to text. Never use emoji as icons.
- Icons inherit text color and size. Keep 4px grid, consistent 1.5-2px stroke.
- Prefer shared glyphs for common actions (share, search, settings) so users recognize them instantly.
