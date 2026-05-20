targetScope = 'resourceGroup'

@description('Globally unique storage account name (3-24 lowercase alphanumeric).')
param storageAccountName string

@description('Azure region for the storage account. Defaults to resource group location.')
param location string = resourceGroup().location

@description('Storage SKU name.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Storage kind.')
@allowed([
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
param kind string = 'StorageV2'

@description('Minimum TLS version for HTTPS traffic.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Whether public network access is enabled for the storage account.')
param publicNetworkAccess string = 'Enabled'

@description('Optional tags to apply to the storage account.')
param tags object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  tags: tags
  properties: {
    accessTier: kind == 'StorageV2' || kind == 'BlobStorage' ? 'Hot' : null
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: true
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: publicNetworkAccess
    supportsHttpsTrafficOnly: true
  }
}

output id string = storageAccount.id
output name string = storageAccount.name
output primaryEndpoints object = storageAccount.properties.primaryEndpoints
