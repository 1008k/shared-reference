<!-- managed-by: agent-rules -->
<!-- source-repo: https://github.com/1008k/agent-rules -->
<!-- source-path: .agents/skills/web-a11y-review/references/practical-checklist.md -->
# Practical Accessibility Checklist

Use this as a review menu. Pick categories that match the target surface.

## Page Structure

- [ ] The page has one clear purpose and a unique, accurate title.
  - Problem example: Multiple pages share the same title.
  - User impact: Screen reader and tab users cannot confirm location quickly.
  - Fix: Update `title`, main heading, and route metadata together.
- [ ] Main content, navigation, search, and footer are represented by appropriate landmarks.
  - Problem example: Everything is nested in generic `div` elements.
  - User impact: Landmark navigation is not useful.
  - Fix: Use `header`, `nav`, `main`, `aside`, and `footer` where appropriate.

## Headings

- [ ] Headings describe the following content and do not skip levels for styling.
  - Problem example: `h4` follows `h1` because it looks right.
  - User impact: Document outline becomes misleading.
  - Fix: Use the correct heading level and style it with CSS.

## Links And Buttons

- [ ] Links navigate; buttons perform actions.
  - Problem example: `<a href="#">閉じる</a>` closes a modal.
  - User impact: Keyboard and assistive technology expectations break.
  - Fix: Use `button type="button"` for UI actions.
- [ ] Link text makes sense out of context.
  - Problem example: Repeated "こちら" links.
  - User impact: Link lists become useless.
  - Fix: Write the destination or action in the text.
- [ ] Icon-only buttons have accessible names.
  - Problem example: Search button contains only an SVG.
  - User impact: The control is announced without purpose.
  - Fix: Add visible text or `aria-label`.

## Images, Icons, Media

- [ ] Meaningful images have useful alternatives.
  - Problem example: `alt="image"`.
  - User impact: Information is lost.
  - Fix: Describe the information the image contributes.
- [ ] Decorative images are ignored by assistive technology.
  - Problem example: Decorative divider has verbose alt text.
  - User impact: Reading becomes noisy.
  - Fix: Use `alt=""` or CSS background when appropriate.
- [ ] Video/audio content has captions, transcripts, or equivalent content when needed.
  - Problem example: An instruction video has no text alternative.
  - User impact: Users who cannot hear or play media miss the content.
  - Fix: Provide captions or a text procedure.

## Forms

- [ ] Every input has a programmatically associated label.
  - Problem example: Placeholder text is the only label.
  - User impact: Purpose disappears after typing and may not be announced reliably.
  - Fix: Use `label for`/`id` or an equivalent framework pattern.
- [ ] Help text, constraints, required state, and errors are close to and associated with the field.
  - Problem example: Error text appears in red but is not linked to the input.
  - User impact: Users may not know which field failed or how to fix it.
  - Fix: Use `aria-describedby`, `aria-invalid`, and clear text.
- [ ] Error messages explain the fix, not only the failure.
  - Problem example: "Invalid".
  - User impact: Users cannot recover.
  - Fix: State the expected format or missing requirement.

## Tables

- [ ] Data tables use `th`, `scope`, captions, or summaries as needed.
  - Problem example: Header cells are styled `td`.
  - User impact: Cell meaning is unclear.
  - Fix: Use table semantics for tabular data.
- [ ] Layout tables are avoided.
  - Problem example: Grid layout is implemented with a table.
  - User impact: Reading order becomes confusing.
  - Fix: Use CSS layout.

## Modals, Menus, Tabs, Accordions

- [ ] Opening a modal moves focus into it and closing returns focus to the opener.
  - Problem example: Focus stays behind the modal.
  - User impact: Keyboard users operate hidden content.
  - Fix: Use `dialog` where possible or implement focus management.
- [ ] Menus can be opened, navigated, and closed by keyboard.
  - Problem example: Hover-only dropdown.
  - User impact: Keyboard and touch users cannot access items.
  - Fix: Add button control, state, and keyboard behavior.
- [ ] Tabs expose selected state and associated panels.
  - Problem example: Active tab is only a CSS class.
  - User impact: State and relationship are not announced.
  - Fix: Use native alternatives where possible or correct tab ARIA pattern.
- [ ] Accordions expose expanded/collapsed state.
  - Problem example: A clickable heading toggles content without button semantics.
  - User impact: Users cannot discover or operate the control.
  - Fix: Use a button and `aria-expanded`.

## Color, Contrast, Motion

- [ ] Color is not the only cue for state or meaning.
  - Problem example: Required fields are only red.
  - User impact: Meaning is lost for some users and environments.
  - Fix: Add text, icons with labels, or structural cues.
- [ ] Text and important UI controls have sufficient contrast for the intended context.
  - Problem example: Pale gray text on white.
  - User impact: Content is hard to read.
  - Fix: Adjust colors in the design tokens or component styles.
- [ ] Motion does not block use and respects reduced-motion settings.
  - Problem example: Carousel auto-advances forever.
  - User impact: Users may lose place or experience discomfort.
  - Fix: Provide pause controls and `prefers-reduced-motion` handling.

## Keyboard And Focus

- [ ] All interactive elements are reachable and operable by keyboard.
  - Problem example: `div` click handlers are not focusable.
  - User impact: Function is inaccessible without a mouse.
  - Fix: Use native controls or add complete keyboard semantics.
- [ ] Focus order follows visual and logical order.
  - Problem example: CSS reorders cards but DOM order stays unrelated.
  - User impact: Navigation feels random.
  - Fix: Align DOM order with reading order.
- [ ] Focus indicators are visible.
  - Problem example: `outline: none` without replacement.
  - User impact: Users cannot tell where they are.
  - Fix: Restore or design a clear focus style.

## Mobile And Touch

- [ ] Tap targets are large enough and not crowded.
  - Problem example: Tiny adjacent icon buttons.
  - User impact: Users trigger the wrong action.
  - Fix: Increase hit area and spacing.
- [ ] Content works with zoom and narrow viewports.
  - Problem example: Fixed-width panels overflow.
  - User impact: Users must pan or cannot reach controls.
  - Fix: Use responsive layout and avoid disabling zoom.

## Framework And CMS Checks

- [ ] React/Astro components preserve accessible names, roles, state, and IDs after composition.
- [ ] SPA or client-side route changes update `title`, main heading, and focus intentionally.
- [ ] WordPress themes style editor and front-end content without removing semantic HTML.
- [ ] Markdown/article content uses headings, lists, tables, images, and links semantically.
