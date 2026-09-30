# Rendering and Performance

Applies to CSR, SSR, SSG, RSC, islands, or mobile webviews. Use the project renderer; never switch it.

## 1. Choose the right boundary

- Static content: prerender or server-render once.
- Personalized or interactive: server shell plus client islands, or server components with client leaves.
- Never hydrate a full page for one interactive widget. Move the boundary down.
- Route-level code splitting by default; component-level split only for heavy dialogs, charts, editors.

## 2. Kill waterfalls

- Fetch in loaders, route handlers, or server components, not in nested effects.
- Parallelize independent requests with `Promise.all` or parallel routes.
- Prefetch on intent (hover, focus, visible link), not on every render.
- Cache with explicit keys and invalidation; show stale data with freshness label rather than blocking.

## 3. Re-render control

- Key lists by stable id, never index.
- Memoize expensive derived values; split large components so typing does not re-render tables or charts.
- Debounce search input (150-300ms); throttle scroll and resize handlers.
- Images: explicit width and height, lazy below fold, modern format, responsive sizes.
- Critical above-fold images load with high priority; prefer compressed video over animated images with a still fallback.
- Large lists over about 50 items need virtualization or equivalent content-visibility handling.
- Never read layout measurements during render; batch reads and writes without interleaving.
- Prefer uncontrolled inputs; keep controlled inputs cheap per keystroke.
- Preconnect to asset domains; preload critical fonts with swap display.

## 4. Budgets and checks

- No new blocking third-party script without asking.
- Verify with the project tools: Lighthouse or Web Vitals, bundle report, typecheck.
- Report regressions as `file:line` with before and after numbers when available.
