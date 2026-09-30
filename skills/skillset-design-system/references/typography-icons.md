# Typography and Icons

System type behavior plus web fallbacks and symbol usage.

## 1. Typeface

- Primary is a neutral sans with wide weight and language coverage.
- Variants: rounded sans for friendly headers, compact cut for small sizes, mono for code, serif as alternative display.
- On web system fonts are rarely guaranteed. Stack: system sans fallbacks ending in generic sans-serif. Never force a download; adapt to system fonts.
- Direction: bolder body for clarity, left-aligned type in alerts and onboarding.

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
- Use a single ellipsis character, never three dots; prefer curly quotes over straight quotes.
- Keep units and shortcuts non-breaking: amount plus unit, modifier plus key, brand names.
- Loading states end with an ellipsis: Saving, Loading, and similar.
- Use tabular numerals for columns and comparisons; balance or pretty-wrap headings to avoid widows.

## 4. Copy voice

- Active voice with the user as subject; specific button labels naming the outcome, not Continue.
- Title Case for headings and buttons; numerals for counts, not spelled-out numbers.
- Error messages include the fix or next step, not only the problem.
- Avoid first person; prefer compact conjunctions where space is tight.

## 5. Icons

- Default to monochrome; use hierarchical emphasis sparingly.
- On web use inline SVG with matching stroke weight to text. Never use emoji as icons.
- Icons inherit text color and size. Keep 4px grid, consistent 1.5-2px stroke.
- Prefer shared glyphs for common actions (share, search, settings) so users recognize them instantly.
