null
###*
@class AP.view.component.CarouselItem
@extends AP.view.CarouselItem

Carousel item is a view for displaying a single record within
a `AP.view.component.Carousel`.
###
class AP.view.component.CarouselItem extends AP.view.CarouselItem
  ###*
  Sets `itemTitle` and `itemContent` to the values of the component properties
  `detail_title` and `detail_description`, respectively, since
  `AP.view.Carousel` expects the former.
  @inheritdoc
  ###
  getObjectData: ->
    data = super
    data.itemTitle = data.detail_title if data.detail_title
    data.itemContent = data.detail_description if data.detail_description
    data
  
  ###*
  Retrieves the image URL, as specified in `image_url_field_definition`, and sets it on
  the `imageUrl` property as expected by `AP.view.CarouselItem`.
  @inheritdoc
  ###
  getData: ->
    data = super
    data.imageUrl = data[data.image_url_field_definition] if data.image_url_field_definition
    data
