<!-- managed-by: agent-rules -->
<!-- source-repo: https://github.com/1008k/agent-rules -->
<!-- source-path: .agents/skills/web-a11y-review/scripts/README.md -->
# Automated Check Tools

Automated tools catch useful issues, but they do not prove accessibility. Pair them with keyboard, focus, semantics, content, and screen-reader-relevant manual checks.

## Tool Choices

- `axe-core`: Good for component/page checks and CI integration. Best when embedded through Playwright or a framework test runner.
- `pa11y`: Good for quick URL checks and simple CI smoke tests.
- Lighthouse accessibility audit: Good for broad page-level signals and regressions, but not enough for interaction-heavy UI.
- Playwright + axe: Good for testing specific states such as open menus, modals, validation errors, and route changes.
- `html-validate`: Good for invalid HTML, missing attributes, and structural mistakes before runtime.
- `eslint-plugin-jsx-a11y`: Good for React/JSX static checks, especially missing labels, invalid ARIA, and click handlers on noninteractive elements.

## Example Commands

```powershell
npm exec pa11y http://localhost:3000
npm exec lighthouse http://localhost:3000 -- --only-categories=accessibility
npm exec html-validate "src/**/*.html"
npm exec eslint "src/**/*.{js,jsx,ts,tsx}"
```

Adjust commands to the package manager and scripts already used by the project.

## What Tools Usually Miss

- Whether link text is meaningful in the user's context.
- Whether alt text is useful rather than merely present.
- Whether focus movement feels logical across an entire flow.
- Whether a modal, tab, menu, or validation error is understandable after state changes.
- Whether Japanese labels, instructions, and error messages are clear.
- Whether the chosen component pattern fits the product task.

Record automated results as evidence, then add manual findings separately.
