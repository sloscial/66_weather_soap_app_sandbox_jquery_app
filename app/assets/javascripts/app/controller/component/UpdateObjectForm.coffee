null
###*
@class AP.controller.component.UpdateObjectForm
@extends AP.controller.Controller

Handles interactions with update forms.

See `AP.view.component.UpdateObjectForm`.
###
class AP.controller.component.UpdateObjectForm extends AP.controller.Controller
  ###*
  @inheritdoc
  ###
  events: [
    ['.ap-updateobjectformpage', 'savesuccess', 'onSaveSuccess']
    ['.ap-updateobjectformpage', 'savefailure', 'onSaveFailure']
    ['.ap-updateobjectformpage', 'validationfailure', 'onValidationFailure']
  ]
  
  onSaveSuccess: (e, view, record) ->
    @successAction view, record
    @successMessage view, record
    
  onSaveFailure: (e, view, record, response) ->
    @failureAction view, record
    @failureMessage view, record

  onValidationFailure: (e, view, record) ->
    page = AP.Viewport.add
      name: 'Dialog'
      pageTitle: 'Please Correct&hellip;'
      items: _.map record.errors(), (error) ->
        name: 'Content'
        className: 'ap-content ap-text-center'
        data: error
        "<strong>{{ field }}</strong>:  {{ message }}"
    page.show()
  
  ###*
  If the component has a success page configured and the success action is
  `Open Page`, then the page is shown and the successfully saved record
  is passed to it.  If the success action is `Back`, then the page previous to
  the form is shown.
  ###
  successAction: (view, record) ->
    app = AP.getActiveApp()
    data = view.getObjectData()
    pageClass = app.getView data.success_page if _.isString data.success_page
    if data.success_action == 'Open Page' and pageClass and AP.auth.Authorization.isAuthorized(pageClass::rules)
      AP.getActiveApp().router.navigateToPage pageClass,
        record: record
        query: record.toJSON()
    else if data.success_action == 'Back'
      view.parent.goBack()
  
  ###*
  If the component has a success message then it is displayed in a dialog.
  ###
  successMessage: (view, record) ->
    app = AP.getActiveApp()
    data = view.getObjectData()
    if data.success_message and (data.success_action != 'Open Page')
      page = AP.Viewport.add
        name: 'Dialog'
        pageTitle: 'Success'
        record: record
        items: [
          name: 'Content'
          className: 'ap-content ap-text-center'
          content: data.success_message
          record: record
        ]
      page.show()
  
  ###*
  Navigates to the page previous to the form if the failure action is `Back`.
  ###
  failureAction: (view, record) ->
    data = view.getObjectData()
    view.parent.goBack() if data.failure_action == 'Back'
  
  ###*
  If the component has a failure message then it is displayed in a dialog.
  ###
  failureMessage: (view, record) ->
    app = AP.getActiveApp()
    data = view.getObjectData()
    if data.failure_message
      page = AP.Viewport.add
        name: 'Dialog'
        pageTitle: 'Error'
        record: record
        items: [
          name: 'Content'
          className: 'ap-content ap-text-center'
          content: data.failure_message
        ]
      page.show()
