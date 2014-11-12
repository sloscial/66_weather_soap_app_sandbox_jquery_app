null
###*
@class AP.controller.component.PageButton
@extends AP.controller.Controller

Handles interactions with page buttons.

See `AP.view.component.PageButton`.
###
class AP.controller.component.PageButton extends AP.controller.Controller
  ###*
  @inheritdoc
  ###
  events: [
    ['.ap-pagebutton', 'action', 'onAction']
  ]
  
  ###*
  If the component has a target page configured then the page is shown,
  if authorized.
  ###
  onAction: (e, view) ->
    app = AP.getActiveApp()
    data = view.getObjectData()
    pageClass = app.getView data.page if _.isString data.page
    if pageClass
      AP.getActiveApp().router.navigateToPage pageClass,
        record: view.getRecord()
        query: view.query
