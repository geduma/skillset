# Crawl and Indexation

Based on Google Search Central crawl and index documentation and standard audit practice.

## 1. Diagnostic order

- Fetch `robots.txt` first, then the XML sitemap, then the page: status code, canonical tag, meta robots, and response headers.
- Cross-check GSC: Coverage or Pages report for `Discovered not indexed`, `Crawled not indexed`, and `Blocked by robots`.
- Important pages must return 200, be self-canonical, and be listed in the sitemap. Anything else is a bug until proven otherwise.

## 2. Robots.txt rules

- Location: site root `/robots.txt`, served as `text/plain` with 200.
- Minimal default:
  ```
  User-agent: *
  Disallow: /search?
  Disallow: /cart/
  Allow: /
  Sitemap: https://example.com/sitemap.xml
  ```
- Block only what wastes crawl: search facets, carts, admin, staging. Never block CSS or JS; rendering needs them.
- Confirm before adding broad `Disallow: /`. One wrong slash deindexes the site.
- Large sites: use separate stanzas per crawler only when logs prove a need.

## 3. Pagination and archive indexation

- Deindex thin paginated archives such as `/page/2/` with `noindex, follow` so link equity flows but duplicates do not compete.
- Keep the canonical of page 1 self-referential. Paginated pages canonicalize to themselves, not to page 1.
- Do not include `/page/` URLs in the XML sitemap. Sitemaps list only canonical indexable URLs.
- Preferred control is meta robots or X-Robots-Tag, not robots disallow, so equity still passes.

## 4. XML sitemap

- Location: `/sitemap.xml` with an index splitting children under 50k URLs or 50 MB uncompressed each.
- Include only 200, indexable, self-canonical URLs. Exclude noindex, canonicalized, 404, and redirected URLs.
- Use accurate `lastmod` in W3C datetime. Do not fake it on every deploy.
- Submit the index once in GSC and reference it from `robots.txt`. Monitor `Sitemap could not be read` and `Submitted URL not found` errors weekly.

## 5. Canonicals

- One absolute self-referencing canonical per indexable page.
- HTTPS, lowercase host, no trailing parameter noise. Pick one and redirect the rest with 301.
- Audit weekly for canonical mismatches where Google selects a different canonical than declared.
