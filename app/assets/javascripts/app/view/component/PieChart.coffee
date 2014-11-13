null
###*
@class AP.view.component.PieChart
@extends AP.view.Chart

Renders a pie chart using data from the specified query scope.
###
class AP.view.component.PieChart extends AP.view.Chart
  className: 'ap-chart ap-piechart'
  chartType: 'pie'
  template: '<div class="ap-chart-container"></div>'
  
  ###*
  Initializes collection instance from the componnet's `datasource` data,
  if any.
  ###
  initializeCollection: ->
    data = @getObjectData()
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
      values: _.map rawData, (datum) ->
        label: datum[series.independentVariable]
        dependentVariable: series.dependentVariable
        independentVariable: series.independentVariable
        value: parseInt datum[series.dependentVariable], 10
    chartData

  ###*
  Renders the chart to `.ap-chart-container`.  If multiple series are
  configured, pie chart appends additional chart titles and `svg` elements and
  renders one-chart-per-series.
  ###
  renderChart: ->
    title = @getObjectData().chartTitle
    data = @getChartData()
    nv.addGraph =>
      @chart = for series, i in data
        $(".#{@extraClassName} .ap-chart-container")
          .append("<div class=\"ap-chart-title ap-text-center\">#{title}: #{series.key}</div>")
          .append('<svg></svg>')
        el = $(".#{@extraClassName} svg:eq(#{i})").get(0)
        chart = nv.models.pieChart()
          .x((d) -> d.label)
          .y((d) -> d.value)
        d3.select(el)
          .datum(series.values)
          .transition().duration(500)
          .call(chart)
        nv.utils.windowResize(chart.update)
        chart
