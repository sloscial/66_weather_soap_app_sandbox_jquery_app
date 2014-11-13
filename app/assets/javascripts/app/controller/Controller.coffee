null
###*
@class AP.controller.Controller

Base controller class.  Provides basic DOM event handling features.  Controllers
are intended to handle user interaction with views or other functionality not
already provided by views.

Controllers are intended for instantiation, but only once.  Each controller
class is instantiated by `AP.controller.component.Main` once and only once.
Therefore, controllers should be stateless and view-agnostic, meaning that a
controller instance must handle events for any view of appropriate type.  For
example, `AP.controller.component.List` handles item selection events on any
list at any time.

See example below:

    class AP.controller.component.List extends AP.controller.Controller
      events: [
        # selector, event name, controller method
        ['.ap-list', 'select', 'onItemSelect']
      ]

      onItemSelect: (e, view, record) ->
        # do something
###
class AP.controller.Controller
  # mixin Backbone events
  _.extend @::, Backbone.Events
  
  ###*
  @property {Array}
  Array of DOM event handler configurations.  For example:
  
      [
        ['.ap-list', 'select', 'onItemSelect']
      ]
  ###
  events: null
  
  constructor: -> @initialize.apply @, arguments
  
  ###*
  Called on instantiation of a controller instance.  The default initializer
  attaches DOM event handlers specified in 
  ###
  initialize: ->
    @events = @events or []
    @bindDomEvent(eventSet) for eventSet in @events

  ###*
  Binds delegated event specified in `eventSet`.  Event sets are 
  @param {Array} eventSet event configuration array of three strings in the
  format:  `['selector', 'event name', 'method name']`.
  ###
  bindDomEvent: (eventSet) ->
    $('body').delegate eventSet[0], eventSet[1], => @[eventSet[2]].apply(@, arguments)
