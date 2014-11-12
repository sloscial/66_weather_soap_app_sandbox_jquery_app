null
###*
@class AP.view.CarouselItem
@extends AP.view.DataViewItem

Carousel item is a view for displaying a single record within
a {@link AP.view.Carousel}.
###
class AP.view.CarouselItem extends AP.view.DataViewItem
  ###*
  @inheritdoc
  ###
  className: 'ap-dataviewitem ap-carouselitem'
  
  linked: true
  
  ###*
  @property {String}
  Optional template of content to render in the carousel item immediately before
  any othercontent.
  ###
  before: null
  
  ###*
  @property {String}
  Optional URL to an image to render into the carousel item.
  ###
  imageUrl: null
  
  ###*
  @property {String}
  Optional template used to render the item title.
  ###
  itemTitle: null
  
  ###*
  @property {String}
  Optional template of content to render in the carousel item.
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
  Carousel item template with an image and optional details (title and content).
  ###
  template: '''
    {% if (imageUrl) { %}
      <div class="ap-carouselitem-image" style="background-image: url({{ imageUrl }});"></div>
    {% } %}
    <div class="ap-carouselitem-detail">
      {% if (itemTitle) { %}
        <div class="ap-carouselitem-title">{%- renderAttr("itemTitle") %}</div>
      {% } %}
      {% if (itemContent) { %}
        <div class="ap-carouselitem-content">{{ renderAttr("itemContent") }}</div>
      {% } %}
    </div>
  '''
