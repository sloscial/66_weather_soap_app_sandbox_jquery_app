null
###*
@class AP.view.List
@extends AP.view.DataView

A data view that shows `AP.view.ListItem` views in a jQuery Mobile list.
###
class AP.view.List extends AP.view.DataView
  ###*
  @inheritdoc
  ###
  className: 'ap-dataview ap-list'
  
  ###*
  @property {Boolean}
  `true` if this list should use the jQuery Mobile inset list style.
  ###
  inset: true
  
  ###*
  @private
  @property {AP.view.View}
  Internal reference to a "load more" button view instance.
  ###
  moreButton: null
  
  ###*
  @property {String}
  jQuery Mobile list template.
  ###
  template: '''
    <ul data-role="listview" {% if (inset) { %} data-inset="{{ inset }}"{% } %}></ul>
  '''
  
  ###*
  @inheritdoc
  ###
  events:
    'click li': 'onItemClick'
    'action .ap-more-button': 'onMoreAction'
    'render li': 'onItemRender'
  
  ###*
  Adds the "load more" button view instance via `appendExtra`.
  @inheritdoc
  ###
  initialize: ->
    super
    @on 'datareset', @onDataReset, @
    @moreButton = new AP.view.Button(
      className: 'ap-button ap-more-button'
      title: 'Load More&hellip;'
      hidden: true
      parent: @)
    @appendExtra @moreButton.el
  
  onItemClick: (e) ->
    e.preventDefault() if $(e.currentTarget).data('view').linked
    record = $(e.currentTarget)?.data('record')
    @$el.trigger 'select', [@, record]
  
  onMoreAction: ->
    @currentPage++
    @fetch()
  
  onDataReset: ->
    if @collection and @collection.length
      @moreButton.show() if @paginate and @perPage and (@collection.previousLength != @collection.length) and (@collection.length == (@perPage * @currentPage))
      @refreshListView()
      @$el.find('ul').show()
    else
      @$el.find('ul').hide()
  
  onItemRender: -> @refreshListView()
  
  ###*
  Executes the jQuery Mobile listview `refresh` method if the list is visible.
  ###
  refreshListView: ->
    @$el.find('ul').listview('refresh') #if @$el.is(':visible')
  
  ###*
  @inheritdoc
  ###
  append: (el) -> @$el.find('ul').append el
  
  ###*
  @inheritdoc
  ###
  appendExtra: (el) -> @$el.append el
  
  ###*
  Returns the list item class.  Override to specify a different data
  view item class.
  @return {AP.view.ListItem} list item class or one of its subclasses
  ###
  getItemClass: -> AP.view.ListItem
