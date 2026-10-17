# UX Writing for Interfaces

Interface copy: labels, errors, empty states, settings, notifications, product voice consistency. Adapted from `better-writing`, `clarify`, and `balise-ux-writing` in the UI Skills catalog.

Applies on top of `typography-icons.md` (copy voice section). This file covers the practical rules for writing inside components and screens.

## 1. Labels

- Every form field needs a visible label. Never use placeholder text as the only label.
- Sentence case for UI labels (not ALL CAPS, not Title Case unless it is a heading/button per product voice).
- Label names the outcome, not the action: "Delete account" not "Continue".
- Labels stay visible when the field is focused or filled (no floating labels that disappear).

## 2. Errors and validation

- Show each validation error directly below its field, not in a top banner only.
- Error message includes the fix or next step, not only the problem: "Enter a valid email address" not "Invalid input".
- Keep user input on error; do not clear the field.
- Pair status with icon + label; never color alone.

## 3. Empty states

- Give an empty state one clear, useful next action, not just an explanation.
- Explain the situation in one sentence, then offer the action.
- Avoid illustrations that carry no information; if illustrated, the image must support the message.

## 4. Confirmations and destructive actions

- Confirm destructive actions before they run (delete, unpublish, reset).
- Confirmation dialog names what will happen: "Delete 'Project X'?" not "Are you sure?".
- Offer undo where possible; keep it brief (5–10s).

## 5. Product voice

- Active voice with the user as subject: "You saved the report" not "The report was saved".
- Specific button labels naming the outcome, not generic "Continue", "Submit", "OK".
- Title Case for headings and buttons (if product voice uses it); numerals for counts ("5 items" not "five items").
- Avoid first person ("My account" → "Account").
- Error messages: compact, include fix or next step.
- Loading states end with an ellipsis: "Saving…", "Loading…".

## 6. Consistency

- Buttons, labels, inputs, and errors each get one consistent style across desktop and mobile.
- Terminology: one word per concept across the product (do not mix "profile", "account", "user settings" for the same thing).
- Use a single ellipsis character (…), never three dots (...).
- Curly quotes over straight quotes in published copy.
- Keep units and shortcuts non-breaking: amount + unit, modifier + key, brand names.

## 7. Self-check

- Read labels aloud: would a human say this?
- Cover the interface: can the user complete the task from labels and buttons alone?
- Swap test: replace copy with generic UI text ("Continue", "Submit") — if nothing changes, the writing is slop.

See `typography-icons.md` section 4 (copy voice) and `ui-polish.md` for how copy sits inside components. Routing conflicts: see `docs/ROUTING.md`.
