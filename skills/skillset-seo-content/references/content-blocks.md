# Content Blocks: Summary, TOC, Formatting, FAQ, CTAs

Scannable structure lifts dwell time, snippet capture, and AI-summary citation.

## 1. TLDR or key takeaways

- Place a 3-5 bullet TLDR or a 40-60 word summary directly after the intro, before the first H2.
- Each bullet is one factual claim or step, no marketing fluff.
- This block doubles as the AI overviews and featured snippet source. Keep sentences declarative and self-contained.
- Match the dominant intent here. If the TLDR answers a different question than the title, fix the title.

## 2. Table of contents

- Add a TOC after the intent confirmation and TLDR, linking to each H2 with anchor links.
- Show TOC on long pages (over 1200 words or more than 4 H2s). Keep it to H2 level to avoid noise.
- Use semantic markup (`nav` with a list) so engines and screen readers parse it.

## 3. Tables and lists

- Use a table for comparisons, pricing, checklists with status, and spec matrices. Columns must have real headers, not merged decoration.
- Use ordered lists for sequences and unordered lists for options. Keep items parallel in grammar and length.
- Break paragraphs longer than 4 lines. One idea per paragraph.
- Add a caption or intro line before each table so the snippet has context.

## 4. FAQ for query targeting

- Add 3-6 FAQs only when they target real long-tail queries (GSC, People Also Ask, support tickets). Do not invent filler questions.
- Each answer is 40-60 words, answers first, then one supporting detail.
- Keep FAQ visible in HTML. Content hidden behind mandatory interaction is weaker for snippets.
- Pair this file with structured data only in the technical skill; content here must stand alone without schema.

## 5. CTA and sharing placement

- Place one contextual text CTA after the first paragraph or after the TLDR. It must follow the value just delivered, not interrupt it.
- Add a share button block (X, LinkedIn, link copy at minimum) near the top and bottom on articles. Do not block content on mobile.
- Sticky mobile CTA is allowed only when it occupies under 15 percent of viewport height, is dismissible, and never covers headings or form fields.
- Never use more than one competing CTA above the fold. One page, one primary action.
