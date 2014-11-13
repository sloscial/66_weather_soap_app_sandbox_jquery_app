class window.WeatherSoapAppSdk extends window.WeatherSoapAppSdk
  @setup: ->
    @rootViewName = @rootViewName or ''
    @views = {}
    @controllers = {}
    @routers = {}
  @init: ->
    'Initializes the application.  Call only once.'
    AP.baseUrl = 'https://vast-chamber-1788.herokuapp.com'
    super
    # instantiate viewport and root view
    AP.Viewport = new AP.view.Viewport()
    # instantiate main controller
    new AP.controller.component.Main
    # instantiate app router and start history listening
    @router = new @routers.MainRouter
    Backbone.history.start()
  @getRootViewClass: -> @getView @rootViewName
  @getView: (str) ->
    if str
      _.find(@views, (val, key) -> key == str or val::id?.toString() == str.toString()) or
      AP.getView(str)
