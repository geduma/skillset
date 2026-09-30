# Trigger tests — skillset-seo-content

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "audit meta titles and descriptions" → expect activation.
2. "fix duplicated H1 and flat headings" → expect activation.
3. "CTR is low despite impressions" → expect activation.
4. "add FAQ and internal linking cluster" → expect activation.
5. "match search intent for this page" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "fix robots.txt and sitemaps (use seo-technical)" → should-NOT-trigger this skill.
2. "add JSON-LD schema" → should-NOT-trigger this skill.
3. "wire GA4" → should-NOT-trigger this skill.
