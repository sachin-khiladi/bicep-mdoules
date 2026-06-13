# Container Apps Module

This module is the app-facing wrapper for provisioning Azure Container Apps with a managed environment and Log Analytics workspace.

## Design

- `modules/containerApps/main.bicep`: app-consumable module contract — deploys environment, Log Analytics, and container app.
- `resources/containerAppEnvironment/main.bicep`: underlying Container Apps Environment resource.
- `resources/containerApp/main.bicep`: underlying Container App resource.

This keeps module contracts decoupled from low-level resource declarations.

## Inputs

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `environmentName` | string | Yes | — | Globally unique name for the Container Apps environment |
| `containerAppName` | string | Yes | — | Name of the Container App (unique within the environment) |
| `location` | string | No | `resourceGroup().location` | Azure region for all resources |
| `containerImage` | string | No | `mcr.microsoft.com/azuredocs/containerapps-helloworld:latest` | Container image to deploy |
| `containerCpu` | string | No | `0.5` | CPU cores (e.g. `0.5`, `1.0`, `2.0`) |
| `containerMemory` | string | No | `1.0Gi` | Memory (e.g. `1.0Gi`, `2.0Gi`) |
| `targetPort` | int | No | `80` | HTTP target port (1–65535) |
| `enableIngress` | bool | No | `false` | Enable HTTP ingress |
| `externalIngress` | bool | No | `false` | Public (true) or internal only (false) ingress |
| `minReplicas` | int | No | `0` | Minimum replicas (0 = scale-to-zero) |
| `maxReplicas` | int | No | `10` | Maximum replicas |
| `revisionMode` | string | No | `single` | `single` or `multiple` |
| `zoneRedundant` | bool | No | `false` | Zone redundancy for the environment |
| `tags` | object | No | `{}` | Tags applied to all resources |
| `envVariables` | array | No | `[]` | Environment variables for the container |

## Outputs

| Output | Type | Description |
|---|---|---|
| `environmentId` | string | Resource ID of the Container Apps Environment |
| `environmentNameOut` | string | Name of the environment |
| `environmentDefaultDomain` | string | Default domain for the environment |
| `environmentStaticIp` | string | Static IP of the environment |
| `containerAppId` | string | Resource ID of the Container App |
| `containerAppNameOut` | string | Name of the Container App |
| `containerAppFqdn` | string | FQDN of the container app (empty if ingress disabled) |
| `logAnalyticsWorkspaceId` | string | Resource ID of the Log Analytics workspace |

## Publish Target

`br:<acr-name>.azurecr.io/bicep/modules/containerApps:<version>`