null
###*
@class AP.view.component.QueryObjectFormPage
@extends AP.view.Page

Displays an unfilled model form for querying the specified query scope.
See `AP.controller.component.QueryObjectForm`.
###
class AP.view.component.QueryObjectFormPage extends AP.view.Page
  className: 'ap-page ap-queryobjectformpage'
  modelForm: null
    
  initialize: ->
    super
    data = @getObjectData()
    @modelForm = @showItemByClass 'AP.view.component.ModelForm',
      model: AP.getActiveApp().getModel data.object_definition
      submitButtonTitle: 'Search'
      saveRecord: (record) ->
        # skip the actual saving, if the process got this far, the record
        # is valid
        @trigger 'savesuccess', record
  
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
