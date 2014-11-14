null
###*
@class AP.controller.component.Carousel
@extends AP.controller.Controller

Handles interactions with carousels.

See `AP.view.component.Carousel` and `AP.view.component.CarouselPage`.
###
class AP.controller.component.Carousel extends AP.controller.Controller
  ###*
  @inheritdoc
  ###
  events: [
    ['.ap-carousel', 'select', 'onItemSelect']
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
