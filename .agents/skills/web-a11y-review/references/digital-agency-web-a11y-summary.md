<!-- managed-by: agent-rules -->
<!-- source-repo: https://github.com/1008k/agent-rules -->
<!-- source-path: .agents/skills/web-a11y-review/references/digital-agency-web-a11y-summary.md -->
# Digital Agency Web Accessibility Summary

Source: Digital Agency, "ウェブアクセシビリティ導入ガイドブック", 2025年10月16日更新版, official resource page: https://www.digital.go.jp/resources/introduction-to-web-accessibility-guidebook

This summary is a practical interpretation for coding agents. Do not copy long passages from the source. Use the source as background for improving web products, content, and operations.

## Core Idea

Web accessibility means making web information and services usable by people with different bodies, devices, environments, literacy levels, and temporary conditions. It is not only for a small group of users and not only for public-sector sites.

Accessibility work should affect planning, design, implementation, content creation, testing, release, and ongoing operation. A site can regress when content is added, UI is redesigned, plugins are introduced, or JavaScript changes behavior.

## Who Benefits

Consider users who:

- Navigate by keyboard or switch devices.
- Use screen readers, magnifiers, captions, transcripts, or browser zoom.
- Have low vision, color vision differences, hearing differences, motor impairments, cognitive load, or temporary injuries.
- Use smartphones outdoors, unstable networks, small screens, old devices, or unusual browser settings.
- Read Japanese content with varying vocabulary familiarity.

## Practical Responsibilities

- Product owners and requesters should set accessibility expectations early.
- Designers should keep meaning, order, contrast, focus, and interaction states visible.
- Developers should preserve semantics and test behavior, not only pixels.
- Content editors should write clear headings, links, alt text, labels, and instructions.
- Operators should keep checking accessibility after release.

## Use In Reviews

Use the guidance to ask:

- Can users perceive the information without depending on one sense or display condition?
- Can users operate all functions without a mouse or precise gestures?
- Can users understand where they are, what changed, and what to do next?
- Is the implementation robust enough for assistive technologies and browser settings?

Avoid claiming formal compliance unless the project has defined a conformance target, test method, representative pages, and documented results.
