@export()
type autoScaleRuleCompareOperator = 'Equals' | 'NotEquals' | 'GreaterThan' | 'GreaterThanOrEqual' | 'LessThan' | 'LessThanOrEqual'

@export()
type autoscaleMetricStatisticType = 'Average' | 'Count' | 'Max' | 'Min' | 'Sum'

@export()
type autoScaleRuleType = {
  metricTrigger: {
    metricName: string
    metricNamespace: string
    metricResourceUri: string
    metricResourceLocation: string
    operator: autoScaleRuleCompareOperator
    timeAggregation: autoscaleMetricStatisticType
    timeGrain: string
    timeWindow: string
  }
  scaleAction: {
    cooldown: string
    direction: string
    type: 'ChangeCount' | 'ExactCount' | 'PercentChangeCount'
    value: string
  }
}
