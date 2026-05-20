---
name: bicep-module-maintainer
description: Maintain this Bicep module SSoT repository end-to-end. Use when user asks to add, update, fix, refactor, or remove Azure Bicep resources/modules, and always run local CI gates before completion. Trigger phrases include "add bicep resource", "update bicep module", "modify storage module", "create new resource module", "change bicep resource", "extend bicep module", "fix bicep lint", "run bicep ci gates", and "publish bicep module".
---

# Bicep Module Maintainer Skill

Use this skill for all repository changes related to Azure resources and Bicep modules.

## Scope

- Add or update resource templates in resources/.
- Add or update wrapper modules in modules/.
- Keep module contracts stable while allowing resource-layer internals to evolve.
- Update examples and docs when interfaces change.
- Validate changes locally with CI-equivalent gates before finishing.

## Mandatory Workflow

1. Understand requested change and identify impacted files.
2. Implement resource-layer changes in resources/<resourceName>/main.bicep.
3. Implement or update module wrapper in modules/<moduleName>/main.bicep that calls resources layer.
4. Update metadata and docs for changed modules.
5. Update examples if parameters/outputs changed.
6. Run local quality gates (required):
   - az bicep install
   - ./scripts/validate-bicep.sh
7. If any gate fails, fix issues and re-run until all gates pass.
8. Return summary with changed files, validation status, and any follow-up actions.

## Repository Conventions

- resources/: low-level Azure resource declarations.
- modules/: app-facing contracts that call resources.
- examples/: consumer usage.
- scripts/validate-bicep.sh: local gate runner (format, lint, build).
- .github/workflows/bicep-ci.yml: PR/main CI gates.
- .github/workflows/bicep-publish.yml: tag-based publish to ACR.

## Quality Rules

- Do not tightly couple apps to resource templates; apps should consume wrapper modules.
- Keep parameter names descriptive and typed.
- Keep secure defaults where possible (HTTPS only, TLS 1.2+ for storage, no public exposure by default unless requested).
- Keep analyzer and lint compliance aligned with bicepconfig.json.

## Publish Guidance

For release publishing, use git tags in vX.Y.Z format so publish workflow pushes OCI modules to ACR:

- br:<acr-name>.azurecr.io/bicep/modules/<module-name>:<version>

## Completion Criteria

A task is complete only when:

- Required code/doc/example updates are done.
- Local gates completed successfully via scripts/validate-bicep.sh.
- No unresolved lint/build failures remain.
