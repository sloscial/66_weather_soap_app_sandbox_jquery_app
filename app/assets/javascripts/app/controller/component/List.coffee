null
###*
@class AP.controller.component.List
@extends AP.controller.Controller

Handles interactions with lists.

See `AP.view.component.List` and `AP.view.component.ListPage`.
###
class AP.controller.component.List extends AP.controller.Controller
  ###*
  @inheritdoc
  ###
  events: [
    ['.ap-list', 'select', 'onItemSelect']
  ]
  
  ###*
  If the component has a target page configured then the page is shown and the
  record from the selected item is passed.
  ###
  onItemSelect: (e, view, record) ->
    app = AP.getActiveApp()
    data = view.getObjectData()
    pageClass = app.getView data.page if _.isString data.page
    if pageClass
      AP.getActiveApp().router.navigateToPage pageClass,
        record: record
        query: record.toJSON()
