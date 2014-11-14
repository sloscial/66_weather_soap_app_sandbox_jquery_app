null
###*
@class AP.view.component.ContentPage
@extends AP.view.Page

A simple empty page which may contain any view components.
###
class AP.view.component.ContentPage extends AP.view.Page
  ###*
  @inheritdoc
  ###
  className: 'ap-page ap-contentpage'
  
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
