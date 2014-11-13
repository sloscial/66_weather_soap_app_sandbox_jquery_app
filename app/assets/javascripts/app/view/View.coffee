null
###*
@class AP.view.View
@extends Backbone.View

Base view class provides all of the standard methods and functionality in the
[BackboneJS View class](http://backbonejs.org/#View), as well as many additional
conveniences.  The base view may be subclassed or instantiated directly.
###
class AP.view.View extends Backbone.View
  ###*
  @property {String}
  Class or classes added to this view's DOM element.
  ###
  className: 'ap-view'
  
  ###*
  @property {String}
  An UnderscoreJS template string.  For example, `{{ variable }}`.  Learn more
  about [UnderscoreJS templates](http://underscorejs.org/#template).
  
  **Note**:  template syntax resembles Mustache and Django, differing from the
  default ERB-style template syntax used in UnderscoreJS.
  
  - `{{ interpolation }}`
  - `{%- escape %}`
  - `{% evaluate %}`
  ###
  template: null
  
  ###*
  @property {Array}
  An optional array of view instances, or the names of view classes, that are
  children of this view.
  ###
  items: null
  
  ###*
  @property {AP.view.View}
  A reference to the parent view instance that contains this view as an item.
  `parent` is automatically set on initialization and when adding or removing
  and item.
  ###
  parent: null
  
  ###*
  @property {AP.model.Model}
  An optional model instance containing data used to render this
  view's template.
  ###
  record: null
  
  ###*
  @property {Object}
  An optional hash of arbitrary data used to render this view's template.
  ###
  data: null
  
  ###*
  @property {Boolean/undefined} removed
  Is this view instance removed from the view hierarchy?  Should be undefined if
  view instance is not removed.
  ###
  
  ###*
  @property {Array}
  An optional array of authorization rules controlling this view's visibility.
  See {@link AP.auth.Authorization} for more information.
  ###
  rules: null
  
  ###*
  @property {Object}
  Object of event and selectors/event handler method names, in the [format
  required by BackboneJS](http://backbonejs.org/#View).
  ###
  events: {}
  
  ###*
  @private
  The newest version of underscore changes the meaning of "bindAll", so this is
  provided for compatibility.
  ###
  bindAll: (obj) ->
    funcs = Array::slice.call arguments, 1
    funcs = @functions if funcs.length == 0
    _.each funcs, (f) ->
      obj[f] = _.bind obj[f], obj
    obj
  
  ###*
  @private
  The newest version of underscore changes the meaning of "bindAll", so this is
  provided for compatibility.
  ###
  functions: ->
    names = []
    for key, value of @
      names.push key if _.isFunction value and !_.isObject value
    names.sort()
  
  ###*
  Binds DOM events, assigns any items passed through `options`, and renders
  the element.
  @param {Object} defaults optional configuration object
  @param {Object} defaults.events optional hash of events and event handler
  method names
  @param {Array} defaults.items optional array of view instances or view class
  names to initialize as children of this view
  @param {Array} defaults.rules optional array of authorization rules
  ###
  initialize: (@defaults={}) ->
    super
    @events =
      _.extend {},
        @constructor.__super__?.events,
        @constructor.__super__?.constructor?.__super__?.events,
        @events,
        @defaults.events
    @bindAll @
    (@[key] = value) for key, value of @defaults
    @items = @defaults.items or @items or []
    @rules = @defaults.rules or @rules or []
    @initializeItems()
    @render()
    @listenTo(@getRecord(), 'change', @render) if @getRecord()
    @listenTo AP.auth.Authentication, 'auth:authenticated', @doAuthVisibility
    @listenTo AP.auth.Authentication, 'auth:deauthenticated', @doAuthVisibility
  
  ###*
  Instantiates views that were passed as strings, since items may be view
  instances or fully-qualified names of view classes.  Called only once on
  initialization.
  ###
  initializeItems: ->
    newItems = []
    for item in @items
      instance = @initializeItem item
      newItems.push instance
    @items = newItems
  
  ###*
  Attemps to instantiate an item, if not already instantiated.  `item` may be
  a view class, a view name, or a view configuration object.
  @return {Object} instantiated view item
  ###
  initializeItem: (item, options) ->
    if _.isObject(item) and item instanceof AP.view.View
      # item is already instantiated, return as-is
      item.parent = @
      item
    else
      app = AP.getActiveApp()
      if _.isString(item) or _.isFunction(item)
        # item is a view name or a view class
        view = item
        options = _.extend {parent: @}, options
      else if _.isObject(item) and item.name? and !(item instanceof AP.view.View)
        # configuration object
        view = item.name
        options = _.extend {parent: @}, item, options
      new (app.getView(view)) options
  
  ###*
  @return {Object} an object with one item `user`, a hash of auth session data
  ###
  getAuthData: -> user: AP.auth.Authentication.getAuthSessionData() or {}
  
  ###*
  @return {Function} compiles the {@link #template} string and returns a
  template function
  ###
  getTemplate: -> _.template(@template or '') if @template
  
  ###*
  @return {Object} munged object data of all attributes of ancestor views,
  beginning with the parent backwards, and this view.  If this view or an
  ancestor contains a `record` attribute, this object is guaranteed to
  contain it.
  ###
  getObjectData: ->
    _.extend {}, @parent?.getObjectData(), @, {record: @getRecord()}
  
  ###*
  @return {Object} munged JSON object data of all attributes of ancestor views'
  `record` and this view's `record`.
  ###
  getRecordData: -> _.extend {}, @parent?.getRecordData(), @record?.toJSON()
  
  ###*
  @return {Object} the nearest view's `attr` attribute, if any, beginning with
  this view backwards via parent.
  ###
  getAttribute: (attr) -> @[attr] or @parent?.getAttribute(attr)
  
  ###*
  @return {Object} the nearest view's `record` attribute, if any, beginning with
  this view backwards via parent.
  ###
  getRecord: -> @getAttribute 'record'
  
  ###*
  @return {Object} munged object data used to render templates, in the following
  order of priority from highest to lowest:
  
  1. {@link #getRecordData}
  2. {@link #data}
  3. {@link #getAuthData}
  4. {@link #getObjectData}
  ###
  getData: -> _.extend {},
    @getObjectData(),
    @getAuthData(),
    @data,
    @getRecordData()
  
  ###*
  Renders the view into the `el` property.  View instances in the
  `items` property are appended to this view's element immediately following. If
  authorization rules are specified on this view, they are applied after
  rendering.
  ###
  render: ->
    @hide() if @hidden
    @$el.data 'view', @
    @$el.addClass(@extraClassName) if @extraClassName
    @$el.html(@toHtml())
    @append(item.el) for item in @items
    @doAuthVisibility()
    @$el.trigger('render')
    @
  
  ###*
  @return {String} rendered {@link #template} using data {@link #getData}
  ###
  toHtml: ->
    template = @getTemplate()
    if template and _.isFunction template
      template @getData()
    else if template
      template
    else
      ''
  
  ###*
  Renders an attribute of this view instance or its parents as a template.
  Useful when the view template must render an attribute which itself may be
  a template string.
  @param {String} attr an attribute name in {@link #getObjectData} to compile
  and render as a template, using data {@link #getData}.
  @return {String} a rendered template string
  ###
  renderAttr: (attr) ->
    #@loadRelatedData(attr)
    objectData = @getObjectData()
    allData = @getData()
    templateString = objectData[attr] || ''
    ###
    Parse the template string in the specified attribute `attr` for template tags
    that refer to relationships (generally any template tag containing a dot
    refers to a relationship:  e.g. `{{ user.name }}`).  If relationship tags are
    found, a temporary value is provided and the relationship is loaded.  Views
    must listen to a record's change event to be notified when the relationship
    is loaded.
    
    TODO:  there is probably a more efficient way of handling this... perhaps
    by precompiling templates for attributes?
    ###
    tags = _.compact(templateString.match(_.templateSettings.interpolate)) or []
    _.each tags, (tag) ->
      stripped = tag.replace /{{\s?|\s?}}/g, ''
      if stripped.indexOf('.') > 0
        relationshipName = _.first(stripped.split '.')
        if allData && relationshipName && !allData[relationshipName]
          allData.record?.fetchRelated relationshipName
          allData[relationshipName] = {}
    # return rendered template string
    _.template(templateString)(allData)
  
  ###*
  Shows view if it is not marked as hidden _and_ the current user is
  authorized to view it.  Hides view if it is marked as hidden _or_ the
  current user is _not authorized_ to view it.
  ###
  doAuthVisibility: ->
    if !@isRemoved()
      if !@hidden and @isAuthorized()
        @_show()
      else
        @_hide()
  
  ###*
  @return {Boolean} `true` if this view instance is authorized, based on
  its `rules`
  ###
  isAuthorized: -> AP.auth.Authorization.isAuthorized @rules
  
  ###*
  @private
  Shows the view's element.
  ###
  _show: -> @$el.show()
  
  ###*
  Shows the view's element (if authorized) and marks view as not hidden
  ###
  show: ->
    @hidden = false
    @_show()
    @doAuthVisibility()

  ###*
  @private
  Hides the view's element.
  ###
  _hide: -> @$el.hide()
  
  ###*
  Hides the view's element (if authorized) and marks view as hidden
  ###
  hide: ->
    @hidden = true
    @_hide()
  
  ###*
  Hides all child items.
  ###
  hideAll: -> item.hide() for item in @items
  
  ###*
  @private
  Appends an element to this view's element.
  @param {Element} el the element to append to this view's element
  ###
  append: (el) -> @$el.append el
  
  ###*
  Adds a view instance to the view's `items` and returns the added instance.
  @param {String/Object/AP.view.View} view a view name, a view configuration
  object, or a view instance to add to this view
  @return {AP.view.View/undefined} the added instance or `undefined` if the view
  was not added
  ###
  add: (view, options) ->
    if !_.contains @items, view
      view = @initializeItem view, options
      # add the view to this view's items
      @items.push view
      # add the view's element to this view's element
      @append view.el
      # add reference to parent
      # this is now performed in @initializeItem
      #view.parent = @
      # mark view as not removed
      delete view.removed
      # show or hide based on hidden status and authorization
      @doAuthVisibility()
      ###*
      @event itemAdd
      @param {AP.view.View} this the view to which the item was added
      @param {AP.view.View} view the added view
      ###
      @trigger 'itemAdd', @, view
      ###*
      @event add
      @param {AP.view.View} added the added view
      @param {AP.view.View} parent the parent of the added view
      ###
      view.trigger 'add', view, @
      view
  
  ###*
  Removes a view instance from the view's `items` and returns the instance.
  @param {AP.view.View} view a view instance to remove to this view
  @return {AP.view.View/undefined} the removed instance or `undefined` if the
  view was not removed
  ###
  remove: (view) ->
    if _.contains @items, view
      # remove the view from this view's items
      @items = _.without @items, view
      # remove the view's element from this view's element
      view.$el.remove()
      # remove reference to parent
      view.parent = null
      # mark view as removed
      view.removed = true
      ###*
      @event itemRemove
      @param {AP.view.View} this the view from which the item was removed
      @param {AP.view.View} view the removed view
      ###
      @trigger 'itemRemove', @, view
      ###*
      @event remove
      @param {AP.view.View} removed the removed view
      @param {AP.view.View} parent the parent of the removed view
      ###
      view.trigger 'remove', view, @
      view
  
  ###*
  @return {Boolean} `true` if this view instance or any ancestor is removed.
  ###
  isRemoved: ->
    data = @getObjectData()
    !!data.removed
  
  ###*
  Returns a view in `items that is an instance of `c` view class.
  @param {AP.view.View} c a view class or fully-qualified name of a view class
  @return {AP.view.View} an instance of a view class
  ###
  getItemByClass: (c) ->
    if _.isString c
      c = AP.getActiveApp().getView c
      c and _.find(@items, (item) -> (item instanceof c))
    else
      _.find @items, (item) ->
        (item == c) or (_.isFunction(c) and (item instanceof c))

  ###*
  Finds and shows an item in view of class `c`.  Instantiates a new view
  if no such item is found.  Useful when only one page of a type should be
  instantiated at a time or when a view class lookup is cumbersome.
  @param {AP.view.View} c a view class or fully-qualified name of a view class
  @param {Object} options optional configuration object passed if new instance
  is created
  @return {AP.view.View} an instance of the found or created view class
  ###
  showItemByClass: (c, options) ->
    view = if c instanceof AP.view.View then c else (@getItemByClass(c) or c)
    view = @add(view, options) or view
    view?.show()
    view
