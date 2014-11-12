null
###*
@class AP.view.component.List
@extends AP.view.List

A data view that shows `AP.view.ListItem` views in a jQuery Mobile list.
###
class AP.view.component.List extends AP.view.List
  initializeCollection: ->
    data = @getObjectData()
    collectionClass = @getCollectionClass()
    if collectionClass
      @collection = new collectionClass
      @listenTo collectionClass::model, 'sync', @onModelClassSync
    @perPage = parseInt(data.per_page, 10) if data.per_page
    @paginate = (data.allow_pagination.toString() == 'true') if data.allow_pagination
    super
  
  onModelClassSync: -> @fetch()
  
  ###*
  @return {Object} query scope instance specified in the designer
  ###
  getCollectionClass: -> AP.getActiveApp().getCollection @getData?()?.datasource
  
  ###*
  Enables tappable list items if a target page is specified.
  ###
  getItemOptions: ->
    options = super
    options.linked = !!@getData().page
    options
  
  ###*
  Returns the list item view class specified in the designer.  If a custom list
  item is not specified the default is used.
  @return {AP.view.component.ListItem} list item class or one of its subclasses
  ###
  getNewItem: (record) ->
    app = AP.getActiveApp()
    data = @getData()
    listItemName = data.list_item
    listItemClass = app.getView listItemName
    listItemClass = if _.isObject(listItemClass) then listItemClass else app.getView('AP.view.component.ListItem')
    new listItemClass @getItemOptions(record)
