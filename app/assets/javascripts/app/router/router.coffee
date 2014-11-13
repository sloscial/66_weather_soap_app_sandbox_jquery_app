###*
@module AP
@submodule router
@class Router
@extends Backbone.Router
###
class AP.router.Router extends Backbone.Router
  ###*
  Returns a query string from an object.
  @method getQueryString
  @param {Object} queryObj key/value pairs to convert to query string
  @return {String} a query string in the form `key1=value1&key2=value2`
  ###
  getQueryString: (queryObj) ->
    queryItems = _.compact(("#{key}=#{encodeURIComponent value}" if value?) for key, value of queryObj)
    queryItems.join '&'
  
  ###*
  Returns an object from a query string.
  @method getQueryObject
  @param {String} queryString a query string in the form `key1=value1&key2=value2`
  @return {Object} key/value pairs converted from query string
  ###
  getQueryObject: (queryString) ->
    _.object(pair.split '=' for pair in queryString.split '&') if queryString?
  
  ###*
  Generates a URL for the given page.  Pages may be associated with specific
  records, which require a `modelName` and a `recordId`.  The model name and
  record ID are used to reconstitute a page from the URL alone.
  
  Supports an optional `query` object, such as for search results pages.
  
  @method getPageUrl
  @param {String} baseName base name of the page
  (only generated pages have this)
  @param {String} modelName optional model name of the record associated with
  the view
  @param {String} recordId optional record ID of record associated with the view
  @param {Object} queryObj key/value pairs used to query data in the view
  @return {String} a URL string in the
  form `baseName/modelName/recordId//key1=value1&key2=value2`
  ###
  getPageUrl: (baseName, modelName, recordId, query) ->
    url = _.compact([baseName, modelName, recordId]).join '/'
    queryString = @getQueryString query if query?
    url = "#{url}//#{queryString}" if queryString
    url
  
  ###*
  Sets the URL hash to the specified page (and optional record and/or query), if
  the page is authorized.  For non-generated pages (those with no URLs, such as
  dialogs), shows the page directly.  If the page is not authorized, redirects
  to the root route.
  @method navigateToPage
  @param {String/Object} page page name, page class, or page instance
  @param {Object} options used to instantiate the page
  ###
  navigateToPage: (page, options={}) ->
    options.query ?= page.query
    pageClass = AP.getActiveApp().getView(page.name or page)
    pageInstance = AP.Viewport.getItemByClass pageClass
    
    if pageClass
      baseName = pageClass.prototype?.baseName
      modelName = options.record?.constructor::name
      recordId = options.record?.id
      url = @getPageUrl baseName, modelName, recordId, options.query
      authorized = AP.auth.Authorization.isAuthorized pageClass.prototype?.rules
      if authorized
        if url
          trigger = !(options.record? or options.query?)
          @navigate url, trigger: trigger
        if !url or recordId? or options.query? or pageInstance?
          @showPage pageClass, options
    
    if !pageClass or !authorized
      @root()
  
  ###*
  Loads a record and upon success shows the specified page class, passing the
  loaded record.
  @method loadRecordAndShowPage
  @param {String} modelName the name of the record's model
  @param {String} recordId the Id of the record to load
  @param {Object} pageClass the page class to show
  @param {Object} options options to pass to page instantiation
  ###
  loadRecordAndShowPage: (modelName, recordId, pageClass, options) ->
    collectionName = "#{modelName}ExactMatch"
    collectionClass = AP.getActiveApp().getCollection collectionName
    collection = new collectionClass
    collection.fetch
      query: id: recordId
      success: ->
        options.record = collection.first()
        AP.Viewport.showItemByClass pageClass, options
  
  ###*
  Shows the specified page in the viewport if authorized.  If unauthorized,
  shows the root view.  If a record ID and model name are passed via options,
  show page delegates to `loadRecordAndShowPage`.
  @method showPage
  @param {String/Object} page page name, page class, or page instance
  @param {Object} options used to instantiate the page
  ###
  showPage: (page, options={}) ->
    options.query = @getQueryObject(options.query_string) or options.query
    pageClass = AP.getActiveApp().getView(page.name or page)
    pageData = pageClass.prototype or {}
    pageInstance = AP.Viewport.getItemByClass pageClass
    modelName = pageData.model_name or options.model_name
    recordId = options.record_id
    ancestorPage = pageData.nearest_page_ancestor_name
    ancestorPageClass = AP.getActiveApp().getView ancestorPage
    currentPage = AP.Viewport.getCurrentItem()
    rootClass = AP.getActiveApp().getRootViewClass()
    authorized = AP.auth.Authorization.isAuthorized pageData.rules
    isRoot = pageClass == rootClass
    isTabs = pageClass.isTabbedNavigation
    isTabsChild = ancestorPageClass?.isTabbedNavigation
    
    # add back button or previous page if needed
    if !isRoot and !isTabsChild
      options.backButton = true if pageData.nearest_page_ancestor_name
      options.previousPage = options.previousPage or
        pageInstance?.previousPage or
        currentPage or
        rootClass
    
    # remove existing page if there's a record attached
    if pageInstance?.record or pageInstance?.query
      AP.Viewport.remove pageInstance
    
    if authorized
      if pageData.name == 'MorePage'
        tabs = AP.Viewport.showItemByClass rootClass
        tabs.showItemByClass pageData.viewName, options
      else if isTabs or isTabsChild
        tabsClass = if isTabs then pageClass else ancestorPageClass
        tabs = AP.Viewport.getItemByClass tabsClass
        if !tabs
          tabs = AP.Viewport.showItemByClass tabsClass
        if !isTabs
          tabs.showItemByClass pageData.viewName, options
        else
          tabs.showFirst()
      else if modelName and recordId? and !options.record?
        @loadRecordAndShowPage modelName, recordId, pageClass, options
      else
        AP.Viewport.showItemByClass pageClass, options
    
    if !authorized
      @root()
