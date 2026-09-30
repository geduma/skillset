# Internal Linking and Topic Clusters

Internal links distribute authority, define topics, and keep important pages within 3 clicks of the homepage.

## 1. Cluster model

- One pillar page per topic (broad intent). Multiple cluster pages cover sub-intents and link back to the pillar.
- Example: pillar `Technical SEO Guide` links to clusters `Robots.txt`, `XML Sitemaps`, `Canonical Tags`. Each cluster links back to the pillar and sideways to siblings where relevant.
- Do not create orphan pages. Every indexable URL needs at least one internal inlink from an indexable page.
- Keep depth under 3 clicks from homepage for money pages. Deeper pages get crawled less and convert less.

## 2. Anchor and placement rules

- Anchors are descriptive: `robots.txt crawl rules`, not `click here` or bare URLs.
- Vary anchors across pages. Identical anchor to different targets confuses topic assignment.
- Place links in body copy where they extend the argument. Navigation, footer, and related-posts links are supplements, not substitutes.
- Limit to what the reader can use: 3-8 contextual links per 1500 words. More is noise unless it is a genuine resource hub.

## 3. Audit routine

- Crawl with Screaming Frog or Sitebulb. Export orphans, depth over 3, and pages with 1 or fewer inlinks.
- Check GSC Links report for top linked pages. If the most-linked pages are tags or archives, rebalance toward pillars.
- Fix redirect chains in internal links. Point directly at the final 200 URL.
- When merging or deleting a page, 301 to the closest surviving intent match and update inlinks, not just the redirect.

## 4. What to reject

- Sitewide exact-match anchors in footers or sidebars.
- Pagination and tag clouds as the only path to important content.
- Nofollow on internal links except for login, cart, or faceted URLs you do not want crawled.
