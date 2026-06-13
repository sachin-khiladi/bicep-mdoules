targetScope = 'resourceGroup'

@description('Name of the Container App. Must be unique within the environment (2-32 chars, lowercase alphanumeric and hyphens).')
param containerAppName string

@description('Azure region for the container app. Defaults to resource group location.')
param location string = resourceGroup().location

@description('Resource ID of the Container Apps Environment to deploy into.')
param environmentId string

@description('Container image to deploy (e.g. mcr.microsoft.com/azuredocs/containerapps-helloworld:latest).')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('CPU cores allocated to the container (in cores, e.g. 0.5, 1.0, 2.0).')
param containerCpu string = '0.5'

@description('Memory allocated to the container (e.g. 1.0Gi, 2.0Gi).')
param containerMemory string = '1.0Gi'

@description('Target port the container listens on for HTTP traffic.')
@minValue(1)
@maxValue(65535)
param targetPort int = 80

@description('Whether ingress is enabled for the container app (creates public or internal FQDN).')
param enableIngress bool = false

@description('Whether the ingress is exposed externally (true) or only within the environment (false).')
param externalIngress bool = false

@description('Minimum number of replicas. Set to 0 for scale-to-zero.')
@minValue(0)
param minReplicas int = 0

@description('Maximum number of replicas.')
@minValue(1)
param maxReplicas int = 10

@description('Whether active revisions should not be automatically deactivated (single revision mode).')
param revisionMode string = 'single'

@description('Optional tags to apply to the container app.')
param tags object = {}

@description('Optional environment variables for the container.')
param envVariables array = []

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: containerAppName
  location: location
  tags: tags
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      activeRevisionsMode: revisionMode
      ingress: enableIngress
        ? {
            external: externalIngress
            targetPort: targetPort
            allowInsecure: false
            traffic: [
              {
                latestRevision: true
                weight: 100
              }
            ]
          }
        : null
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: containerImage
          resources: {
            cpu: json(containerCpu)
            memory: containerMemory
          }
          env: envVariables
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

output id string = containerApp.id
output name string = containerApp.name
output fqdn string = enableIngress ? containerApp.properties.configuration.ingress.fqdn : ''
output latestRevisionFqdn string = enableIngress ? containerApp.properties.latestRevisionFqdn : ''
