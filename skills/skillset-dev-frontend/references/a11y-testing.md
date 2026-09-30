# Accessibility and Testing

Engineering baseline, not visual craft. Visual tokens live in `skillset-design-system`.

## 1. Accessibility baseline (WCAG 2.1 AA)

- Semantic landmarks, one H1 per view, logical heading order; include a skip link for main content.
- All controls keyboard-reachable with visible focus; no hover-only actions; gesture-only actions need tap and keyboard alternatives.
- Use native buttons for actions and links for navigation, never clickable non-interactive elements.
- Inputs labeled programmatically; errors linked via describedby or equivalent.
- Icon-only buttons need an accessible name; decorative icons are hidden from assistive tech.
- Images need alternative text, empty when decorative; meaningful media needs captions or transcripts.
- Async updates such as toasts and validation need a polite live region.
- Status never by color alone; pair with icon plus text.
- Touch target at least 44x44 on mobile; pointer target at least 24px on desktop.
- Honor `prefers-reduced-motion` by disabling parallax and large transitions.
- Prevent double-tap zoom delay on touch; set tap highlight intentionally.
- Contain overscroll inside modals, drawers, and sheets; disable selection during drag and mark dragged content inert.
- Use autofocus sparingly: desktop only, single primary input, never on mobile without justification.

## 2. Content and locale

- Text containers handle long content with truncation, clamping, or wrapping; flex children allow shrinking.
- Handle empty states explicitly; anticipate short, average, and very long user input.
- Format dates, times, numbers, and currency with internationalization APIs, never hardcoded formats.
- Detect language from platform settings, never from network location; mark brand names and code tokens as non-translatable.
- Guard date and time rendering against server-client mismatches; limit hydration warnings to truly unavoidable cases.
- Check 360px, 768px, and 1280px widths or the project breakpoints.
- No horizontal scroll at 360px; tables collapse to stacked cards or scroll region with caption.
- Text resize to 200 percent and zoom must not lose content or function.

## 3. Testing strategy

- Unit: pure logic, formatters, validators, state reducers.
- Component: render states — loading, error, empty, success — plus keyboard interaction.
- E2E: critical flows only — login, checkout, create, approve — with Playwright or the project runner.
- Use existing fixtures and helpers. Never add a new test framework without asking.

## 4. Report format

- Terse `file:line` findings, critical then minor.
- Example: `views/Orders.tsx:88 missing label on status filter`.
- State what ran: tests, typecheck, lint, manual widths checked.
