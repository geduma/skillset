---
name: skillset-design-system
description: Use this when designing, building, or reviewing web interfaces with Apple HIG-based foundations (clarity, deference, depth) with or without Liquid Glass material, or when the user asks for Apple-style UI, liquid glass effect, iOS or macOS-like components, SF typography, desktop and mobile layout, distinctive visual identity, domain-driven tokens, or says design this page, review my UI, improve visual hierarchy, avoid generic AI look, or make it feel native and intentional. Do not use for frontend application logic, state, or performance; use skillset-dev-frontend.
---

# Design System

Directs web UI with Apple HIG-based foundations (clarity, deference, depth), with Liquid Glass as an optional material. Not Apple-only: the same foundations ground any distinctive, intentional interface, working for desktop and mobile without switching the project's stack.

This skill is project-agnostic. It adapts to the detected framework and CSS setup and never hardcodes project paths or package names.

## When to use this

- The user asks for Apple-style, HIG, Liquid Glass, or iOS/macOS-like web UI.
- The user asks to design, restyle, or review a page, layout, or component.
- The user wants a distinctive visual identity and to avoid generic AI output.
- A diff needs a visual-design pass for hierarchy, spacing, or desktop/mobile behavior.

## Non-negotiable principles

1. **Ask for what varies.** If desktop vs mobile scope, light vs dark, brand constraints, or audience intent are unclear, ask. See `references/foundations.md` and `references/craft.md`.
2. **Content first, chrome second.** See `references/foundations.md`.
3. **Intent before output.** Define audience, task, and feel, then propose direction and confirm before code. See `references/craft.md`.
4. **One floating control layer.** Glass is optional; when used, only one layer. See `references/liquid-glass.md`.
5. **Stay distinctive, never generic.** Every choice needs a reason; sameness is failure. See `references/craft.md` and `references/typography-icons.md`.
6. **Motion and contrast are functional.** See `references/motion-accessibility.md`.
7. **Confirm before wide rewrites.** Restyling many files or changing tokens: summarize first, wait for approval.

## Workflow (summary)

1. **Detect context** — desktop, mobile, or both; light, dark, contrast needs; existing stack and tokens. Ask only for what you cannot infer.
2. **Define intent and direction** — audience, task, feel, domain concepts, color world, signature, rejected defaults; propose and confirm. See `references/craft.md` section 1.
3. **Apply foundations** — hierarchy, spacing, shapes, color, and layout per `references/foundations.md` and `references/typography-icons.md`.
4. **Layer glass and components** — use `references/liquid-glass.md` and `references/components.md`, desktop variant vs mobile variant. Glass only when it serves content.
5. **Verify** — run craft self-checks in `references/craft.md` section 3 plus pre-delivery checklist in `references/components.md`, report findings as `file:line`, and recheck motion and accessibility per `references/motion-accessibility.md`.

See `references/foundations.md`, `references/craft.md`, `references/liquid-glass.md`, `references/typography-icons.md`, `references/motion-accessibility.md`, `references/components.md` for detail.
