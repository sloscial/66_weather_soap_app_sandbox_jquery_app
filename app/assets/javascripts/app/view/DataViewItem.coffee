null
###*
@class AP.view.DataViewItem
@extends AP.view.View

Data view item is a simple view for displaying a single record.  Typically, data
view items are instantiated by {@link AP.view.DataView} or one of
its subclasses.
###
class AP.view.DataViewItem extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-dataviewitem'
  
  ###*
  @inheritdoc
  ###
  initialize: ->
    super
    @listenTo(@record, 'savesuccess', @render) if @record
  
  ###*
  Adds `record` and `data-id` jQuery data to this view's `el`.  Useful for
  getting the record from a DOM event handler.
  ###
  render: ->
    super
    if @record
      @$el.data 'record', @record
      @$el.attr 'data-id', @record.get('id')
    @
