null
###*
@class AP.view.Map
@extends AP.view.DataView

A data view wrapper for Google Maps.  Requires the Google Map JavaScript API be
available on the current page.
###
class AP.view.Map extends AP.view.DataView
  ###*
  @inheritdoc
  ###
  className: 'ap-dataview ap-map'
  
  ###*
  @private
  @property {google.maps.LatLng}
  Internal reference to the current location of the device if the user opted to
  share this information.
  ###
  currentLocation: null
  
  ###*
  @property {Boolean}
  Center on the current location, if allowed by user?  If `false`, then the map
  will auto-center-and-zoom on all map points.
  ###
  geolocate: false
  
  ###*
  @property {Numebr}
  Default zoom level.
  ###
  zoom: 3
  
  ###*
  @property {google.maps.LatLng}
  Default map center, if `geolocate` is `false`.
  ###
  center: null
  
  ###*
  @property {google.maps.MapTypeId}
  Default map type.
  ###
  mapTypeId: null
  
  ###*
  @property {google.maps.Map}
  The Google Map instance.
  ###
  googleMap: null
  
  ###*
  @private
  @property {google.maps.LatLngBounds}
  Bounds of all current map points.
  ###
  googleMapBounds: null
  
  ###*
  @private
  @property {AP.view.View}
  Internal reference to a "load more" button view instance.
  ###
  moreButton: null
  
  ###*
  @property {String}
  Renders a simple map container element for the Google Map.
  ###
  template: '<div class="ap-map-container"></div>'
  
  ###*
  @inheritdoc
  ###
  events:
    'action .ap-more-button': 'onMoreAction'
  
  ###*
  Adds the "load more" button view instance via `appendExtra` and initializes
  the Google Map element.
  @inheritdoc
  ###
  initialize: ->
    @center = new google.maps.LatLng 39.8282, -98.5795 if google?
    @mapTypeId = google.maps.MapTypeId.ROADMAP if google?
    super
    @on 'datareset', @onDataReset, @
    @on 'markerselect', @onMarkerSelect, @
    @moreButton = new AP.view.Button
      className: 'ap-button ap-more-button'
      title: 'Load More&hellip;'
      hidden: true
      parent: @
    @appendExtra @moreButton.el
    if google?
      @initializeMap()
    else
      @initializeOfflinePlaceholder()
  
  ###*
  Initializes the Google map.
  ###
  initializeMap: ->
    data = @getObjectData()
    AP.defer 200, =>
      @googleMap = new google.maps.Map @$el.find('.ap-map-container')[0], @getMapOptions()
      @getCurrentLocation
        success: (location) =>
          @googleMap.setCenter(location) if data.geolocate
        complete: =>
          @trigger 'mapready'
  
  ###*
  Initializes the offline placeholder when `google` is undefined.
  ###
  initializeOfflinePlaceholder: ->
    @offlineMessage = new AP.view.Content(
      className: 'ap-content ap-no-data-message'
      content: '<br />Google Maps unavailable in offline mode.'
      parent: @)
    @appendExtra @offlineMessage.el
  
  ###*
  Initializes the collection when the map is ready.
  @inheritdoc
  ###
  initializeCollection: ->
    # wait for map ready and set the collection
    @on 'mapready', =>
      if @collection
        @setCollection(@collection, @query, true)
      else
        @noDataMessage.show()
  
  onDataReset: ->
    data = @getObjectData()
    if @collection?.length and @paginate and @perPage and (@collection.previousLength != @collection.length) and (@collection.length == (@perPage * @currentPage))
      @moreButton.show()
    if !data.geolocate and @collection?.length
      @googleMapBounds = new google.maps.LatLngBounds()
      _.each @items, (item) =>
        @googleMapBounds.extend item.googleMarker.position
      @googleMap.setCenter @googleMapBounds.getCenter()
      @googleMap.fitBounds @googleMapBounds
  
  onMarkerSelect: (view, record) -> @$el.trigger 'select', [@, record]
  
  onMoreAction: ->
    @currentPage++
    @fetch()
  
  ###*
  Returns an options hash with which to initialize the Google Map instance.
  @return {Object} options hash for Google Map
  ###
  getMapOptions: ->
    data = @getData()
    center: data.center
    zoom: data.zoom
    mapTypeId: data.mapTypeId
    disableDefaultUI: true
  
  ###*
  Requests current device location from user.
  @param {Function} options.success optional called when the current location is
  shared, passed a `google.maps.LatLng` instance
  @param {Function} options.failure optional called when the current location is
  not shared
  @param {Function} options.complete optional called immediately after success
  or failure callbacks are executed
  ###
  getCurrentLocation: (options={}) ->
    navigator.geolocation?.getCurrentPosition ((location) =>
      @currentLocation = new google.maps.LatLng(location.coords.latitude, location.coords.longitude)
      options?.success?(@currentLocation)
      options?.complete?()
    ), (=>
      options?.failure?()
      options?.complete?()
    )
  
  ###*
  Assumes that only `AP.view.MapItem` views are appended.  Gets the Google
  marker instance from the item view and sets the Google map to this view's
  map instance.
  @inheritdoc
  ###
  append: (el) ->
    # just assign map attribute (map items are not appended directly)
    # Google maps handles DOM
    mapItem = $(el).data 'view'
    mapItem.googleMarker.setMap @googleMap
  
  ###*
  @inheritdoc
  ###
  appendExtra: (el) -> @$el.append el
  
  ###*
  Returns the map item class.  Override to specify a different data
  view item class.
  @return {AP.view.MapItem} map item class or one of its subclasses
  ###
  getItemClass: -> AP.view.MapItem
  
  ###*
  @inheritdoc
  ###
  remove: (view) ->
    view?.googleMarker?.setMap?(null) if _.contains @items, view
    super
