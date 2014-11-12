null
###*
@class AP.controller.component.TabbedNavigation
@extends AP.controller.Controller

Handles interactions with tabbed navigations.

See `AP.view.component.TabbedNavigation`.
###
class AP.controller.component.TabbedNavigation extends AP.controller.Controller
  ###*
  @inheritdoc
  ###
  events: [
    ['[data-role="navbar"] [data-view-class]', 'click', 'onTabClick']
    ['.ap-morepage', 'select', 'onMoreListItemSelect']
  ]
  
  ###*
  Shows the page referenced by the user-selected tab.
  ###
  onTabClick: (e) ->
    e.preventDefault()
    tabs = AP.Viewport.getItemByClass('AP.view.component.TabbedNavigation')
    viewClassName = $(e.currentTarget).attr('data-view-class')
    AP.getActiveApp().router.navigateToPage viewClassName
    $('.ui-footer .ui-navbar li a').removeClass 'ui-btn-active'
    $(".ui-footer .ui-navbar li a[data-view-class=\"#{viewClassName}\"]").addClass 'ui-btn-active'
    false
  
  ###*
  Shows a list page with additional pages that didn't fit in tabbed navigation.
  ###
  onMoreListItemSelect: (e, list, record) ->
    tabs = AP.Viewport.getItemByClass('AP.view.component.TabbedNavigation')
    viewClassName = record.get('name')
    AP.getActiveApp().router.navigateToPage viewClassName
