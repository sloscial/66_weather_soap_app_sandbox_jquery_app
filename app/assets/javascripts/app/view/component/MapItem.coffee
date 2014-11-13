null
###*
@class AP.view.component.MapItem
@extends AP.view.MapItem

An `AP.view.MapItem` which obtains `itemTitle`, `itemContent`, `latitude`, and
`longitude` from its record data.
###
class AP.view.component.MapItem extends AP.view.MapItem
  getObjectData: ->
    data = super
    data.itemTitle = data.detail_title if data.detail_title
    data.itemContent = data.detail_description if data.detail_description
    data
  
  getData: ->
    data = super
    data.latitude = data[data.latitude_field_definition]
    data.longitude = data[data.longitude_field_definition]
    data
