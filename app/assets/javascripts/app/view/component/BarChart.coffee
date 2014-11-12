null
###*
@class AP.view.component.BarChart
@extends AP.view.Chart

Login page.  Using authentication settngs from the `AP.auth.Authentication`
module, username and password fields are generated.
###
class AP.view.component.BarChart extends AP.view.Chart
  ###*
  @inheritdoc
  ###
  className: 'ap-chart ap-barchart'
  
  ###*
  @inheritdoc
  ###
  chartType: 'bar'
  
  ###*
  Initializes collection instance from the componnet's `datasource` data,
  if any.
  ###
  initializeCollection: ->
    collectionClass = @getCollectionClass()
    @collection = new collectionClass if collectionClass
    super
  
  ###*
  @return {AP.collection.Collection} collection class for the chart.
  ###
  getCollectionClass: -> AP.getActiveApp().getCollection @getData?()?.datasource
  
  ###*
  Extends object data with a `series` member, an array of series objects.  Each
  series object has two members:  `independentVariable` and `dependentVariable`,
  used for data transformation.
  @return {Object} object data (see parent class) plus `series`
  ###
  getObjectData: ->
    data = super
    data.chartTitle = data.title if data.title
    data.series = []
    if @collection and data.independent_field_definitions and data.dependent_field_definitions
      model = @collection.model
      fieldDefs = model::fieldDefinitions or []
      data.series = _.flatten _.map data.independent_field_definitions, (iValue, iName) ->
        _.map data.dependent_field_definitions, (dValue, dName) ->
          independentVariable: iName
          dependentVariable: dName
    data
  
  ###*
  Transforms raw data according to series (see `getObjectData` method) for
  use in charts.  Chart data is an array of _series_ objects.  Each series
  object includes a `key` member (the series name) and a `values` member, the
  transformed series dataset for use in charts.
  @return {Array} series objects of transformed chart-ready data
  ###
  getChartData: ->
    objectData = @getObjectData()
    rawData = @collection.toJSON()
    chartData = for series in objectData.series
      key: "#{series.dependentVariable} by #{series.independentVariable}"
      dependentVariable: series.dependentVariable
      independentVariable: series.independentVariable
      values: _.map rawData, (datum) ->
        label: datum[series.independentVariable].toString()
        value: parseInt datum[series.dependentVariable], 10
    chartData
  
  ###*
  Renders the chart to `.ap-chart-container`.
  ###
  renderChart: ->
    data = @getChartData()
    nv.addGraph =>
      @chart = nv.models.multiBarHorizontalChart()
        .x((d) -> d.label)
        .y((d) -> d.value)
        .showControls(false)
      axisLabel = (series.dependentVariable for series in data).join('; ')
      @chart.yAxis.axisLabel(axisLabel)
      d3.select(".#{@extraClassName} svg")
        .datum(data)
        .transition().duration(500)
        .call(@chart)
      nv.utils.windowResize(@chart.update)
      @chart
