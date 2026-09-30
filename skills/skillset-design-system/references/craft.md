# Intentional Craft

Distinctive choices over generic output. Adapted from domain-driven design principles; foundations stay Apple HIG-based, craft applies to any web UI.

## 1. Define intent before code

Ask or infer with specifics, never guess silently:

- **Who:** the actual person, where they are, what they did 5 minutes before and after.
- **Task:** the verb — grade submissions, find the broken deployment, approve payment.
- **Feel:** words with meaning — warm like a notebook, cold like a terminal, dense like a trading floor. Never "clean and modern" alone.

Produce four outputs, then propose direction and wait for confirmation:

- **Domain:** 5+ concepts, metaphors, vocabulary from the product world, not features.
- **Color world:** 5+ colors that exist naturally in that domain, not abstract warm/cool.
- **Signature:** one element that could only exist for this product.
- **Rejected defaults:** 3 obvious choices for this UI type, visual and structural, each with its replacement.

Proposal format: domain, color world, signature, rejecting default to alternative x3, direction linking them. Test: remove the product name — could someone still guess what it is for? If not, dig deeper.

## 2. Principles

- **Every choice must be a choice.** State why for layout, color temperature, typeface, spacing, hierarchy. "Common" or "it works" is a default, not a choice.
- **Sameness is failure.** If another agent with a similar prompt would produce the same output, restart from intent.
- **Intent must be systemic.** If warm, then surfaces, text, borders, accents, semantic colors, and type are all warm. Check every token.
- **Infinite expression.** A metric can be hero number, sparkline, gauge, delta, trend badge, or new. Never repeat sidebar plus card-grid plus icon-left-number-big by habit.
- **Color lives somewhere.** Spend time in the product physical world — materials, light, objects. Gray builds structure; one intentional accent carries meaning.
- **Subtle layering.** Whisper-quiet elevation shifts, borders light enough to disappear until structure is needed.

## 3. Self-checks before showing

- **Swap test:** replace typeface or layout with the usual one — would anyone notice? Where not, you defaulted.
- **Squint test:** blur eyes. Hierarchy still readable? Nothing jumps out harshly? Craft whispers.
- **Signature test:** point to components where the signature appears. Overall feel does not count.
- **Token test:** read CSS variables aloud. They belong to this product world, not any project. Example: `--ink` and `--parchment` over `--gray-700` and `--surface-2`.

## 4. Universal anti-patterns

Always wrong regardless of context:

- Dramatic drop shadows such as `box-shadow: 0 25px 50px`.
- Arbitrary asymmetric padding without intent.
- Thick decorative borders (2px+) for visual weight.
- Multiple competing accent colors; keep one.
- Mixing depth strategies randomly (borders plus shadows).
- Inconsistent spacing scale.

## 5. Security and performance notes

Effects never weaken defenses. Prefer CSS-only texture, no inline event handlers, no `eval`. Keep third-party fonts and effect libraries minimal so CSP nonces or hashes and performance budgets hold. For hardening detail defer to `skillset-sec-appsec`.
