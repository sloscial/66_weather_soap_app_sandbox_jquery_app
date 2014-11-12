null
###*
@class AP.view.DataView
@extends AP.view.View

Data view is intended for the display of data from an
{@link AP.collection.Collection} collection instance.  Models in the collection
are displayed using a {@link AP.view.DataViewItem} view or one of
its subclasses.
###
class AP.view.DataView extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-dataview'
  
  ###*
  @property {String/AP.collection.Collection}
  Collection instance, class, or the name of a collection class in the
  active app.
  ###
  collection: null
  
  ###*
  @property {Object}
  Optional hash of query parameters with which to query `collection`.
  
  Note that if no `query` is set, newly initialized data views inherit queries
  from the first ancestor with a `query` attribute.  To initialize a data view
  strictly without one, set `query` to an empty object `{}`.
  ###
  query: null
  
  ###*
  @private
  @property {AP.collection.Collection}
  A reference to the first collection instance used by this data view.  Used by
  `revertCollection`, since the collection instance may be changed during the
  lifetime of the data view.
  ###
  defaultCollection: null
  
  ###*
  @private
  @property {Object}
  A reference to the first query used by this data view.  Used by
  `revertCollection`, since the collection instance may be changed during the
  lifetime of the data view.
  ###
  defaultQuery: null
  
  ###*
  @property {String}
  The template string passed as the `template` attribute to
  {@link AP.view.DataViewItem} instances or one of its subclasses.
  ###
  itemTpl: null
  
  ###*
  @property {Object}
  Optional options object passed to {@link AP.view.DataViewItem} or one of its
  subclasses for instantiation.
  ###
  itemOptions: null
  
  ###*
  @private
  @property {AP.view.View}
  Message view instance to display when `collection` contains no items.
  ###
  noDataMessage: null
  
  ###*
  @property {Boolean}
  Paginate this data view instance, showing only `perPage` instances at a time?
  ###
  paginate: false
  
  ###*
  @property {Number}
  Page of collection up to which to display.  By default, data view displays all
  items _up to_ and including those in `page`.
  ###
  currentPage: 1
  
  ###*
  @property {Number}
  Number of items per page.
  ###
  perPage: 0
  
  ###*
  @property {String}
  Query parameter name for `collection` limit.
  ###
  limitParam: 'limit'
  
  ###*
  @property {String}
  Optional template for this data view.  Override in subclasses as necessary.
  ###
  template: ''
  
  ###*
  Initializes this data view instance.
  @inheritdoc
  ###
  initialize: ->
    super
    
    @noDataMessage = new AP.view.Content(
      className: 'ap-content ap-no-data-message'
      content: 'No data available.'
      hidden: true
      parent: @)
    
    @appendExtra @noDataMessage.el
    
    @initializeCollection()
    
    # refresh collection on authentication change
    @listenTo AP.auth.Authentication, 'auth:authenticated', @fetch
    @listenTo AP.auth.Authentication, 'auth:deauthenticated', @removeAll
  
  ###*
  Instantiates `collection` if collection was specified as a class or name.
  ###
  initializeCollection: ->
    # instantiate a new collection if necessary
    if @collection
      @setCollection(@collection, @query, true)
    else
      @noDataMessage.show()
  
  ###*
  Used to append extra elements that are not proper children of the data view.
  For example, the no-data message is appended in this manner because it is not
  a data view item.
  @param {Element} el HTML element to be appended
  ###
  appendExtra: (el) -> @append el
  
  ###*
  Optionally override to prepare a collection programmatically.  Useful when
  specifying `collection` is insufficient.
  ###
  getCollection: -> null
  
  ###*
  Unsets the current query used by `collection`.
  ###
  clearQuery: -> @query = null
  
  ###*
  Sets the query to the specified key/value hash.
  @param {Object} query a key/value hash of query parameters
  ###
  setQuery: (query) -> @query = query
  
  ###*
  Sets `collection` and `query` to the specified values, removing any existing,
  if necessary.  Optionally pass `true` for `defaultSettings` to specify
  that the passed collection and query are default and should be used when
  calling `revertCollection`.
  @param {String/Backbone.Collection} collection collection class, class name or
  collection instance
  @param {Object} query optional key/value hash of query parameters
  @param {Boolean} defaultSettings if `true` then the specified collection and
  query are defaults and should be used when calling `revertCollection`
  ###
  setCollection: (collection, query, defaultSettings) ->
    # remove events from previous collection, if any
    @stopListening(@collection) if @collection
    # setup new collection
    collection = @getCollection(collection) or collection
    @collection = if !(!_.isFunction(collection) and collection instanceof AP.collection.Collection) and !(collection instanceof Backbone.Collection) then new collection() else collection
    @clearQuery()
    @setQuery(query) if query
    @currentPage = 1
    if @collection instanceof Backbone.Collection
      # refresh view on collection reset
      @listenTo @collection, 'sync', @onCollectionReset
      @listenTo @collection, 'deletesuccess', @onCollectionReset
      @removeAll()
      if !@collection.length
        @fetch()
      else
        @reset()
    if defaultSettings
      @defaultCollection = @collection
      @defaultQuery = @query
  
  ###*
  Returns options used to initialize new data view item instances.
  @param {AP.model.Model} record record instance for the data view item
  @return {Object} options for instantiating a data view item
  ###
  getItemOptions: (record) ->
    options =
      parent: @
      record: record
    options.template = @itemTpl if @itemTpl
    _.extend options, @itemOptions
  
  ###*
  Returns the data view item class.  Override to specify a different data
  view item class.
  @return {AP.view.DataViewItem} data view item class or one of its subclasses
  ###
  getItemClass: -> AP.view.DataViewItem
  
  ###*
  Instantiates a new data view item using the given record instance.
  @param {AP.model.Model} record record instance with which to instantiate the
  data view item
  @return {AP.view.DataViewItem} data view item instance
  ###
  getNewItem: (record) ->
    new (@getItemClass())(@getItemOptions(record))
  
  onCollectionReset: -> @reset()
  
  ###*
  Removes all data view items and instantiates and appends a new set using
  records from the current collection.  If the collection has no items, the
  no-data message is shown.
  ###
  reset: ->
    @removeAll()
    if @collection and @collection.length
      @noDataMessage.hide()
      @collection?.each (record) =>
        @add(@getNewItem record)
    else
      @noDataMessage.show()
    @trigger 'datareset'
    @collection.previousLength = @collection.length if @collection?.length
  
  ###*
  Sets `collection` and `query` to the defaults, if any.  Immediately fetches
  records.  See {@link #setCollection} for more information on defaults.
  ###
  revertCollection: ->
    @setCollection @defaultCollection, @defaultQuery
    @fetch()
  
  ###*
  Returns a key/value hash of pagination query parameters for the current page.
  By default the `limit` parameter is returned.  Override as necessary.
  @return {Object} key/value hash of pagination query parameters with which to
  pass to the server.
  ###
  getPaginationParams: ->
    params = {}
    params[@limitParam] = (@currentPage * @perPage) if @paginate and @perPage
    params
  
  ###*
  Fetches records from the server via the current collection instance, passing
  the pagination parameters.  If `query` is specified, the collection's `query`
  method is called with the query, instead of `fetch`.  Queries are inherited.
  See {@link #query} for more information.
  ###
  fetch: ->
    query = @getAttribute 'query'
    if !@isRemoved() and @isAuthorized()
      if query
        @collection.query query,
          data: @getPaginationParams()
      else
        @collection.fetch
          data: @getPaginationParams()
  
  ###*
  Removes all children from this data view.
  ###
  removeAll: -> @remove(item) for item in @items.slice()
