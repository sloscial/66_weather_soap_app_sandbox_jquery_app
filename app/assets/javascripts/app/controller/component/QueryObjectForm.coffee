null
###*
@class AP.controller.component.QueryObjectForm
@extends AP.controller.Controller

Handles interactions with search forms.

See `AP.view.component.QueryObjectForm`.
###
class AP.controller.component.QueryObjectForm extends AP.controller.Controller
  ###*
  @inheritdoc
  ###
  events: [
    ['.ap-queryobjectformpage', 'savesuccess', 'onSaveSuccess']
  ]
  
  ###*
  If the component has a target page configured then the page is shown and the
  form data is passed as both record and query.
  ###
  onSaveSuccess: (e, view, record) ->
    app = AP.getActiveApp()
    data = view.getObjectData()
    pageClass = app.getView data.page if _.isString data.page
    if pageClass
      AP.getActiveApp().router.navigateToPage  pageClass,
        record: record
        query: record.toJSON()
