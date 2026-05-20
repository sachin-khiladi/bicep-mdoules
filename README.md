# Bicep Modules SSoT Repository

This repository is a single source of truth for reusable Bicep modules.

## Architecture

- `resources/`: low-level Azure resource templates.
- `modules/`: app-facing wrapper modules that call templates from `resources/`.
- `examples/`: usage examples for app teams.

Current module:

- `modules/storage`: storage module wrapper.

## Why this design

The module layer stays stable for application teams while the resource layer can evolve internally.

## CI gates

The CI workflow enforces:

- format checks (`bicep format --check`)
- lint checks (`bicep lint`)
- compile validation (`bicep build`)

## Publish to ACR

Release tags (`v*.*.*`) trigger module publication to ACR as OCI artifacts.

Target format:

- `br:<acr-name>.azurecr.io/bicep/modules/storage:<version>`

Required GitHub secrets:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `ACR_NAME`

## Local validation

```bash
chmod +x scripts/validate-bicep.sh
./scripts/validate-bicep.sh
```

## Copilot skill for maintenance

This repo includes a workspace skill for add/update operations on Bicep resources and modules:

- .agents/skills/bicep-module-maintainer/SKILL.md

The skill enforces a mandatory local gate run before completion:

- `./scripts/validate-bicep.sh`

## App team consumption

Use the published module from ACR:

```bicep
module storage 'br:<acr-name>.azurecr.io/bicep/modules/storage:<version>' = {
  name: 'my-storage'
  params: {
    storageAccountName: 'uniquestorageacctname'
  }
}
```
