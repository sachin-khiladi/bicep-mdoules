targetScope = 'resourceGroup'

@description('Globally unique name for the Container Apps environment.')
param environmentName string

@description('Name of the Container App. Must be unique within the environment.')
param containerAppName string

@description('Azure region for all resources. Defaults to resource group location.')
param location string = resourceGroup().location

@description('Container image to deploy.')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('CPU cores allocated to the container (e.g. 0.5, 1.0, 2.0).')
param containerCpu string = '0.5'

@description('Memory allocated to the container (e.g. 1.0Gi, 2.0Gi).')
param containerMemory string = '1.0Gi'

@description('Target port for HTTP traffic.')
@minValue(1)
@maxValue(65535)
param targetPort int = 80

@description('Enable external ingress for the container app.')
param enableIngress bool = false

@description('Whether ingress is publicly accessible (true) or internal only (false). Ignored when enableIngress is false.')
param externalIngress bool = false

@description('Minimum number of replicas. 0 enables scale-to-zero.')
@minValue(0)
param minReplicas int = 0

@description('Maximum number of replicas.')
@minValue(1)
param maxReplicas int = 10

@description('Revision mode: single (one active revision) or multiple.')
@allowed([
  'single'
  'multiple'
])
param revisionMode string = 'single'

@description('Whether to enable zone redundancy for the environment.')
param zoneRedundant bool = false

@description('Optional tags to apply to all resources.')
param tags object = {}

@description('Optional environment variables for the container.')
param envVariables array = []

module environmentResource '../../resources/containerAppEnvironment/main.bicep' = {
  name: 'env-${uniqueString(resourceGroup().id, environmentName)}'
  params: {
    environmentName: environmentName
    location: location
    zoneRedundant: zoneRedundant
    logAnalyticsWorkspaceId: logAnalytics.id
    tags: tags
  }
}

module containerAppResource '../../resources/containerApp/main.bicep' = {
  name: 'app-${uniqueString(resourceGroup().id, containerAppName)}'
  params: {
    containerAppName: containerAppName
    location: location
    environmentId: environmentResource.outputs.id
    containerImage: containerImage
    containerCpu: containerCpu
    containerMemory: containerMemory
    targetPort: targetPort
    enableIngress: enableIngress
    externalIngress: externalIngress
    minReplicas: minReplicas
    maxReplicas: maxReplicas
    revisionMode: revisionMode
    tags: tags
    envVariables: envVariables
  }
}

// Log Analytics workspace for container logs
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-${environmentName}'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output environmentId string = environmentResource.outputs.id
output environmentNameOut string = environmentResource.outputs.name
output environmentDefaultDomain string = environmentResource.outputs.defaultDomain
output environmentStaticIp string = environmentResource.outputs.staticIp
output containerAppId string = containerAppResource.outputs.id
output containerAppNameOut string = containerAppResource.outputs.name
output containerAppFqdn string = enableIngress ? containerAppResource.outputs.fqdn : ''
output logAnalyticsWorkspaceId string = logAnalytics.id
