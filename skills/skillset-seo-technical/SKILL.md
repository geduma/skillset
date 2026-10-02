---
name: skillset-seo-technical
description: Use this when handling technical SEO such as robots.txt crawl rules, XML sitemaps and Search Console submission, SEO-friendly URL design, indexation control including paginated page paths, image file naming and alt text, FAQ and LocalBusiness structured data in JSON-LD, LLMS.txt for AI discoverability, or wiring Google Analytics GA4 and Google Search Console. Also use when pages are not crawled or indexed, rich results fail validation, or LLM crawlers cannot read the site. Do not use for titles, headings, intent matching, TLDR, FAQ copy, internal linking, or CTA placement - use skillset-seo-content.
license: MIT
allowed-tools: Read Write Edit Glob Grep Shell
metadata:
  version: 1.3.0
---

# Technical SEO

Keeps the site crawlable, indexable, fast to parse, and measurable for both search engines and LLM crawlers.

## When to use this

- The user asks about robots.txt, sitemaps, URLs, canonical tags, noindex, pagination, or crawl budget.
- The user asks about image filenames, alt text, compression, or layout shift.
- The user asks about FAQ or LocalBusiness schema, rich results errors, or LLMS.txt.
- Pages are discovered but not indexed, or GA4 and GSC are missing or unverified.

## Non-negotiable principles

1. **Crawlability before content.** Blocked, orphaned, or non-indexable pages cannot rank. See `references/crawl-index.md`.
2. **One canonical URL per resource.** Duplicates collapse to one signal. See `references/crawl-index.md` and `references/urls-images.md`.
3. **Markup matches visible content.** Never add schema for invisible text. See `references/structured-data.md`.
4. **Stay project-agnostic.** Give generic HTML and header advice first, framework or CMS specifics only as adapters. See all references.
5. **Confirm before destructive changes.** Robots disallows, mass noindex, and redirect maps need explicit approval.

## Workflow (summary)

1. **Check crawl and index** — inspect robots.txt, sitemap, canonicals, and GSC coverage. See `references/crawl-index.md` section 1.
2. **Fix URLs and media** — shorten slugs, correct filenames and alt, stabilize layout. See `references/urls-images.md`.
3. **Add structured data and AI surface** — ship FAQ and LocalBusiness JSON-LD, then LLMS.txt. See `references/structured-data.md` and `references/ai-analytics.md` section 1.
4. **Wire measurement** — verify GA4 and GSC, submit sitemaps, monitor. See `references/ai-analytics.md` section 2.

See `references/crawl-index.md`, `references/urls-images.md`, `references/structured-data.md`, `references/ai-analytics.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
