null
###*
@class AP.view.component.TabbedNavigation
@extends AP.view.View

Adds tabbed footer navigation for all pages that are children of this view.  If
the number of chidlren exceeds 5, a "more" tab is added that displays a list of
additional pages.

Tabbed navigation is a virtual view:  it modifes the footer of its child pages
and is never displayed directly.  Simple add pages to the tabbed navigation view
and then display the desired child page.
###
class AP.view.component.TabbedNavigation extends AP.view.View
  @isTabbedNavigation: true
  
  className: 'ap-tabbednavigation'
  collection: null
  
  initialize: ->
    super
    #AP.defer 250, =>
    @showFirst()
    @initializeMoreItems()
  
  # create a collection of items for more page, if necessary
  initializeMoreItems: ->
    app = AP.getActiveApp()
    moreItems = @getMoreItems()
    if moreItems
      class MoreItems extends Backbone.Collection
        fetch: -> @trigger 'sync'
      @collection = new MoreItems _.map moreItems, (item) =>
        data = app.getView(item)::
        {
          name: data.name
          title: data.title
          icon: data.icon
        }
  
  # save list of initial items, but don't initialize them as usual
  initializeItems: ->
    @initialItems = @items
    @items = []
  
  showFirst: ->
    @showItemByClass @getNavItems()?[0]
  
  # override footer of children with navigation
  # delegate to Viewport.showItemByClass, since only viewport may
  # show pages
  showItemByClass: (c, options) ->
    app = AP.getActiveApp()
    if _.isString c
      options = _.extend {}, options
      options.authorizedViewClassNames = @getNavItems()
      options.authorizedViewClasses = _.map options.authorizedViewClassNames, (name) => app.getView name
      if c == 'MorePage'
        options.collection = @collection
      if options.authorizedViewClassNames.indexOf(c) > -1
        options.footerTemplate = '''
          <div data-role="footer" data-id="ap-footer" data-position="fixed" data-tap-toggle="false">
            <div data-role="navbar">
              <ul>
                {% _.each(authorizedViewClasses, function (c) { %}
                  <li>
                    <a href="#" data-page="{{ c.prototype.id }}" data-view-class="{{ c.prototype.name }}" data-icon="custom" class="{% if (c.prototype.name == viewName) { %}ui-btn-active {% } %}">
                      <span>
                        <i class="fa fa-2x fa-{{ c.prototype.icon }}"></i>
                        <span>{{ c.prototype.title }}</span>
                      </span>
                    </a>
                  </li>
                {% }) %}
              </ul>
            </div>
          </div>
        '''
      else
        options.backButton = true
        options.previousPage = AP.Viewport.getCurrentItem()
      AP.Viewport.showItemByClass(c, options)
  
  getAuthorizedItems: ->
    app = AP.getActiveApp()
    _.filter @initialItems, (name) =>
      AP.auth.Authorization.isAuthorized(app.getView(name)::rules)
  
  # returns all items if there are five or fewer, else returns the first four
  # only authorized items are included
  getNavItems: ->
    authorizedItems = @getAuthorizedItems()
    itemCount = authorizedItems.length
    if itemCount <= 5
      authorizedItems?.slice()
    else
      authorizedItems.slice(0, 4).concat(['MorePage'])
  
  # returns all items after the fourth, if there are more than five
  # only authorized items are included
  getMoreItems: ->
    authorizedItems = @getAuthorizedItems()
    itemCount = authorizedItems.length
    if itemCount > 5
      authorizedItems.slice 4
    else
      null
