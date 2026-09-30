---
name: skillset-design-system
description: Use this when designing, building, or reviewing web interfaces that should follow Apple Human Interface Guidelines and Liquid Glass design language, or when the user asks for Apple-style UI, liquid glass effect, iOS or macOS-like components, SF typography, clarity deference depth, desktop and mobile layout, or says design this page, review my UI, improve visual hierarchy, or make it feel native to Apple platforms.
---

# Design System

Directs web UI toward Apple HIG clarity with Liquid Glass material, working for desktop and mobile without switching the project's stack.

This skill is project-agnostic. It adapts to the detected framework and CSS setup and never hardcodes project paths or package names.

## When to use this

- The user asks for Apple-style, HIG, Liquid Glass, or iOS/macOS-like web UI.
- The user asks to design, restyle, or review a page, layout, or component.
- A diff needs a visual-design pass for hierarchy, spacing, or desktop/mobile behavior.

## Non-negotiable principles

1. **Ask for what varies.** If desktop vs mobile scope, light vs dark, or brand constraints are unclear, ask. See `references/foundations.md`.
2. **Content first, chrome second.** See `references/foundations.md`.
3. **One floating control layer.** See `references/liquid-glass.md`.
4. **Stay distinctive, never generic.** See `references/typography-icons.md`.
5. **Motion and contrast are functional.** See `references/motion-accessibility.md`.
6. **Confirm before wide rewrites.** Restyling many files or changing tokens: summarize first, wait for approval.

## Workflow (summary)

1. **Detect context** — desktop, mobile, or both; light, dark, contrast needs; existing stack and tokens. Ask only for what you cannot infer.
2. **Apply foundations** — hierarchy, spacing, shapes, color, and layout per `references/foundations.md` and `references/typography-icons.md`.
3. **Layer glass and components** — use `references/liquid-glass.md` and `references/components.md`, desktop variant vs mobile variant.
4. **Verify** — run the pre-delivery checklist in `references/components.md`, report findings as `file:line`, and recheck motion and accessibility per `references/motion-accessibility.md`.

See `references/foundations.md`, `references/liquid-glass.md`, `references/typography-icons.md`, `references/motion-accessibility.md`, `references/components.md` for detail.
