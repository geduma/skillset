# Structured Data: FAQ and LocalBusiness

JSON-LD only, validated before shipping. Markup must match visible page content per Google spam policies.

## 1. General rules

- Format: single `script type="application/ld+json"` block in `head` or end of `body`. Prefer one graph with `@context: https://schema.org`.
- Every entity in markup must be visible on the page. No hidden questions, reviews, or addresses.
- Validate with Rich Results Test and Schema Markup Validator. Fix warnings on money pages; ignore purely informational warnings elsewhere.
- Monitor GSC Enhancements for error spikes after deploys.

## 2. FAQPage pattern

Use only on pages with a visible Q and A list (guides, product support, service pages). Do not use on forums or pages where users can submit alternate answers.

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [{
    "@type": "Question",
    "name": "How long should a meta title be?",
    "acceptedAnswer": {
      "@type": "Answer",
      "text": "Keep it 50-60 characters with the keyword front-loaded so mobile truncation keeps meaning."
    }
  }]
}
```

- Keep questions to real queries, answers 40-60 words, no links inside answers unless essential.
- One FAQPage block per page. Do not duplicate the same Q and A across many URLs.

## 3. LocalBusiness pattern

Use on location, contact, and homepage variants for local entities. Pick the most specific subtype (`Dentist`, `Restaurant`, `ProfessionalService`).

Required fields: `name`, `address` (`PostalAddress`), `telephone`, `url`. Recommended: `openingHoursSpecification`, `geo`, `sameAs` profiles, `priceRange` where applicable.

- NAP must match the visible footer and Google Business Profile character for character.
- Multiple locations get one page per location with its own LocalBusiness block. Never list all locations in one global block.

## 4. What to reject

- FAQ schema on pages without visible FAQs.
- Review or aggregateRating markup without visible reviews.
- LocalBusiness on non-local or purely online pages with no service area.
- Microdata or RDFa scattered through templates when JSON-LD already covers it.
