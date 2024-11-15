param serviceName string
param location string
param organizationName string
param administratorEmail string

resource apim 'Microsoft.ApiManagement/service@2024-05-01' = {
  name: serviceName
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: administratorEmail
    publisherName: organizationName
  }
}

output id string = apim.id
