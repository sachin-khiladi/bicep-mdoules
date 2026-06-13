targetScope = 'resourceGroup'

@description('Globally unique name for the Container Apps environment (4-32 chars, alphanumeric and hyphens).')
param environmentName string

@description('Azure region for the environment. Defaults to resource group location.')
param location string = resourceGroup().location

@description('Whether zone redundancy is enabled for the environment.')
param zoneRedundant bool = false

@description('The Log Analytics workspace resource ID for container app logs.')
param logAnalyticsWorkspaceId string

@description('Optional tags to apply to the environment.')
param tags object = {}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: environmentName
  location: location
  tags: tags
  properties: {
    zoneRedundant: zoneRedundant
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(logAnalyticsWorkspaceId, '2022-10-01').customerId
        sharedKey: listKeys(logAnalyticsWorkspaceId, '2022-10-01').primarySharedKey
      }
    }
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
  }
}

output id string = containerAppEnvironment.id
output name string = containerAppEnvironment.name
output defaultDomain string = containerAppEnvironment.properties.defaultDomain
output staticIp string = containerAppEnvironment.properties.staticIp
