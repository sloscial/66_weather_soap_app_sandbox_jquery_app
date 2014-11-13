null
###*
@class AP.view.component.CarouselPage
@extends AP.view.Page

A page with a data view that shows `AP.view.component.CarouselItem` views in a
touch-enabled slideshow using data from a specified `datasource` collection.
###
class AP.view.component.CarouselPage extends AP.view.Page
  ###*
  @inheritdoc
  ###
  className: 'ap-page ap-carouselpage'
  
  ###*
  @property {Object}
  Optional hash of query parameters with which to query the data
  view's collection.
  ###
  query: null
  
  ###*
  Adds an `AP.view.component.Carousel` data view to the page.
  @inheritdoc
  ###
  initialize: ->
    super
    @showItemByClass 'AP.view.component.Carousel',
      query: @query
  
  ###*
  Renders a button into the header if a `title_bar_button` is specified on
  the component.
  ###
  initializeHeader: ->
    super
    app = AP.getActiveApp()
    data = @getObjectData()
    id = data.title_bar_button
    titleBarButtonClass = app.getView id
    if id and titleBarButtonClass
      @titleBarButton = new titleBarButtonClass
        parent: @
        right: true
      @appendHeader @titleBarButton.el
  
  ###*
  Maps the component's `title` property into `pageTitle` as expected by the
  `AP.view.Page` class.
  ###
  getObjectData: ->
    data = super
    data.pageTitle = data.title if data.title
    data
