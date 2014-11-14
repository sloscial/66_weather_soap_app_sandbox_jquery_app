null
###*
@class AP.view.component.ModelForm
@extends AP.view.ModelForm

Shows a form for the specified model.
###
class AP.view.component.ModelForm extends AP.view.ModelForm
  getFieldDefs: ->
    fieldDefs = super
    data = @getObjectData()
    if data.field_definition_maps?.length
      fieldDefMaps = _.sortBy(data.field_definition_maps, (field) -> field.position)
      fieldDefs = _.map fieldDefMaps, (field) =>
        _.extend {}, _.first(_.where(fieldDefs, {name: field.name})), field
    fieldDefs
