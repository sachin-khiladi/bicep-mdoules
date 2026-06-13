---
name: bicep-pr-creator
description: Create a well-formed pull request for this Bicep module SSoT repository. Runs local CI gates first, generates a structured PR description (with change summary, validation results, and risk assessment), and optionally opens the PR via GitHub CLI. Trigger phrases include "create PR", "open pull request", "raise PR", "submit PR", "create pull request", "bicep PR", and "send PR".
---

# Bicep PR Creator Skill

Use this skill to create a high-quality, review-ready pull request for this Bicep module repository. It enforces local validation before PR creation and follows industry-standard PR best practices.

## Scope

- Run mandatory local CI gates prior to PR creation.
- Auto-detect changed files and categorize by layer (`resources/`, `modules/`, `examples/`, `docs/`, `scripts/`, `.github/`).
- Generate a structured, professional PR description.
- Optionally open the PR using `gh pr create` with labels, reviewers, and linked issues.
- Ensure the PR aligns with repo conventions and CI expectations.

## PR Quality Standards

Every PR must include:

1. **Descriptive, concise title** — `<type>(<scope>): <summary>` (Conventional Commits style)
   - Types: `feat`, `fix`, `refactor`, `docs`, `chore`, `ci`, `test`
   - Scope: module/resource name or `repo`
   - Example: `feat(storage): add network ACL parameters`

2. **Structured body** with:
   - **What**: What changed and why
   - **Files Changed**: Grouped by layer
   - **Validation**: Gate results (format/lint/build)
   - **Risk Assessment**: Breaking changes, migration needed, or low risk
   - **Linked Issues**: Reference any related issues or work items

3. **Pre-merge checklist** (checked or unchecked)

4. **Zero validation failures** — local gates must pass before PR is created

## Mandatory Workflow

### Step 1: Pre-Flight — Run Local Gates
```bash
az bicep install
./scripts/validate-bicep.sh
```
- If gates fail: identify issues, fix them, re-run until all pass.
- Do NOT proceed to PR creation with failing gates.
- If blockers are genuinely unresolvable, flag them explicitly and ask user before continuing.

### Step 2: Analyze Changes
- Run `git diff --stat origin/main...HEAD` (or equivalent) to identify changed files.
- Categorize changes by layer:
  - `resources/` — resource template changes
  - `modules/` — wrapper contract changes (flag as potentially breaking)
  - `examples/` — example updates
  - `docs/` — documentation
  - `scripts/` — tooling
  - `.github/` — CI/workflow changes
- Identify if any module outputs, parameters, or types changed (breaking vs. additive).

### Step 3: Build the PR
Generate the PR with:

#### Title
```
<type>(<scope>): <imperative-mood summary>
```

#### Body Template
```markdown
## What
<!-- Brief summary of the change and motivation -->

## Files Changed

### Resources
- `path/to/file` — description

### Modules
- `path/to/file` — description

### Examples
- `path/to/file` — description

### Docs / Other
- `path/to/file` — description

## Validation

- [x] Format check — PASSED
- [x] Lint check — PASSED
- [x] Build check — PASSED

## Risk Assessment
<!-- Choose one -->
- **Low** — additive change, no breaking contract modifications
- **Medium** — change modifies existing behavior but has migration path
- **High** — breaking change, requires consumer coordination

## Linked Issues
<!-- e.g., Closes #123, Related to #456 -->

## Pre-Merge Checklist
- [ ] CI gates pass (format, lint, build)
- [ ] Module metadata.json updated if applicable
- [ ] Examples updated if parameters/outputs changed
- [ ] README.md updated if interface changed
- [ ] Breaking changes documented in PR description
```

### Step 4: Create the PR (Optional)
If the user confirms, use `gh pr create`:
```bash
gh pr create \
  --title "<type>(<scope>): <summary>" \
  --body "$(cat /tmp/pr_body.md)" \
  --base main \
  --label "<relevant-labels>"
```

Suggested labels:
- `breaking-change` — if module interface changed
- `resource` — resource-layer changes
- `module` — module-layer changes
- `docs` — documentation only
- `ci` — workflow/CI changes

### Step 5: Post-Creation
- Report the PR URL.
- List any manual follow-ups needed (e.g., "request review from platform-team", "update ACR after merge").
- Remind the user that merging to `main` triggers the auto-publish workflow (new `vX.Y.Z` tag → ACR push).

## Conventional Commits Mapping

| Change Type | Prefix | Example |
|---|---|---|
| New module/resource | `feat(scope):` | `feat(storage): add encryption scope support` |
| Bug fix | `fix(scope):` | `fix(storage): correct TLS default value` |
| Internal refactor (no contract change) | `refactor(scope):` | `refactor(storage): simplify SKU mapping` |
| Docs only | `docs:` | `docs: add architecture diagram` |
| CI / tooling | `ci:` or `chore:` | `ci: add scheduled lint workflow` |

## Completion Criteria

A PR creation task is complete only when:

- All local validation gates passed (`az bicep install` + `./scripts/validate-bicep.sh`).
- A structured, review-ready PR exists (or the text is ready for manual creation).
- Change categorization and risk assessment are accurate.
- The PR title follows Conventional Commits format.
- Any unresolved blockers are clearly documented.

## Repository Context

- **CI triggers on PR**: `.github/workflows/bicep-ci.yml` runs format/lint/build on every PR to `main`.
- **Auto-publish on merge**: `.github/workflows/bicep-publish.yml` auto-tags and publishes to ACR when CI passes on `main`.
- **Secrets required**: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `ACR_NAME`.
- **Branch strategy**: feature branches → PR to `main` → CI → merge → auto-publish.
- **OIDC auth**: All workflows use workload identity federation (no stored credentials).