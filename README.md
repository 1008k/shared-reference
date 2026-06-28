# Agent Rules

Shared agent-facing rules, integration notes, and skills.

This repository is the source of truth for reusable files that are vendored into individual projects. Project-specific requirements, specs, and local overrides should stay in each project.

## Managed Paths

- `docs/integrations/`
- `.agents/skills/`

Use `scripts/sync-agent-rules.ps1` from a project to update vendored copies. Use `scripts/propose-shared-rule-change.ps1` to locate the source file in this repository before changing shared guidance.
