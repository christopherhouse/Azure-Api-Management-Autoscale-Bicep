import { autoScaleRuleType } from '../userDefinedTypes/userDefinedTypes.bicep'

@description('The Azure resource where the autoscale settings will be applied')
param targetResourceId string

@description('The location of the autoscale settings.  Defaults to the location of the targetResourceId')
param location string

@description('The name of the autoscale settings.  Defaults to {targetResourceId}-autoscale')
param autoscaleSettingsName string = '${split('/', targetResourceId)[8]}-autoscale'

@description('The name of the metric that will be used to scale out')
param scaleOutMetricName string

@description('The operator to use when evaluating the scale out metric')
@allowed([
  'Equals'
  'NotEquals'
  'GreaterThan'
  'GreaterThanOrEqual'
  'LessThan'
  'LessThanOrEqual'
])
param scaleOutMetricOperator string

@description('The metric threshold value to trigger a scale out event')
param scaleOutMetricThreshold int

@description('The name of the metric that will be used to scale in')
param scaleInMetricName string

@description('The metric threshold value to trigger a scale in event')
param scaleInMetricThreshold int

@description('The operator to use when evaluating the scale in metric')
@allowed([
  'Equals'
  'NotEquals'
  'GreaterThan'
  'GreaterThanOrEqual'
  'LessThan'
  'LessThanOrEqual'
])
param scaleInMetricOperator string

@description('A list of email addresses to notify when a scale event occurs')
param emailNotificationAddresses string[] = []

@description('A flag indicating if the subscription admins should be notified when a scale event occurs')
param notifySubscriptionAdmins bool

@description('The default number of instances for this scale rule')
param defaultInstances int

@description('The maximum number of instances for this scale rule')
param maxInstances int

@description('The minimum number of instances for this scale rule')
param minInstances int

@description('The scale rules to apply to the autoscale settings')
param scaleRules autoScaleRuleType[]

@description('Tags to apply to the autoscale settings')
param tags object

@description('The Log Analytics workspace ID to send autoscale logs to')
param logAnalyticsWorkspaceId string

var notifications = [
  {
    email: {
      customEmails: emailNotificationAddresses
      sendToSubscriptionAdministrator: notifySubscriptionAdmins
    }
    operation: 'Scale'
  }
]

resource asr 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: autoscaleSettingsName
  location: location
  tags: tags
  properties: {
    enabled: true
    name: autoscaleSettingsName
    notifications: notifications
    profiles: [
      {
        name: autoscaleSettingsName
        capacity: {
          default: string(defaultInstances)
          maximum: string(maxInstances)
          minimum: string(minInstances)
        }
        rules: scaleRules
      }
    ]
  }
}

resource diags 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diags-${autoscaleSettingsName}'
  scope: asr
  properties: {
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    workspaceId: logAnalyticsWorkspaceId
  }
}
