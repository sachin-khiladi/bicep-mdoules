# Storage Module

This module is the app-facing wrapper for provisioning Azure Storage Account resources.

## Design

- `modules/storage/main.bicep`: app-consumable module contract.
- `resources/storageAccount/main.bicep`: underlying resource implementation.

This keeps module contracts decoupled from low-level resource declarations.

## Inputs

- `storageAccountName` (string, required)
- `location` (string, optional)
- `skuName` (string, optional)
- `kind` (string, optional)
- `minimumTlsVersion` (string, optional)
- `publicNetworkAccess` (string, optional)
- `tags` (object, optional)

## Outputs

- `id`
- `name`
- `primaryEndpoints`

## Publish Target

`br:<acr-name>.azurecr.io/bicep/modules/storage:<version>`
