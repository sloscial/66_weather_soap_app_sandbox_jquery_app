null
###*
@class AP.view.component.Carousel
@extends AP.view.Carousel

A data view that shows `AP.view.component.CarouselItem` views in a
touch-enabled slideshow using data from a specified `datasource` collection.
###
class AP.view.component.Carousel extends AP.view.Carousel
  ###*
  Initializes collection instance from the componnet's `datasource` data,
  if any.  Pagination options are setup on the collection if they were specified
  on the component.
  ###
  initializeCollection: ->
    data = @getObjectData()
    collectionClass = @getCollectionClass()
    if collectionClass
      @collection = new collectionClass
      @listenTo collectionClass::model, 'sync', @onModelClassSync
    @perPage = parseInt(data.per_page, 10) if data.per_page
    @paginate = (data.allow_pagination.toString() == 'true') if data.allow_pagination
    super
  
  ###*
  Refetches the view's collection whenever any model instance of the model class
  specified in the collection is synced.  Useful to ensure that model instances
  added elswhere in the app are reflected in this view.
  ###
  onModelClassSync: -> @fetch()
  
  ###*
  @return {AP.collection.Collection} collection class for the chart.
  ###
  getCollectionClass: -> AP.getActiveApp().getCollection @getData?()?.datasource
  
  ###*
  @return {AP.view.component.CarouselItem} carousel item component class is
  intended for instantiation within the carousel
  ###
  getItemClass: -> AP.view.component.CarouselItem
