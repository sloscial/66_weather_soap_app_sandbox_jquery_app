null
###*
@class AP.view.Image
@extends AP.view.View

Renders an `img` HTML tag.
###
class AP.view.Image extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-image'
  
  ###*
  @inheritdoc
  ###
  template: '<img src="{%- renderAttr("url") %}">'
  
  ###*
  @property {String}
  URL for this image.  `url` is treated as a template string and may contain
  template tags.
  ###
  url: null
