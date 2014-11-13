null
###*
@class AP.view.Form
@extends AP.view.View

A generic HTML form.  Interested listeners should listen on the `save` event,
rather than `click` or `submit` events.
###
class AP.view.Form extends AP.view.View
  ###*
  @inheritdoc
  ###
  className: 'ap-form'
  
  ###*
  @inheritdoc
  ###
  tagName: 'form'
  
  ###*
  @property {Boolean}
  If `true`, the `saveForm` method will be called automatically whenver the
  `save` event is triggered.
  ###
  allowSave: true
  
  ###*
  @inheritdoc
  ###
  events:
    submit: 'onSubmit'
    save: 'onSave'
  
  onSubmit: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @fireSave()
  
  fireSave: _.debounce((->
    ###*
    @event 'save'
    Triggered whenever the form is submitted successfully.
    ###
    @$el.trigger 'save', @), 750, true)
  
  onSave: -> @saveForm() if @allowSave
  
  ###*
  Executes the form's native submit method.  By default, the submit event is
  captured, cancelled, and a `save` event is triggered instead.
  ###
  submit: -> @$el.submit()
  
  ###*
  Default no-op save operation.  Override to handle form-specific save features.
  ###
  saveForm: ->
    # pass
  
  ###*
  Gets the values from all form fields.
  @return {Object} a hash of name/value pairs representing form fields
  ###
  getValues: ->
    values = {}
    for item in @$el.serializeArray()
      if $.isArray values[item.name]
        # if value is already an array, push into it
        values[item.name].push item.value
      else if values[item.name]
        # if value already exists, make it an array and add this item
        values[item.name] = [values[item.name], item.value]
      else
        # just set the value
        values[item.name] = item.value
    # Iterate over checkboxes because `$.fn.serializeArray` doesn't return
    # values for unchecked checkboxes, resulting in null values when the
    # expected value is `false`.
    @$el.find('[type="checkbox"]').each (i, el) =>
      name = el.name
      value = $(el).is(':checked')
      values[name] = value
      true
    values
