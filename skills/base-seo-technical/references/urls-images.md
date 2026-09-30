# URLs and Images

Short stable URLs and descriptive media improve CTR, crawling, and accessibility.

## 1. URL rules

- Pattern: lowercase kebab-case, 3-5 words, no IDs, no dates, no stop-word chains.
- Good: `/technical-seo-audit-checklist`. Bad: `/p=123`, `/blog/2024/11/07/post-final-v2`, `/category/subcat/index.php?id=42`.
- Avoid numbers that rot (`top-10` breaks when the list grows) and connectors that add no meaning (`and`, `or`, `vs` chains).
- One topic per URL. Changing intent means a new URL plus a 301 from the old one, never silent repurposing.
- Keep parameters for tracking outside the canonical. Canonical strips `utm`, session, and sort params.

## 2. URL stability

- Slugs survive redesigns. Do not restack folders without a redirect map reviewed by the user.
- Use 301 for permanent moves, 302 only for genuinely temporary tests.
- Update internal links to the final URL. Redirects are a safety net, not the primary path.

## 3. Image filenames

- Descriptive kebab-case before upload: `internal-linking-cluster-diagram.png`, not `IMG_0042.png` or `screenshot-final-2.png`.
- Include the primary topic once. Do not stuff keywords across similar filenames.
- Serve modern formats (AVIF or WebP with fallback), compressed, with explicit width and height to prevent cumulative layout shift.
- Lazy-load below-the-fold images. Keep LCP images eager and preloaded when they are the hero.

## 4. Alt text

- Alt describes the image function in under 125 characters. Decorative images get empty alt (`alt=""`).
- Pattern: object plus context. Example: `Diagram of pillar page linking to three cluster guides`.
- Do not prefix with `image of` or repeat the adjacent caption verbatim.
- Captions are optional but help complex diagrams. Keep them one sentence and distinct from alt.
