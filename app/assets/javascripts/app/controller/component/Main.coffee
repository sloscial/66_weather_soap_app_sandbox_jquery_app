null
###*
@class AP.controller.component.Main
@extends AP.controller.Controller

The main controller is instantiated by an app at page load time.  It is
responsible for instantiating an instance of each available controller and for
configuring external libraries.
###
class AP.controller.component.Main extends AP.controller.Controller
  initialize: ->
    super
    @initializeSettings()
    @initializeControllers()
  
  ###*
  Configures UnderscoreJS templating to use `{{` django-style template tags.
  Configures jQuery Mobile with no page transition.
  ###
  initializeSettings: ->
    # enable mustache/django-style template tags
    _.templateSettings =
      _.extend {}, _.templateSettings,
        escape: /\{%-([\s\S]+?)%\}/g
        evaluate: /\{%([\s\S]+?)%\}/g
        interpolate: /\{\{(.+?)\}\}/g
    # Offline.js settings
    Offline?.options =
      checks:
        active: 'xhr'
        xhr:
          url: 'https://www.googleapis.com/'
      # check the connection status immediatly on page load?
      checkOnLoad: true
      # monitor AJAX requests to determine if there is a connection?
      interceptRequests: false
      # store and attempt to remake requests which fail while the connection is down?
      requests: false
  
  ###*
  Instantiates one instance of each available controller.
  ###
  initializeControllers: ->
    new AP.controller.Authentication
    new AP.controller.component.Authentication
    new AP.controller.component.Carousel
    new AP.controller.component.CreateObjectForm
    new AP.controller.component.List
    new AP.controller.component.Map
    new AP.controller.component.PageButton
    new AP.controller.component.QueryObjectForm
    new AP.controller.component.TabbedNavigation
    new AP.controller.component.UpdateObjectForm
