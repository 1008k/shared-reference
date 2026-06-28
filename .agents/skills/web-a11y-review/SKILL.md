---
name: web-a11y-review
description: Review and improve web accessibility for HTML, CSS, JavaScript, React, Astro, WordPress themes, landing pages, blog/Markdown content, forms, navigation, modals, tabs, accordions, and delivery checks. Use when asked to inspect UI accessibility, apply Digital Agency web accessibility guidance in Japanese projects, propose fixes, or create practical accessibility review output.
---
<!-- managed-by: agent-rules -->
<!-- source-repo: https://github.com/1008k/agent-rules -->
<!-- source-path: .agents/skills/web-a11y-review/SKILL.md -->

# Web A11y Review

Use this skill to turn web accessibility guidance into practical review findings and code/content fixes. Treat it as a review and improvement workflow, not as a formal WCAG/JIS conformance certification.

## Read Only What You Need

- For the Digital Agency guidance summary, read `references/digital-agency-web-a11y-summary.md`.
- For a review checklist, read `references/practical-checklist.md`.
- For code-level fixes, read `references/implementation-patterns.md`.
- For LP, article, Markdown, or WordPress content checks, read `references/content-checklist.md`.
- For automated checker choices, read `scripts/README.md`.

## Workflow

1. Identify the target surface: component, page, theme, article, form, modal, navigation, or delivery checklist.
2. Inspect source and rendered behavior when available. Prefer real keyboard and screen-reader-relevant behavior over static assumptions.
3. Prioritize findings by user impact, not by how easy they are to detect automatically.
4. Separate automated-check findings from manual-review findings.
5. Propose the smallest fix that restores semantics, operability, perceivability, or understandable feedback.
6. When editing code, preserve the existing framework and design intent unless accessibility requires a visible behavior change.

## Review Priority

Review in this order unless the user's request narrows the scope:

1. Keyboard operation is impossible or focus gets trapped/lost.
2. Screen readers cannot understand structure, names, roles, states, or updates.
3. Form labels, descriptions, required state, or errors are not programmatically related.
4. Focus location is invisible, ambiguous, or unexpectedly moved.
5. Images, icons, audio, or video lack appropriate alternatives.
6. Color, shape, motion, or position is the only way meaning is conveyed.
7. Headings, landmarks, links, buttons, or page titles do not match the user's task.
8. Content is hard to understand because labels, link text, language, or instructions are vague.

## Fixing Principles

- Start with native HTML: headings, landmarks, `button`, `a`, `label`, `fieldset`, `legend`, `table`, and form controls.
- Use `button` for actions and `a` for navigation.
- Do not break semantic structure for visual styling.
- Use `role` and `aria-*` only when native HTML cannot express the interaction.
- Keep visible focus indicators; replace default focus styles only with equally clear alternatives.
- Do not skip heading levels for visual size. Change CSS instead.
- Give icon-only controls an accessible name.
- Distinguish decorative images from meaningful images.
- Associate help text and error text with the relevant control.
- Manage focus for modals, menus, tabs, and route changes.
- Respect reduced-motion preferences for nonessential animation.

## Output Format

When reporting findings, use this compact format:

```md
## Accessibility Review

### Findings
- [Impact: High|Medium|Low] Short issue title
  - Location:
  - User impact:
  - Evidence:
  - Fix:
  - Automated check: detected|not detected|not run

### Manual Checks
- Keyboard:
- Focus:
- Screen reader semantics:
- Content clarity:

### Changes
- Files changed or patch summary.

### Remaining Risk
- Anything that needs browser, device, assistive technology, or stakeholder confirmation.
```

If no issues are found, say so clearly and list the manual checks or automated checks that were not run.
