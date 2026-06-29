# Shared Reference

Shared reference documents, baseline rules, integration notes, and skills.

This repository is the source of truth for reusable files that are vendored into individual projects. Project-specific requirements, specs, and local overrides should stay in each project.

## Managed Paths

- `docs/` -> project `.shared/docs/`
- `.agents/skills/` -> project `.shared/skills/`

## Install In A Project

From this repository:

```powershell
scripts/adopt-shared-reference.ps1 -ProjectRoot V:\dev\your-project -Ref main
```

The script installs lightweight project wrappers, writes `.shared/shared-reference.lock.yaml`, and syncs the managed files into the project.

For a new project copied from `_project-starter`, the wrappers and lock file may already exist. In that case, update the vendored copy from the project:

```powershell
scripts/sync-shared-reference.ps1 -Ref <shared-reference-commit>
```

## Update Shared Rules

Do not edit vendored managed files directly inside a project. To find the source file:

```powershell
scripts/propose-shared-reference-change.ps1 -VendorPath .shared\docs\shared-rules\rules-coding.md
```

Edit and commit the file in this repository, push `shared-reference`, then sync each project to the new commit.

## Project Layout

Recommended project layout:

```text
docs/
  policy-index.yaml
  rules-coding.md
  rules-ux.md
  rules-writing.md
  integrations/

.shared/
  shared-reference.lock.yaml
  shared-index.yaml
  docs/
    shared-rules/
    integrations/
  skills/
```

Project-owned documents stay in `docs/`. Vendored shared documents and skills stay under `.shared/`. The project `docs/policy-index.yaml` should link to `.shared/shared-index.yaml` when shared guidance is relevant.

## Local Overrides

- Put project-specific coding, UX, and writing exceptions in `docs/rules-coding.md`, `docs/rules-ux.md`, and `docs/rules-writing.md`.
- Put project-specific integration notes in `docs/integrations/`.
- Put project-specific skills in `.agents/skills/` using a unique skill name. Some agents only auto-discover skills from `.agents/skills/`; shared skills in `.shared/skills/` may need explicit routing from project docs or a local shim.
- If a shared file should not sync into a project, add its source path to `disabled` in `.shared/shared-reference.lock.yaml`.

Example:

```yaml
disabled:
  - docs/integrations/
  - .agents/skills/web-a11y-review/
```

## Review Flow

Changes in this repository can affect every project that syncs from it. Prefer pull requests for shared rule changes, especially when changing baseline rules, skills, or sync behavior. Direct commits are acceptable for small typo fixes or repo maintenance.

## Validation

Run the lightweight validator before pushing:

```powershell
scripts/validate-shared-reference.ps1
```

The validator checks manifest paths, managed headers, skill frontmatter, and PowerShell syntax.
