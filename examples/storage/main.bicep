targetScope = 'resourceGroup'

@description('Globally unique storage account name for this example deployment.')
param storageAccountName string

module storage '../../modules/storage/main.bicep' = {
  name: 'example-storage-module'
  params: {
    storageAccountName: storageAccountName
    tags: {
      environment: 'dev'
      source: 'bicep-module-ssot'
    }
  }
}

output storageAccountId string = storage.outputs.id
output storageAccountNameOut string = storage.outputs.name
