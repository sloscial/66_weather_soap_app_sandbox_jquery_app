null
###*
@class AP.view.ListItem
@extends AP.view.DataViewItem

List item is a view for displaying a single record within a jQuery Mobile list.
###
class AP.view.ListItem extends AP.view.DataViewItem
  ###*
  @inheritdoc
  ###
  className: 'ap-dataviewitem ap-listitem'
  
  ###*
  @inheritdoc
  ###
  tagName: 'li'
  
  ###*
  @property {Boolean}
  Display the item with the jQuery Mobile disclosure arrow?
  ###
  linked: true
  
  ###*
  @property {String}
  Optional template of content to render in the list item immediately before any
  othercontent.
  ###
  before: null
  
  ###*
  @property {String}
  Optional URL template to an image to render into the list item.
  ###
  imageUrl: null
  
  ###*
  @property {String}
  Optional template used to render the item title.
  ###
  itemTitle: null
  
  ###*
  @property {String}
  Optional template of content to render in the list item.
  ###
  itemContent: null
  
  ###*
  @property {String}
  Optional template of content to render in the list item immediately after any
  othercontent.
  ###
  after: null
  
  ###*
  @property {String}
  Template for a jQuery Mobile list item.
  ###
  template: '''
    {% if (linked) { %}
      <a href="#">
    {% } %}
      {% if (before) { %}
        {{ renderAttr("before") }}
      {% } %}
      {% if (imageUrl) { %}
        <img src="{%- renderAttr("imageUrl") %}">
      {% } %}
      {% if (itemTitle) { %}
        <h2>{{ renderAttr("itemTitle") }}</h2>
      {% } %}
      {% if (itemContent) { %}
        {{ renderAttr("itemContent") }}
      {% } %}
      {% if (after) { %}
        {{ renderAttr("after") }}
      {% } %}
    {% if (linked) { %}
      </a>
    {% } %}
  '''
  
  ###*
  @inheritdoc
  ###
  append: (el) ->
    if !@linked
      super
    else
      @$el.find('a').append el
  
  ###*
  Before rendering as normal, strips all data attributes from the HTML element
  used by jQuery Mobile.  This forces jQuery Mobile to reinitialize the item and
  is a critical step when arbitrarily rendering lists.
  @inheritdoc
  ###
  render: ->
    # remove data and classes so jQuery Mobile does not think this is
    # already initialized
    @$el.removeData()
    @$el.attr('class', @className)
    super
    @
