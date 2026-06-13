# AGENTS.md

## Workspace Instructions for AI Coding Agents

This repository is a Bicep module SSoT (single source of truth) for Azure resources and reusable wrapper modules.

### Repository Layout

- `resources/`: low-level Azure resource declarations (building blocks)
- `modules/`: consumer-facing wrapper modules (stable contracts)
- `examples/`: usage examples for module consumers
- `docs/`: design and architecture notes
- `scripts/`: local validation and helper scripts
- `.github/workflows/`: CI and publishing automation

### Primary Skills (Use First)

- `bicep-module-maintainer`
  - File: `.agents/skills/bicep-module-maintainer/SKILL.md`
  - Use for add/update/fix/refactor/remove resource or module code.

- `bicep-repo-reviewer`
  - File: `.agents/skills/bicep-repo-reviewer/SKILL.md`
  - Use for full/partial repo audits, consistency checks, and CI-readiness review.
- `bicep-pr-creator`
  - File: `.agents/skills/bicep-pr-creator/SKILL.md`
  - Use for creating well-structured pull requests with validation, change categorization, and risk assessment.
> Link, don’t duplicate: detailed workflows live in the skill files above.

### Mandatory Validation Flow

Before completing implementation/review changes, run local gates:

1. `az bicep install`
2. `./scripts/validate-bicep.sh`

If a gate fails:
- fix issues,
- re-run gates,
- report remaining blockers clearly if unresolved.

### Conventions

- Keep `resources/` as implementation layer and `modules/` as stable contract layer.
- Update docs/examples when module parameters or outputs change.
- Keep parameter names descriptive and typed.
- Prefer secure defaults.
- Maintain analyzer/lint compliance with `bicepconfig.json`.

### CI / Publish Awareness

- CI checks: `.github/workflows/bicep-ci.yml`
- Publish workflow: `.github/workflows/bicep-publish.yml`
- Versioned publish flow expects git tags in `vX.Y.Z` format.

### Suggested Prompts

- "Use `bicep-module-maintainer` to add a new resource module and update examples."
- "Use `bicep-repo-reviewer` to audit this repo and propose prioritized fixes."
- "Use `bicep-pr-creator` to create a PR for the current changes."
- "Run CI-equivalent local gates and summarize failures with fixes."

### Output Expectations

When reporting back, include:
- files changed,
- validation status,
- unresolved risks/blockers,
- concise next steps.
