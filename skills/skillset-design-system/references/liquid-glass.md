# Liquid Glass

Translucent floating control layer from the 2025 Apple redesign. Sources: https://developer.apple.com/documentation/technologyoverviews/liquid-glass and https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass

## 1. What it is

- A translucent material that bends light, adapts to content behind it, and reacts to interaction.
- Creates one distinct floating layer for controls above content. Content scrolls; controls float.
- Applies to iOS 26, iPadOS 26, macOS 26 Tahoe, watchOS 26, tvOS 26. On web, emulate with translucency and blur.

## 2. Web emulation

- Use `backdrop-filter: blur(20px) saturate(160%)` plus translucent fill such as `color-mix(in srgb, white 60%, transparent)` for light or dark equivalent.
- Add a 1px inner highlight border (`rgba(255,255,255,0.4)`) and soft shadow. No heavy gradients.
- Keep blur moderate for legibility. If text sits on glass, raise fill opacity until contrast passes.
- Prefer CSS-only. No WebGL lensing unless the project already has it.

## 3. Where to use it

- Tab bars, toolbars, sidebars, floating action clusters, sheets, tooltips.
- Desktop: toolbar and sidebar. Mobile: bottom tab bar and sheets.

## 4. Limits

- One glass layer per view. Never stack glass on glass.
- Limit glass elements per screen: 1 bar plus at most 1 floating cluster.
- Never put body copy on strong blur. Keep glass for controls, not articles.
- Provide a tinted fallback when `backdrop-filter` is unsupported, and a solid fallback for Increased Contrast.

| Do | Do not |
|---|---|
| Float one bar above scrolling content | Freeze content behind full-screen blur |
| Raise opacity in bright contexts | Keep `bg-white/10` in light mode |
| Tint glass with the page accent subtly | Mix unrelated hues per component |

## 5. Videos for edge cases

- Overview: https://developer.apple.com/videos/play/wwdc2025/219/
- System behavior: https://developer.apple.com/videos/play/wwdc2025/356/
- SwiftUI patterns: https://developer.apple.com/videos/play/wwdc2025/323/
- UIKit adoption: https://developer.apple.com/videos/play/wwdc2025/284/
