null
###*
@class AP
@singleton
Provides the global namespace for SDK framework classes.  Provides convenience
methods for app management.
###
class AP extends window.AP
  ###*
  @static
  @property {Object} view
  Namespace for view classes.
  ###
  @view:
    component: {}
  
  ###*
  @static
  @property {Object} controller
  Namespace for controller classes.
  ###
  @controller:
    component: {}
  
  ###*
  @static
  @property {Object} router
  Namespace for router classes.
  ###
  @router:
    component: {}
  
  ###*
  @static
  Returns a view class by name within this application and within the default
  AP views.
  @param {String} str the name of a view class
  @return {AP.view.View} a view class
  ###
  @getView: (str) ->
    if str
      _.find(AP.view.component, (val, key) -> key == str) or
      _.find(AP.view, (val, key) -> key == str) or
       AP.getClass(str)
  
  ###*
  @static
  Returns a value identified by a fully-qualified string name.  Uses
  `eval` internally.
  @param {String} qName the fully-qualified name of an object or class object
  @return an object or class object
  ###
  @getClass: (qName) ->
    try
      eval qName
    catch e
      # pass
  
  ###*
  Defers execution of a function for a number of milliseconds.
  @param {Number} ms milliseconds to wait
  @param {Function} fn function to execute
  @param {Object} scope optional scope with which to execute function
  ###
  @defer: (ms, fn, scope) -> setTimeout (=> fn.apply scope), ms
  
  ###*
  Returns a formatted date from a date string.
  @param {String} dateString a date string
  @return {String} formatted date string
  ###
  @formatDate: (dateString) -> new Date(dateString).toString 'MMMM d, yyyy'
  
  ###*
  Returns a formatted time from a date string.
  @param {String} dateString a date string
  @return {String} formatted time string
  ###
  @formatTime: (dateString) ->
    match = dateString?.match(/T(\d{2}):(\d{2})/)
    if match?[1]? and match?[2]?
      hour = parseInt(match[1], 10)
      suffix = 'am'
      if hour > 12
        hour = hour - 12
        suffix = 'pm'
      "#{hour}:#{match[2]}#{suffix}"
    else
      ''
  
  ###*
  Returns a formatted date/time from a date string.
  @param {String} dateString a date string
  @return {String} formatted date/time string
  ###
  @formatDateTime: (dateString) -> "#{@formatDate dateString} at #{@formatTime dateString}"


window.AP = AP
