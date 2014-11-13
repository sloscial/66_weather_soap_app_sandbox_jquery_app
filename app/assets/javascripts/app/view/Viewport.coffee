null
###*
@class AP.Viewport
@extends AP.view.View
@singleton

The viewport is instantiated automatically with an internal `el` element
referring to the document `body`.  Viewport is used to manage pages and other
top-level views that must be inserted directly into the DOM body.
###
class AP.view.Viewport extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-viewport'
  
  ###*
  @property {AP.view.View}
  @private
  Currently active view instance, as only one page may be active in the viewport
  at a time.
  ###
  _currentItem: null
  
  ###*
  @property
  The viewport's element is always the document body.
  ###
  el: 'body'
  
  ###*
  No-op render method, as the viewport's element is always the document body.
  ###
  render: -> @
  
  ###*
  @inheritdoc
  
  Renders a view into viewport as specified in
  {@link AP.view.View#showItemByClass}, saving a reference to the resulting view
  for use by {@link #getCurrentItem}.
  ###
  showItemByClass: ->
    view = super
    @_currentItem = view
    view
  
  ###*
  @return {AP.view.View} the currently active view instance, if any
  ###
  getCurrentItem: -> @_currentItem
