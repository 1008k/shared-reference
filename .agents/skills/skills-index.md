<!-- managed-by: shared-reference -->
<!-- source-repo: https://github.com/1008k/shared-reference -->
<!-- source-path: .agents/skills/skills-index.md -->
# Shared Skills Index

Use this file as the entry point when deciding whether to use shared skills or optional supporting tools from `shared-reference`.

## How To Read

1. Start from the project `docs/policy-index.yaml`.
2. Check `.shared/shared-index.yaml` to confirm the shared reference location and lock file.
3. Read this index only when the task involves shared skills, optional tooling, context tools, MCP, memory, accessibility review, or migration cleanup.
4. Read only the relevant skill or section below.

## Shared Skills

- `docs-sync/`: Check and reconcile drift across project docs such as `docs/project-spec.md`, `README.md`, and architecture notes.
- `genshijin-lite/`: Keep progress updates, lightweight Q&A, and short implementation summaries concise in natural Japanese while retaining rationale and safety boundaries.
- `project-bootstrap/`: Turn an initial brief into a concrete project spec for docs-first projects.
- `web-a11y-review/`: Review and improve web accessibility for HTML, CSS, JavaScript, React, Astro, WordPress themes, landing pages, and Markdown content.

## Optional Third-Party Skills

- `taste-skill/`: Use for frontend implementation or redesign when a deliberate visual direction is needed. It is an experimental upstream skill; project UX and accessibility requirements remain higher priority.
- `brainstorming/`: Recommend an on-demand session when design refinement would reduce rework; start it only after the user accepts.
- `diagnosing-bugs/`: Use for hard bugs and performance regressions; adapt its diagnostic loop to the project's documented conventions.
- `grilling/`: Use only when the user explicitly asks to stress-test a plan or design. Ask one decision at a time; it does not create project documents automatically.
- `tdd/`: Use when a feature or bug fix is explicitly test-first, or when durable integration tests are needed.
- `writing-plans/`: Recommend an on-demand detailed plan for substantial or risky changes; start it only after the user accepts.
- `verification-before-completion/`: Recommend an on-demand formal verification pass for releases, merges, or high-risk completion claims; start it only after the user accepts.

These skills are shared vendor content, not project rules. Their source, pinned revisions, and license notices are in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Update them only through an intentional upstream review and shared-reference commit; do not add their subagent, worktree, Git workflows, or mandatory test-first process as automatic project behavior.

## Optional Tooling Notes

- MCP baseline: Consider MCP only when it reduces repeated lookup, external documentation drift, repository inspection cost, or operational friction. Record purpose, permissions, external communication, and failure handling in project docs when adopted.
- Context tools: Serena, Context7, Headroom, and Context Mode are useful when codebase size, documentation drift, or repeated context loading becomes costly. Prefer the narrowest tool that solves the current problem.
- Availability and adoption: Do not assume optional tools are installed. When an unavailable tool would materially help, state its purpose, scope, required permissions or external communication, and the normal-workflow fallback, then offer its installation or configuration. Continue with that fallback unless the user chooses to adopt the tool.
- GitHub/reference helpers: Use a GitHub connector or `gh` when a task depends on external repositories, live issues, pull requests, CI, or current upstream docs. It requires the relevant GitHub authentication and repository access; fall back to local Git evidence or user-provided context when unavailable.
- Browser automation: Use Playwright or an available browser controller when rendered UI behavior, live-site state, or repeatable browser flows need evidence. It may require a local browser or an authorized session; fall back to source and static review when unavailable.
- Modern web guidance: For browser UI work, use current platform guidance and browser verification when project compatibility allows it. Keep project-specific browser support and product constraints above generic modern defaults.
- Local memory: Use lightweight memory only when repeated project context would otherwise be lost or duplicated. Do not treat memory as a substitute for current repo evidence.
- Knowledge formats: Optional formats such as Markdown plus YAML frontmatter can help when a project accumulates many reusable notes, but avoid adding a catalog before retrieval pain is real.

## Local Overrides

- Project-specific rules stay in `docs/rules-*.md`.
- Project-specific skill shims or local-only skills may use `.agents/skills/`.
- Shared skill changes should be proposed through `scripts/propose-shared-reference-change.ps1`, not edited in the vendor copy.
