# AI Discoverability and Analytics

Covers LLMS.txt for LLM crawlers plus GA4 and GSC wiring. Order matters: be crawlable first, then summarize for machines, then measure.

## 1. LLMS.txt

Follows the llmstxt.org proposal as implemented in 2025-2026 tooling (root Markdown summary, not a Google ranking signal).

- Location: site root `/llms.txt`, served as `text/markdown` or `text/plain`, linked from nothing but discoverable by crawlers. Keep a human-readable docs index alongside it.
- Keep it under 100 lines. Structure:
  ```
  # Site name
  > One-paragraph summary of what the site covers.
  ## Core guides
  - [Guide title](https://example.com/path): one-line description.
  ## API or reference
  - [Endpoint docs](https://example.com/docs): one-line description.
  ## Optional
  - [Full dump](https://example.com/llms-full.txt): complete concatenated docs.
  ```
- List canonical docs only. Exclude drafts, staging, login, and thin archives, mirroring robots and sitemap logic.
- Update on every docs release. Stale LLMS.txt misleads assistants worse than no file.
- LLMS.txt does not replace robots.txt, sitemaps, or schema. Pages listed here must still be crawlable and indexable.
- Respect `robots.txt` for AI crawlers (`GPTBot`, `CCBot`, `PerplexityBot`) explicitly when the owner opts out; do not use LLMS.txt as an access control mechanism.

## 2. Google Analytics GA4

- One property per business, one web data stream per hostname. Enable enhanced measurement, then disable events that spam (e.g. duplicate pageviews from SPA routers).
- Define 3-5 key events only: signup, purchase, lead submit, share click, CTA click. Everything else stays as exploration, not conversion.
- Connect GA4 to GSC and Google Ads where applicable. Set data retention to the maximum the privacy policy allows.
- Verify with real-time DebugView before calling setup done.

## 3. Google Search Console

- Verify all four variants or use domain verification. Assign one primary property (HTTPS, preferred host).
- Submit the sitemap index once. Use URL Inspection on templates (not every URL) after structural changes.
- Weekly routine: Performance deltas for high-impression low-CTR pages (feed to the content skill), Pages indexing errors, Enhancements for schema, Links for anchor drift.
- Never verify with a personal account the team cannot transfer. Use a shared owner plus delegated users.
