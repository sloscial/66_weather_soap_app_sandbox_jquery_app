null
###*
@class AP.view.component.ListItem
@extends AP.view.ListItem

List item is a view for displaying a single record within a jQuery Mobile list.
###
class AP.view.component.ListItem extends AP.view.ListItem
  ###*
  Maps `detail_title` and `detail_description` to `itemTitle` and
  `itemContent`, respectively.  If the component has an `image_url_field_definition` and
  the item's record has a matching field name, it is used to display an image.
  ###
  getObjectData: ->
    data = super
    recordData = @getRecordData()
    data.imageUrl = recordData[data.image_url_field_definition] if data.image_url_field_definition
    data.itemTitle = data.detail_title if data.detail_title
    data.itemContent = "<div class=\"ui-li-desc\">#{data.detail_description}</div>" if data.detail_description
    data
