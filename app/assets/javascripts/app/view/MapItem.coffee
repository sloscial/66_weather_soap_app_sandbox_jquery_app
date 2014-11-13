null
###*
@class AP.view.CarouselItem
@extends AP.view.DataViewItem

A data view item wrapper for Google Maps map markers.  Map items are virtual
views:  they are never appended to the DOM or displayed directly.  Instead, they
wrap Google Maps map marker instances which are displayed in a Google Map and
handle marker events.
###
class AP.view.MapItem extends AP.view.DataViewItem
  ###*
  @inheritdoc
  ###
  className: 'ap-dataviewitem ap-mapitem'
  
  ###*
  @property {Number}
  Geographic latitude of this map item.
  ###
  latitude: null
  
  ###*
  @property {Number}
  Geographic longitude of this map item.
  ###
  longitude: null
  
  ###*
  @property {google.maps.Marker}
  The Google Maps map marker instance for this map item.
  ###
  googleMarker: null
  
  ###*
  @inheritdoc
  ###
  initialize: ->
    super
    @on 'select', @onSelect, @
    @on 'remove', @onRemove, @
    @initializeMarker()
  
  ###*
  Instantiates a Google Maps map marker at the coordinates specified in
  `latitude` and `longitude`.  Attaches event handlers.
  ###
  initializeMarker: ->
    data = @getData()
    @googleMarker = new google.maps.Marker
      position: new google.maps.LatLng data.latitude, data.longitude
    google.maps.event.addListener(@googleMarker, 'mousedown', =>
      @trigger 'select')
  
  onSelect: -> @parent?.trigger 'markerselect', @, @record
