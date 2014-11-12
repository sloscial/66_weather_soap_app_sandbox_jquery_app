null
###*
@class AP.view.Button
@extends AP.view.View

A jQuery Mobile button element.  By default, buttons ignore the URL and simply
fire an `action` event.  Buttons may follow a URL like a conventional link by
setting `preventDefaultClickAction` to `false`.
###
class AP.view.Button extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-button'
  
  ###*
  @property {String}
  The button text.
  ###
  title: ''
  
  ###*
  @property {String}
  An optional URL for this button.  Useful when `preventDefaultClickAction`
  is `false`.
  ###
  url: '#'
  
  ###*
  @property {String}
  An optional HTML target attribute for this button.  Useful when
  `preventDefaultClickAction` is `false` and a `url` is specified.
  ###
  target: null
  
  ###*
  @property {String}
  The jQuery Mobile theme identified for this button.  For example, `a` or `b`.
  ###
  theme: null
  
  ###*
  @property {boolean}
  Should button float to the right?
  ###
  right: false
  
  ###*
  @property {Boolean}
  Set to `true` if the button should render in a disabled state.  To disable
  the button immediately, call `disable`.
  ###
  disabled: false
  
  ###*
  @property {boolean}
  Follow the link specified in `url`?
  ###
  preventDefaultClickAction: true
  
  ###*
  @property {String}
  Template string for a standard jQuery Mobile button.
  ###
  template: '''
    <a href="{%- renderAttr('url') %}" {% if (target) { %}target="{{ target }}"{% } %} data-role="button" {% if (theme) { %}data-theme="{{ theme }}"{% } %}>
      {{ renderAttr('title') }}
    </a>
  '''
  
  ###*
  @inheritdoc
  ###
  events:
    click: 'onClick'
  
  onClick: (e) ->
    e.preventDefault() if @preventDefaultClickAction or @disabled
    @fireAction()
  
  fireAction: _.debounce (-> @$el.trigger('action', @) if !@disabled), 300, true
  
  ###*
  Initializes this button instance.
  ###
  initialize: ->
    super
  
  render: ->
    super
    @$el.addClass 'ui-btn-right' if @right
    @disable() if @disabled
  
  disable: ->
    @disabled = true
    @$el.addClass 'btn-disable'
  
  enable: ->
    @disabled = false
    @$el.removeClass 'btn-disable'
