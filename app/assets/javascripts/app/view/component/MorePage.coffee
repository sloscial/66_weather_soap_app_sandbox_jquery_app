null
###*
@class AP.view.component.MorePage
@extends AP.view.Page

Shows a form for the specified model.
###
class AP.view.component.MorePage extends AP.view.Page
  id: 'morepage'
  name: 'MorePage'
  viewName: 'MorePage'
  className: 'ap-page ap-morepage'
  icon: 'ellipsis-h'
  title: 'More'
  pageTitle: 'More'
  collection: null
  
  initialize: ->
    super
    @showItemByClass 'AP.view.List',
      collection: @collection
      inset: false
      itemOptions:
        linked: true
        itemTitle: '<i class="fa fa-{{ icon }}"></i> {{ title }}'
