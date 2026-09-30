# Accessibility and Testing

Engineering baseline, not visual craft. Visual tokens live in `skillset-design-system`.

## 1. Accessibility baseline (WCAG 2.1 AA)

- Semantic landmarks, one H1 per view, logical heading order.
- All controls keyboard-reachable with visible focus; no hover-only actions.
- Inputs labeled programmatically; errors linked via describedby or equivalent.
- Status never by color alone; pair with icon plus text.
- Touch target at least 44x44 on mobile; pointer target at least 24px on desktop.
- Honor `prefers-reduced-motion` by disabling parallax and large transitions.

## 2. Responsive verification

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
