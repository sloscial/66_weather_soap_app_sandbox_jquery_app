null
###*
@class AP.view.component.ListPage
@extends AP.view.Page

Shows a list of records on a page from a specified query scope.
###
class AP.view.component.ListPage extends AP.view.Page
  className: 'ap-page ap-listpage'
  query: null
  
  initialize: ->
    super
    @showItemByClass 'AP.view.component.List',
      inset: false
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
