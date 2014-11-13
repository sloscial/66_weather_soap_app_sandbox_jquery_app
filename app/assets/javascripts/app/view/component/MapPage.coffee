null
###*
@class AP.view.component.MapPage
@extends AP.view.Page

Shows a map on a page with markers from a specified query scope.
###
class AP.view.component.MapPage extends AP.view.Page
  className: 'ap-page ap-mappage'
  query: null
  events:
    'action .ap-list-button': 'onListAction'
  
  initialize: ->
    super
    @map = @showItemByClass 'AP.view.component.Map',
      query: @query
      zoom: @zoom
      use_current_location: @use_current_location
      show_list: @show_list
  
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
    if data.showList
      @listButton = new AP.view.Button
        className: 'ap-button ap-list-button'
        parent: @
        right: true
        title: 'List'
      @appendHeader @listButton.el
  
  onListAction: ->
    @$el.trigger 'listaction', @
  
  ###*
  Maps the component's `title` property into `pageTitle` as expected by the
  `AP.view.Page` class.
  ###
  getObjectData: ->
    data = super
    data.pageTitle = data.title if data.title
    data
