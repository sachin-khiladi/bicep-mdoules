targetScope = 'resourceGroup'

@description('Globally unique name for the Container Apps environment.')
param environmentName string

@description('Name of the Container App to deploy.')
param containerAppName string

@description('Container image to deploy.')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

module containerApps '../../modules/containerApps/main.bicep' = {
  name: 'example-containerapps'
  params: {
    environmentName: environmentName
    containerAppName: containerAppName
    containerImage: containerImage
    containerCpu: '0.5'
    containerMemory: '1.0Gi'
    targetPort: 80
    enableIngress: true
    externalIngress: true
    minReplicas: 0
    maxReplicas: 3
    revisionMode: 'single'
    tags: {
      environment: 'dev'
      source: 'bicep-module-ssot'
    }
  }
}

output containerAppFqdn string = containerApps.outputs.containerAppFqdn
output containerAppId string = containerApps.outputs.containerAppId
output environmentId string = containerApps.outputs.environmentId
