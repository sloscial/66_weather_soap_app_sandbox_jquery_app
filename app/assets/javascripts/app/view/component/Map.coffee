null
###*
@class AP.view.component.Map
@extends AP.view.Map

Similar to `AP.view.Map`, but renders map markers from data in a specified
query scope.
###
class AP.view.component.Map extends AP.view.Map
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
  
  getCollectionClass: -> AP.getActiveApp().getCollection @getData?()?.datasource
  
  getItemClass: -> AP.view.component.MapItem
  
  getObjectData: ->
    data = super
    data.zoom = parseInt(data.zoom, 10) if data.zoom
    data.geolocate = data.use_current_location.toString() == 'true'
    data.showList = data.show_list.toString() == 'true'
    data
