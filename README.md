# Shared Reference

Shared reference documents, baseline rules, and skills.

This repository is the source of truth for reusable files that are vendored into individual projects. Project-specific requirements, specs, and local overrides should stay in each project.

## Quick Paths

### Install in a Project

From this repository:

```powershell
scripts/adopt-shared-reference.ps1 -ProjectRoot V:\dev\your-project -Ref main
```

The script installs lightweight project wrappers, writes `.shared/shared-reference.lock.yaml`, and syncs the managed files into the project. For detailed installation, update, cleanup, and reusable prompts, see [docs/install-in-project.md](docs/install-in-project.md).

### Change a Shared Rule

Do not edit vendored managed files directly inside a project. To find the source file:

```powershell
scripts/propose-shared-reference-change.ps1 -VendorPath .shared\docs\rules-coding.md
```

Edit and commit the file in this repository, push `shared-reference`, then sync each project to the new commit.

## What Syncs

- `shared-index.yaml` -> project `.shared/shared-index.yaml`
- `docs/` -> project `.shared/docs/`
- `.agents/skills/` -> project `.shared/skills/`

Project-owned documents and exceptions stay outside `.shared/`. See the installation guide for local overrides and disabled managed paths.

## Reading Order in a Consumer Project

1. Read the project's `docs/policy-index.yaml` when present.
2. Read `.shared/shared-index.yaml` for the shared baseline.
3. Read the relevant project-owned override and shared rule or skill.

The project policy index decides the precedence between its local documents and the shared baseline.

## Review Flow

Changes in this repository can affect every project that syncs from it. Prefer pull requests for shared rule changes, especially when changing baseline rules, skills, or sync behavior. Direct commits are acceptable for small typo fixes or repo maintenance.

## Validation

Run the lightweight validator before pushing:

```powershell
scripts/validate-shared-reference.ps1
```

The validator checks manifest paths, managed headers, skill frontmatter, and PowerShell syntax.
