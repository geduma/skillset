# Trigger tests — skillset-seo-technical

Manual check: each should-trigger prompt must activate this skill;
each should-NOT-trigger prompt must route elsewhere.

## Should trigger

1. "fix robots.txt crawl rules" → expect activation.
2. "submit XML sitemaps to Search Console" → expect activation.
3. "pages discovered but not indexed" → expect activation.
4. "add FAQ LocalBusiness JSON-LD schema" → expect activation.
5. "wire GA4 and GSC measurement" → expect activation.

## Should-NOT-trigger (route elsewhere)

1. "rewrite headings and TLDR copy (use seo-content)" → should-NOT-trigger this skill.
2. "design the page visually" → should-NOT-trigger this skill.
3. "write backend code" → should-NOT-trigger this skill.
