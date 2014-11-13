null
###*
@class AP.view.Chart
@extends AP.view.DataView

Wrapper for a chart.  Charts plot data from a data-view collection
using an `independentVariable` and a `dependentVariable`.  Note:  unlike most
data views, charts have no data view items.

Learn more about X at {@link http://www.X.org/}.
###
class AP.view.Chart extends AP.view.DataView
  ###*
  @inheritdoc
  ###
  className: 'ap-chart'
  
  ###*
  The chart object instance or array of instances.
  ###
  chart: null
  
  ###*
  @property {String}
  ###
  chartTitle: ''
  
  ###*
  @property {String}
  Field name for the independent variable.
  ###
  independentVariable: null
  
  ###*
  @property {String}
  Field name for the dependent variable.
  ###
  depdendentVariable: null
  
  ###*
  @property {String}
  Chart container template.  Chart is rendered into this element.
  ###
  template: '''
    <div class="ap-chart-container">
      <div class="ap-chart-title ap-text-center">{{ chartTitle }}</div>
      <svg></svg>
    </div>
  '''
  
  ###*
  Re-instantiates a new chart from collection data, if any.  Shows the no-data
  message if no collection data exists.
  ###
  reset: ->
    if @collection?.length
      @noDataMessage.hide()
      options = @getChartOptions()
      @renderChart options
    else
      @noDataMessage.show()
    @trigger 'datareset'
    @collection.previousLength = @collection.length if @collection?.length
  
  ###*
  @inheritdoc
  ###
  append: (el) -> @$el.find('.ap-chart-container').append el
  
  ###*
  @inheritdoc
  ###
  appendExtra: (el) -> @$el.append el
  
  ###*
  Maps data from this data view's `collection` into the expected format.
  @return {Object/Array} Formatted data object or array
  ###
  getChartData: -> {}
  
  ###*
  Builds an options object for chart instantiation.
  @return {Object} Formatted options object
  ###
  getChartOptions: ->
    objectData = @getObjectData()
    options = {}
    options
  
  ###*
  Renders the chart to `.ap-chart-container`.  Subclasses must implement
  this method.
  ###
  renderChart: ->
    # pass
