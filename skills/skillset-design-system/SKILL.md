---
name: skillset-design-system
description: Use this when designing, building, or reviewing web interfaces needing a distinctive visual identity - Apple HIG, Material 3, Fluent, or brand tokens - or when the user asks for page design, layout, visual hierarchy, domain-driven tokens, avoiding generic AI look, or says design this page, review my UI, or make it feel native and intentional. Apple-style, Liquid Glass, and iOS/macOS-like UI are supported via the default HIG adapter. Do not use for frontend application logic, state, or performance; use skillset-dev-frontend.
license: MIT
allowed-tools: Read Edit Write Glob
metadata:
  version: 1.3.0
---

# Design System

Directs distinctive, intentional web UI for desktop and mobile without switching the project's stack. Craft (`references/craft.md`) is mandatory and generic; Apple HIG (`references/foundations.md`) is the default foundation adapter, swappable per `references/adapters.md`.

This skill is project-agnostic. It adapts to the detected framework and CSS setup and never hardcodes project paths or package names.

## When to use this

- The user asks to design, restyle, or review a page, layout, or component in any design language.
- The user names Material 3, Fluent, brand tokens, or asks to avoid Apple look.
- The user wants a distinctive visual identity and to avoid generic AI output.
- A diff needs a visual-design pass for hierarchy, spacing, or desktop/mobile behavior.

## Non-negotiable principles

1. **Ask for what varies.** If design system (HIG, Material, Fluent, brand), desktop vs mobile scope, light vs dark, or audience intent are unclear, ask. See `references/adapters.md` and `references/craft.md`.
2. **Content first, chrome second.** See `references/foundations.md`.
3. **Intent before output.** Define audience, task, and feel, then propose direction and confirm before code. See `references/craft.md`.
4. **One floating control layer.** Glass is HIG-only and optional; when used, only one layer. See `references/liquid-glass.md`.
5. **Stay distinctive, never generic.** Every choice needs a reason; sameness is failure. See `references/craft.md` and `references/typography-icons.md`.
6. **Motion and contrast are functional.** See `references/motion-accessibility.md`.
7. **Confirm before wide rewrites.** Restyling many files or changing tokens: summarize first, wait for approval.

## Workflow (summary)

1. **Detect context** — desktop, mobile, or both; light, dark, contrast needs; existing stack and tokens. Ask only for what you cannot infer.
2. **Define intent and direction** — audience, task, feel, domain concepts, color world, signature, rejected defaults; propose and confirm. See `references/craft.md` section 1.
3. **Apply foundations via adapter** — pick HIG, Material, Fluent, or brand tokens per `references/adapters.md`, then hierarchy, spacing, shapes, color, layout per `references/foundations.md` and `references/typography-icons.md`.
4. **Layer glass and components** — use `references/liquid-glass.md` and `references/components.md`, desktop variant vs mobile variant. Glass only when it serves content.
5. **Verify** — run craft self-checks in `references/craft.md` section 3 plus pre-delivery checklist in `references/components.md`, report findings as `file:line`, and recheck motion and accessibility per `references/motion-accessibility.md`.

See `references/foundations.md`, `references/craft.md`, `references/adapters.md`, `references/liquid-glass.md`, `references/typography-icons.md`, `references/motion-accessibility.md`, `references/components.md` for detail. Routing conflicts: see `docs/ROUTING.md`.
