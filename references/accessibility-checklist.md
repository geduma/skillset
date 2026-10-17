# Accessibility Checklist

WCAG 2.1 AA baseline for web interfaces.

- [ ] One H1 per page, unique titles and descriptions per URL
- [ ] Keyboard navigation works for all interactive elements
- [ ] Visible focus indicators on all focusable elements
- [ ] Form inputs have associated labels (`<label>` or `aria-label`)
- [ ] Color contrast meets WCAG AA (4.5:1 normal text, 3:1 large text)
- [ ] Images have meaningful alt text (or `alt=""` for decorative)
- [ ] Reduced motion respected (`prefers-reduced-motion`)
- [ ] ARIA used only when native HTML insufficient
- [ ] Skip links for long pages
- [ ] Page title describes content/purpose
- [ ] Language attribute set on `<html>`

## Red flags

- Interactive elements not keyboard-reachable
- No visible focus indicator
- Form inputs without labels
- Color used as the only means of conveying information
- Missing `lang` attribute
- Decorative images with non-empty alt text