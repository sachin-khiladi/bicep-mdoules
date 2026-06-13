---
name: bicep-repo-reviewer
description: Review this Bicep module repository end-to-end and propose or implement consistency, quality, and CI-aligned improvements across resources, modules, examples, docs, and workflows. Use when user asks to review the repo, audit module quality, align docs/examples, or harden CI readiness.
---

# Bicep Repo Reviewer Skill

Use this skill when the user asks for a full or partial repository review focused on Bicep module quality and maintainability.

## Scope

- Review repository structure and conventions across:
  - `resources/`
  - `modules/`
  - `examples/`
  - `docs/`
  - `.github/workflows/`
  - `scripts/`
- Validate consistency between:
  - Resource templates and wrapper modules
  - Module contracts and examples
  - Documentation and actual implementation
- Identify gaps in lint/build/publish readiness.

## Review Checklist

1. **Structure and layering**
   - Ensure low-level declarations stay in `resources/`.
   - Ensure consumer-facing contracts stay in `modules/`.
   - Ensure `examples/` consume modules (not raw resources) unless explicitly intended.

2. **Contract quality**
   - Check parameter naming, typing, defaults, and descriptions.
   - Check outputs are useful, stable, and documented.
   - Flag breaking interface changes and suggest migration notes.

3. **Security and defaults**
   - Prefer secure-by-default settings.
   - Verify common hardening settings relevant to the resource type.
   - Flag risky defaults (public exposure, weak TLS, overly permissive access).

4. **Documentation alignment**
   - Verify module README reflects current parameters/outputs.
   - Ensure examples match current module contract.
   - Ensure architecture docs stay aligned with current structure.

5. **CI and validation readiness**
   - Confirm repository aligns with `bicepconfig.json` analyzer expectations.
   - Validate expected checks in `scripts/validate-bicep.sh` and CI workflows.
   - Recommend improvements for deterministic CI outcomes.

## Mandatory Workflow

1. Read the requested review scope (repo-wide or targeted paths).
2. Inspect relevant files in `resources/`, `modules/`, `examples/`, `docs/`, `scripts/`, and workflows.
3. Produce findings grouped by severity:
   - Critical (must fix)
   - Important (should fix)
   - Nice to have
4. If asked to implement fixes, apply minimal, safe changes first.
5. Run local validation gates:
   - `az bicep install`
   - `./scripts/validate-bicep.sh`
6. Re-run until gates pass or clearly report blockers.
7. Return:
   - Findings summary
   - Files changed (if any)
   - Validation status
   - Follow-up recommendations

## Output Format Expectations

When returning a review, include:

- **Summary**: overall health snapshot.
- **Findings**: prioritized bullet list with path references.
- **Fix Plan**: concrete, ordered remediation steps.
- **Validation**: gate outcomes and remaining risks.

## Completion Criteria

A review task is complete only when:

- Requested scope was fully assessed.
- Findings are actionable and prioritized.
- Any implemented changes were validated locally (or blockers explicitly documented).
- Report clearly states current repo readiness and next actions.
