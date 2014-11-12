null
###*
@class AP.view.Carousel
@extends AP.view.DataView

A data view that shows `AP.view.CarouselItem` views in a
touch-enabled slideshow.
###
class AP.view.Carousel extends AP.view.DataView
  ###*
  @inheritdoc
  ###
  className: 'ap-dataview ap-carousel'
  
  ###*
  @private
  @property {Number}
  Currently active 0-indexed slide index.
  ###
  active: 0
  
  ###*
  @private
  @property {Number}
  Used internally to track the available width for this carousel and to
  calculate slide animations.
  ###
  width: null
  
  ###*
  @private
  @property {Boolean}
  Cancel click/tap events temporarily?  Used internally immediately following
  swipe events.
  ###
  clickCancelled: false
  
  ###*
  @private
  @property {Number}
  Internal reference to the timeout currently waiting before click/tap events
  may be reenabled.
  ###
  clickCancelTimeout: null
  
  ###*
  @property {Boolean}
  Automatically scroll through carousel items?
  ###
  autoCycle: true
  
  ###*
  @property {Number}
  Wait period before automatically scrolling to the next slide in milliseconds.
  ###
  autoCycleInterval: 3000
  
  ###*
  @private
  @property {Number}
  Internal reference to the timeout currently waiting to autoscroll.
  ###
  autoCycleTimeout: null
  
  ###*
  @property {String}
  A simple carousel template.
  ###
  template: '''
    <div class="ap-carousel-container">
      <div class="ap-carousel-slider"></div>
    </div>
  '''
  
  ###*
  @inheritdoc
  ###
  events:
    'swipeleft': 'onSwipeLeft'
    'swiperight': 'onSwipeRight'
    'click .ap-carouselitem': 'onItemClick'
  
  ###*
  @inheritdoc
  ###
  initialize: ->
    super
    @on 'datareset', @onDataReset, @
  
  onSwipeLeft: (e) ->
    @cancelClick()
    @nextItem()

  onSwipeRight: (e) ->
    @cancelClick()
    @previousItem()
  
  onItemClick: (e) ->
    e.preventDefault()
    AP.defer 50, =>
    if !@clickCancelled
      record = $(e.currentTarget)?.data('record')
      @$el.trigger 'select', [@, record]
  
  onDataReset: ->
    if @collection
      @active = 0
      @updateDimensions()
      @resetAutoCycle()
  
  ###*
  @private
  Temporarily cancel click/tap events.  Used immediately following swipe events.
  ###
  cancelClick: ->
    @clickCancelled = true
    clearTimeout @clickCancelTimeout
    @clickCancelTimeout = setTimeout((=> @clickCancelled = false), 500)
  
  ###*
  @inheritdoc
  ###
  appendExtra: (el) -> @$el.append el
  
  ###*
  @inheritdoc
  ###
  append: (el) -> @getSliderEl().append el
  
  ###*
  @return {Element} jQuery-wrapped reference to the carousel slider element.
  ###
  getSliderEl: -> @$el.find('.ap-carousel-slider')
  
  ###*
  Returns the carousel item class.  Override to specify a different data
  view item class.
  @return {AP.view.CarouselItem} carousel item class or one of its subclasses
  ###
  getItemClass: -> AP.view.CarouselItem
  
  ###*
  Gets the current width of the carousel container.  Sets the width of all
  carousel item elements to this new width.
  ###
  updateDimensions: ->
    width = @$el.width()
    # zero width should be ignored as this occurrs when the page is hidden
    if width
      @width = width
      @$el.find('.ap-carouselitem').width @width
  
  ###*
  Clears and resets the auto-cycle timer.  Useful after user interaction.
  ###
  resetAutoCycle: ->
    clearTimeout @autoCycleTimeout
    @autoCycleTimeout = setTimeout((=>
      @nextItem() if @autoCycle
    ), @autoCycleInterval)
  
  ###*
  Scroll to an arbitrary carousel item specified by index.
  @param {Number} index location of a carousel item to scroll to
  ###
  nItem: (index) ->
    if index < @collection.size()
      @updateDimensions()
      @active = index
      @$el.find('.ap-carousel-slider').css
        left: -(@active * @width)
      @resetAutoCycle()
  
  ###*
  Scroll to the first carousel item.
  ###
  firstItem: -> @nItem(0)
  
  ###*
  Scroll to the next carousel item.
  ###
  nextItem: ->
    if @active < @collection.size() - 1
      @nItem(@active + 1)
    else if @active == @collection.size() - 1
      @firstItem()
  
  ###*
  Scroll to the previous carousel item.
  ###
  previousItem: -> @nItem(@active - 1) if @active > 0
