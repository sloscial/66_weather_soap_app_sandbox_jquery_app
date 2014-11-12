null
###*
@class AP.view.ModelForm
@extends AP.view.Form

A form view for a model class.  Model forms automatically build fields for field
definitions on the specified model class.  Optional `formFields` may be
specified to limit the fields showing, to specify order, and to override
field options.

By default, model forms `save` a record instance.  This functionality may be
overridden via the `saveForm` method.

For example, to instantiate a model form that saves new instances:

    new AP.view.ModelForm
      model: MyModel
      formFields:
        fullName:
          label: 'Full Name'
          required: true
        email:
          label: 'Email'
          type: 'email'
          required: true

To instantiate a model form that updates an existing instance:

    new AP.view.ModelForm
      record: myModelInstance
###
class AP.view.ModelForm extends AP.view.Form
  ###*
  @inheritdoc
  ###
  className: 'ap-form ap-modelform'
  
  ###*
  @property {AP.collection.Collection}
  Optional collection into which to insert the record.
  ###
  collection: null
  
  ###*
  @property {AP.model.Model}
  Model class from which to build form fields.  If a `record` attribute is
  set on a model form, `model` may be omitted.
  ###
  model: null
  
  ###*
  @property {Object}
  Optional options object specifying form field options.  If passed, only the
  fields specified will be shown.  For example:
  
      fullName:
        label: 'Full Name'
        required: true
      email:
        label: 'Email'
        type: 'email'
        required: true
      phone: {} // don't override, just include the field and its defaults
  ###
  #formFields: null
  
  ###*
  @property {Boolean}
  Render a field for `ID`?
  ###
  showIdField: false
  
  ###*
  @property {String}
  Text for the submit button.
  ###
  submitButtonTitle: 'Submit'
  
  ###*
  @property {AP.view.Button}
  
  ###
  submitButton: null
  
  ###*
  @property {Boolean}
  Clear all attributes in record prior to saving?
  ###
  clearRecordBeforeSave: false
  
  ###*
  @property {Object}
  Map of model field definition types to HTML field types.
  ###
  fieldTypes:
    boolean: 'checkbox'
    integer: 'number'
    float: 'number'
    string: 'text'
    date: 'date'
    time: 'datetime'
    password: 'password'
  
  ###*
  @inheritdoc
  ###
  events:
    'action .ap-submit-button': 'onSubmitButtonAction'
  
  initialize: (options = {}) ->
    super
    @addFormFields()
    @addSubmitButton()
    @on 'savesuccess', @onSaveSuccess, @
    @on 'savefailure', @onSaveFailure, @
    @on 'validationfailure', @onValidationFailure, @
  
  ###*
  Returns the model class associated with this form.
  @return {AP.model.Model} model class
  ###
  getModel: ->
    model = @model or @record?.collection?.model
  
  ###*
  Builds an array of field definitions for the model class.  Field definitions
  are overriden by the optional `formFields` property.
  @return {Array} model class field definitions
  ###
  getFieldDefs: ->
    model = @getModel()
    formFields = @formFields or @getObjectData?().formFields
    if !formFields
      fieldDefs = model::fieldDefinitions if model
    else
      fieldDefs = []
      for name, config of formFields
        field = _.extend {}, _.where(model::fieldDefinitions, {name: name})?[0], config
        fieldDefs.push field
    fieldDefs
  
  ###*
  Adds a submit button to the form if `allowSave` is `true`.
  ###
  addSubmitButton: ->
    if @allowSave
      @submitButton = new AP.view.Button
        className: 'ap-button ap-submit-button'
        title: @submitButtonTitle
        theme: 'b'
        preventDefaultClickAction: false
        template: '''
          <button type="submit" data-role="button" {% if (theme) { %}data-theme="{{ theme }}"{% } %}>
            {{ renderAttr('title') }}
          </button>
        '''
      @add(new AP.view.View
        className: 'form-actions'
        items: [@submitButton])
  
  ###*
  Instantiates `AP.view.Field` form fields for field definitions and adds them
  to this form.
  ###
  addFormFields: ->
    fieldDefs = @getFieldDefs()
    model = @getModel()
    nonAutoKeyFields = model::nonAutoKeyFields if model
    idAttribute = model::idAttribute if model
    hasNonAutoKeyField = _.contains nonAutoKeyFields, idAttribute
    if fieldDefs
      fields = for field in fieldDefs
        if (hasNonAutoKeyField and (field.name == idAttribute)) or !((field.name == idAttribute) and !@showIdField)
          fieldType = @fieldTypes[field.type]
          fieldOptions =
            type: fieldType
            label: field.label + (if field.required then '*' else '')
            name: field.name
            value: @record?.get field.name
            required: field.required
            checked: @record?.get(field.name) if field.type == 'boolean'
            step: 0.0000001 if field.type == 'float'
            min: -100000000 if field.type == 'float' or field.type == 'integer'
            inputAttributes: field.inputAttributes
            span: field.span
            prepend: field.prepend
            append: field.append
            disabled: field.disabled
            help: field.help
          if field.file_url
            fieldOptions.type = 'file'
            fieldOptions.imageThumbnail = field.file_url and (field.file_type == 'Image')
          @add(new AP.view.Field fieldOptions)
  
  ###*
  Casts a hash of values to the proper types.  Since `getValues` returns string
  types for most fields, this step is required before setting values on
  a record.
  @param {Object} values names/values matching fields in field definitions, the
  values of which should be cast to field-definition-specified types
  @return {Object} name/values hash with properly type-cast values
  ###
  castValues: (values) ->
    castValues = {}
    fieldDefs = @getFieldDefs()
    for key, value of values
      type = _.where(fieldDefs, {name: key})[0]?.type
      # cast values by type
      # except for the case of NaN values, which validate as true for
      # float and integer fields (but probably shouldn't)
      castValues[key] = null
      if value?
        switch type
          when 'float'
            castValues[key] = parseFloat value.toString()
            castValues[key] = value.toString() if _.isNaN castValues[key]
          when 'integer'
            castValues[key] = parseInt value.toString(), 10
            castValues[key] = value.toString() if _.isNaN castValues[key]
          when 'string' then castValues[key] = value.toString()
          when 'boolean'
            if not _.isBoolean castValues[key]
              castValues[key] = (value.toString() == 'on' or value.toString() == 'true')
          else castValues[key] = value
    castValues
  
  ###*
  Sets the values in a record to the type-cast values from the model form.
  @param {AP.model.Model} record a model instance
  ###
  setValues: (record) ->
    values = @getValues()
    castValues = @castValues values
    if record
      record.clear() if @clearRecordBeforeSave
      record.set(castValues, silent: true)
  
  ###*
  Reads in files for each file-type input into the proper record field.
  @param {AP.model.Model} record a model instance
  @param {Function} callback called after all files are read or called when no
  file fields are present
  ###
  readFiles: (record, callback) ->
    count = $('[type=file]', @el).toArray().length
    index = 0
    if count
      for el in $('[type=file]', @el).toArray()
        fieldName = $(el).attr 'name'
        @readFile el, (result) =>
          if result
            record.set fieldName, result
          index++
          if index == count
            callback.apply @
    else
      callback.apply @
  
  
  ###*
  Reads in a file field as a data URL and passes the value to an
  `onload` callback.
  @param {Element} fileEl a file-type input field
  @param {Function} onload function to call with data URL value; function is
  called with `null` if the file cannot be read
  ###
  readFile: (fileEl, onload) ->
    if fileEl.files?[0]
      fieldName = $(fileEl).attr 'name'
      reader = new FileReader
      reader.onload = (e) => onload e.target.result
      reader.readAsDataURL fileEl.files?[0]
    else
      # if there is no file selected, return a null result
      onload null
  
  onSubmitButtonAction: -> @$el.submit()
  
  ###*
  @return {AP.model.Model} the model form's `record` instance or a new instance
  of the form's specified `model` class
  ###
  getRecord: ->
    record = @record
    record = (new @model()) if !record and @model
    record
  
  onSaveSuccess: (record) ->
    @$el.trigger 'savesuccess', [@, record]
    record.trigger 'savesuccess'
    @collection?.trigger 'sync'
  
  onSaveFailure: (record, response) ->
    @$el.trigger 'savefailure', [@, record, response]
  
  onValidationFailure: (record) ->
    @$el.trigger 'validationfailure', [@, record]
  
  ###*
  Reads in all file fields (if any) and saves the record.
  @param {AP.model.Model} record a model instance
  ###
  saveRecord: (record) ->
    @submitButton.disable()
    options =
      success: =>
        @trigger 'savesuccess', record
        @submitButton.enable()
      error: (record, response) =>
        @trigger 'savefailure', record, response
        @submitButton.enable()
    @readFiles record, ->
      if @collection and record?.isNew()
        @collection.create record, options
      else
        record.save null, options
  
  ###*
  Saves the record, if valid.  If record validation fails, the previous record
  attributes are restored.
  ###
  saveForm: ->
    record = @getRecord()
    if @setValues(record)
      if record.isValid()
        @saveRecord record
      else
        @trigger 'validationfailure', record
        record.set(record.previousAttributes, silent: true)
    else
      @trigger 'savefailure', record
