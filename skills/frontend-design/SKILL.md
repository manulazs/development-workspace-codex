---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use when the user asks to build or improve web components, pages, applications, dashboards, landing pages, HTML/CSS layouts, React components, or visual UI styling, especially when the result should avoid generic AI-looking design.
license: Apache-2.0; adapted from anthropics/skills frontend-design
---

# Frontend Design

Create distinctive, production-grade frontend interfaces with a clear visual point of view, working code, and careful implementation details.

This skill is adapted for Codex from Anthropic's `frontend-design` skill:
https://github.com/anthropics/skills/tree/main/skills/frontend-design

## Use This Skill When

- The user asks to build a web page, component, dashboard, landing page, app, or HTML/CSS/JS interface.
- The user asks to improve, beautify, modernize, or restyle a frontend.
- The user asks for polished UI code instead of a generic layout.
- The output should be visually distinctive and production-grade.

Do not use this skill for backend-only work, pure data logic, plain documentation, or UI tasks where the user explicitly wants a minimal unstyled result.

## Design Direction

Before coding, choose a clear aesthetic direction that fits the product, audience, and use case.

Consider:

- Purpose: what problem the interface solves and who uses it.
- Tone: utilitarian, editorial, refined, playful, brutalist, geometric, industrial, luxury, retro-futuristic, organic, or another deliberate direction.
- Constraints: framework, accessibility, responsiveness, performance, existing design system, and target device.
- Differentiation: the specific visual choice that makes the interface memorable.

For operational tools, SaaS, dashboards, CRM-like surfaces, BI, and internal business applications, prefer restrained, dense, scannable, work-focused design over decorative marketing composition.

For landing pages, games, visual experiments, or portfolio pieces, a stronger expressive direction may be appropriate.

## Implementation Standards

Build real working code in the project's existing stack whenever possible.

Prioritize:

- Clear information hierarchy.
- Strong typography choices that fit the context.
- Intentional color systems with CSS variables or local design tokens.
- Responsive layouts with stable dimensions and no text overflow.
- Thoughtful spacing, alignment, contrast, and interaction states.
- Accessibility basics: semantic structure, keyboard-reachable controls, readable contrast, and useful labels.
- Motion only when it supports the experience.

Avoid:

- Generic AI-looking purple gradients, glassy cards, and predictable hero layouts.
- Overused default font choices when the project allows better alternatives.
- Decorative effects that reduce readability.
- Text that overflows cards, buttons, tabs, or navigation.
- UI cards nested inside UI cards unless the existing design system requires it.
- Replacing an existing product's design language with an unrelated aesthetic.

## Frontend Workflow

1. Inspect the existing project structure, design system, components, and styling conventions.
2. Identify the user's actual workflow and audience.
3. Choose a visual direction appropriate to the domain.
4. Implement the UI with production-grade code.
5. Verify responsiveness and text fit at relevant viewport sizes.
6. If a dev server or browser verification is available and appropriate, inspect the rendered result before finishing.
7. Report changed files, validation performed, and any remaining visual risks.

## Visual Guidance

Typography:

- Use fonts already available in the project when consistency matters.
- If choosing fonts, make the pairing intentional: display, body, numeric, or mono as appropriate.
- Do not use novelty fonts where readability matters.

Color:

- Use color to clarify state, priority, and grouping.
- Avoid one-note palettes unless the brand requires it.
- Use accents sparingly in business tools.

Layout:

- Prefer dense but organized layouts for dashboards and internal tools.
- Use generous negative space for editorial or brand surfaces only when it serves the goal.
- Define stable dimensions for toolbars, cards, grids, tabs, and fixed-format controls.

Motion:

- Keep animation purposeful and performant.
- Avoid motion that makes data, controls, or navigation harder to use.

## Limits

- Do not invent product requirements the user did not ask for.
- Do not ignore an existing design system.
- Do not add dependencies without checking the project conventions and asking when risk is meaningful.
- Do not use generated imagery or external assets unless the user request or project context supports it.
- Do not claim visual verification was done unless it was actually performed.

