null
###*
@class AP.controller.component.Map
@extends AP.controller.Controller

Handles interactions with maps.

See `AP.view.component.Map` and `AP.view.component.MapPage`.
###
class AP.controller.component.Map extends AP.controller.Controller
  ###*
  @inheritdoc
  ###
  events: [
    ['.ap-map', 'select', 'onItemSelect']
    ['.ap-mappage', 'listaction', 'onListAction']
  ]
  
  ###*
  If the component has a target page configured then the page is shown and the
  record from the selected item is passed.  If no target page is configured,
  a simple dialog is displayed with item details.
  ###
  onItemSelect: (e, view, record) ->
    app = AP.getActiveApp()
    data = view.getObjectData()
    pageClass = app.getView data.page if _.isString data.page
    if pageClass and AP.auth.Authorization.isAuthorized(pageClass::rules)
      AP.getActiveApp().router.navigateToPage pageClass,
        record: record
        query: record.toJSON()
    else
      page = AP.Viewport.add
        name: 'Dialog'
        pageTitle: data.detail_title
        record: record
      if data.detail_description
        page.showItemByClass 'AP.view.Content',
          className: 'ap-content ap-text-center'
          content: data.detail_description
      page.show()
  
  ###*
  Shows a list page with many of the same settings as the component such that it
  displays map data in list form.
  ###
  onListAction: (e, view) ->
    mapView = view.getItemByClass('Map')
    data = mapView.getObjectData()
    listPage = new AP.view.component.ListPage
      backButton: true
      datasource: data.datasource
      page: data.page
      per_page: data.per_page
      allow_pagination: data.allow_pagination
      detail_title: data.detail_title
      detail_description: data.detail_description
      page: data.page
      record: view.record
      query: view.record?.toJSON()
    AP.Viewport.showItemByClass listPage
