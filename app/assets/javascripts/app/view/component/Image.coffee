null
###*
@class AP.view.component.Image
@extends AP.view.Image

Displays an image assigned to this component or from a record field.
###
class AP.view.component.Image extends AP.view.Image
  ###*
  @inheritdoc
  ###
  url: null
  
  ###*
  @private
  @property {String}
  Base name of the component.  Used to create the URL of the image.
  ###
  baseName: null
  
  ###*
  @private
  @property {String}
  A field name on an associated record instance.  If record data is available
  with the specified field name then it is used as the image URL.
  ###
  image_url_field_definition: null
  
  ###*
  Maps the component's `baseName` property into `url` as expected by the
  `AP.view.Image` class.  If record data is available and the component has an
  `image_url_field_definition` field, the URL is obtained from the record.
  ###
  getObjectData: ->
    data = super
    recordData = @getRecordData()
    base_name = data.baseName
    extension = (data.url or '').split('.').reverse()[0]
    url = "#{base_name}.#{extension}"
    image_url = recordData[data.image_url_field_definition]
    data.url = if image_url then image_url else url
    data
